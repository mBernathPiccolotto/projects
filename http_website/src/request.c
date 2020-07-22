/* request.c: HTTP Request Functions */

#include "server.h"

#include <errno.h>
#include <string.h>

#include <unistd.h>

int parse_request_method(Request *r);
int parse_request_headers(Request *r);
Header* header_create(char *name, char *data);

/**
 * Accept request from server socket.
 *
 * @param   sfd         Server socket file descriptor.
 * @return  Newly allocated Request structure.
 *
 * This function does the following:
 *
 *  1. Allocates a request struct initialized to 0.
 *  2. Initializes the headers list in the request struct.
 *  3. Accepts a client connection from the server socket.
 *  4. Looks up the client information and stores it in the request struct.
 *  5. Opens the client socket stream for the request struct.
 *  6. Returns the request struct.
 *
 * The returned request struct must be deallocated using free_request.
 **/
Request * accept_request(int sfd) {
    Request *r;
    struct sockaddr raddr;
    socklen_t rlen = sizeof(struct sockaddr);

    /* Allocate request struct (zeroed) */
    r = calloc(1,sizeof(Request));
    if(!r){
        goto fail;
    }
    /* Accept a client */
    r->fd = accept(sfd, &raddr, &rlen);
    if(r->fd < 0){
        goto fail;
    }
    /* Lookup client information */
    int status = getnameinfo(&raddr, rlen, r->host, sizeof(r->host), r->port, sizeof(r->port), NI_NUMERICHOST | NI_NUMERICSERV);
    if(status<0){
        goto fail;
    }
    /* Open socket stream */
    r->stream = fdopen(r->fd, "w+");
    if(!r->stream){
        goto fail;
    }
    log("Accepted request from %s:%s", r->host, r->port);
    return r;

fail:
    /* Deallocate request struct */
    free_request(r);
    return NULL;
}

/**
 * Deallocate request struct.
 *
 * @param   r           Request structure.
 *
 * This function does the following:
 *
 *  1. Closes the request socket stream or file descriptor.
 *  2. Frees all allocated strings in request struct.
 *  3. Frees all of the headers (including any allocated fields).
 *  4. Frees request struct.
 **/

void header_delete(Header *h) {

    if(!h){
        return;
    }

    // Calling recursion to delete SLL
    if(h->next != NULL){
        header_delete(h->next);
    }

    // Deleting the struct
    free(h->name);
    free(h->data);

    free(h);
}

void free_request(Request *r) {
    if (!r) {
    	return;
    }

    // Close file
    fclose(r->stream);

    /* Close socket or fd */
    close(r->fd);
    /* Free allocated strings */
    free(r->method);
    free(r->uri);
    free(r->query);
    free(r->path);
    /* Free headers */
    header_delete(r->headers);
    /* Free request */
    free(r);

    return;
}

/**
 * Parse HTTP Request.
 *
 * @param   r           Request structure.
 * @return  -1 on error and 0 on success.
 *
 * This function first parses the request method, any query, and then the
 * headers, returning 0 on success, and -1 on error.
 **/
int parse_request(Request *r) {
    /* Parse HTTP Request Method */
    if(parse_request_method(r) < 0){
        return -1;
    }
    /* Parse HTTP Request Headers*/
    if(parse_request_headers(r) < 0){
        return -1;
    }
    return 0;
}

/**
 * Parse HTTP Request Method and URI.
 *
 * @param   r           Request structure.
 * @return  -1 on error and 0 on success.
 *
 * HTTP Requests come in the form
 *
 *  <METHOD> <URI>[QUERY] HTTP/<VERSION>
 *
 * Examples:
 *
 *  GET / HTTP/1.1
 *  GET /cgi.script?q=foo HTTP/1.0
 *
 * This function extracts the method, uri, and query (if it exists).
 **/
int parse_request_method(Request *r) {
    char buffer[BUFSIZ];
    char *method;
    char *uri;
    char *query;
    /* Read line from socket */
    if (!fgets(buffer, BUFSIZ, r->stream)) {
        goto fail;
    }
    /* Parse method and uri */
    method = strtok(buffer, WHITESPACE);
    uri = strtok(NULL, WHITESPACE);
    if(!method || !uri){
        goto fail;
    }
    /* Parse query from uri */
    query = strchr(uri,'?');
    if(query){
        query++;
    }
    /* Record method, uri, and query in request struct */
    r->method = strdup(method);
    if(uri){
        uri = strtok(uri,"?");
        r->uri = strdup(uri);
    }else{
        r->uri = strdup("");
    }
    if(query){
        r->query = strdup(query);
    }else{
        r->query = strdup("");
    }

    return 0;

fail:
    return -1;
}

/**
 * Parse HTTP Request Headers.
 *
 * @param   r           Request structure.
 * @return  -1 on error and 0 on success.
 *
 * HTTP Headers come in the form:
 *
 *  <NAME>: <DATA>
 *
 * Example:
 *
 *  Host: localhost:8888
 *  User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0
 *  Accept: text/html,application/xhtml+xml
 *  Accept-Language: en-US,en;q=0.5
 *  Accept-Encoding: gzip, deflate
 *  Connection: keep-alive
 *
 * This function parses the stream from the request socket using the following
 * pseudo-code:
 *
 *  while (buffer = read_from_socket() and buffer is not empty):
 *      name, data  = buffer.split(':')
 *      header      = new Header(name, data)
 *      headers.append(header)
 **/
int parse_request_headers(Request *r) {
    Header *curr = NULL;
    char buffer[BUFSIZ];
    char *name;
    char *data;

    // Getting first header
    if(fgets(buffer,BUFSIZ,r->stream) && strlen(buffer)>2){
        name = strtok(buffer,":");
        data = strtok(NULL,"");
        r->headers = header_create(name,data);
        if(!r->headers){
            goto fail;
        }
        curr = r->headers;
    }else{
        goto fail;
    }

    // Getting other headers and adding them to linked list
    while(fgets(buffer,BUFSIZ,r->stream) && strlen(buffer)>2){
        name = strtok(buffer,":");
        data = strtok(NULL,"");
        curr->next = header_create(name, data);
        if(!curr->next){
            goto fail;
        }
        curr = curr->next;
    }
/*#ifndef NDEBUG
    for (Header *header = r->headers; header; header = header->next) {
    	debug("HTTP HEADER %s = %s", header->name, header->data);
    }
#endif
*/
    return 0;

fail:
    return -1;
}

// Create new header entry
Header* header_create(char* name, char* data) {
        if(!name || !data){
            return NULL;
        }
        Header* new_node = (Header *) calloc(1,sizeof(Header));
        if(!new_node){
            return NULL;
        }
        new_node->name = strdup(name);
        new_node->data = strdup(data);
        return new_node;
    }
/* vim: set expandtab sts=4 sw=4 ts=8 ft=c: */
/* handler.c: HTTP Request Handlers */

#include "server.h"

#include <errno.h>
#include <limits.h>
#include <string.h>

#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

/* Internal Declarations */
Status handle_browse_request(Request *request);
Status handle_file_request(Request *request);
Status handle_cgi_request(Request *request);
Status handle_error(Request *request, Status status);

/**
 * Handle HTTP Request.
 *
 * @param   r           HTTP Request structure
 * @return  Status of the HTTP request.
 *
 * This parses a request, determines the request path, determines the request
 * type, and then dispatches to the appropriate handler type.
 *
 * On error, handle_error should be used with an appropriate HTTP status code.
 **/
Status  handle_request(Request *r) {
    Status result;
    struct  stat s;
    char *path;

    /* Parse request */
    if(parse_request(r) < 0){
        log("Parse Request Failed");
        result = HTTP_STATUS_BAD_REQUEST;
        goto fail;
    }

    /* Determine request path */
    path = determine_request_path(r->uri);
    if(!path){
        log("Determine Request Path Failed");
        result = HTTP_STATUS_NOT_FOUND;
        goto fail;
    }
    r->path = path;

    /* Dispatch to appropriate request handler type based on file type */
    if((stat(r->path,&s)==0) && (S_ISREG(s.st_mode) != 0)){
        if(access(r->path,X_OK)==0){
            // File is an executable
            result = handle_cgi_request(r);
        }
        else
            // Normal File
            result = handle_file_request(r);
    }

    if((stat(r->path,&s)==0 )&& (S_ISDIR(s.st_mode) != 0)){
        // Wants to acess a directory
        result = handle_browse_request(r);
    }

    if(result != HTTP_STATUS_OK){
        result = handle_error(r,result);
    }

    return result;

fail:
    /* Output error message */
    result = handle_error(r,result);
    return result;
}

/**
 * Handle browse request.
 *
 * @param   r           HTTP Request structure.
 * @return  Status of the HTTP browse request.
 *
 * This lists the contents of a directory in HTML.
 *
 * If the path cannot be opened or scanned as a directory, then handle error
 * with HTTP_STATUS_NOT_FOUND.
 **/
Status  handle_browse_request(Request *r) {
    log("request is a directory");
    struct dirent **entries;
    int n;
    /* Open a directory for reading or scanning */
    n = scandir(r->path,&entries,0,alphasort);
    if(n<0){
        return HTTP_STATUS_NOT_FOUND;
    }

    /* Write HTTP Header with OK Status and text/html Content-Type */
    fprintf(r->stream, "HTTP/1.0 200 OK\r\n");
    fprintf(r->stream, "Content-Type: text/html\r\n");
    fprintf(r->stream,"\r\n");
    fprintf(r->stream,"<!DOCTYPE html>\n");
    fprintf(r->stream,"<html>\n");
    fprintf(r->stream,"<head>\n");
    fprintf(r->stream,"<link rel = \"stylesheet\" type=\"text/css\" href = \"https://codepen.io/meg-n-cheese12/pen/jObLNjB.css\">\n");
    fprintf(r->stream,"</head>\n");
    fprintf(r->stream,"<body>\n");
    /* For each entry in directory, emit HTML list item */
    fprintf(r->stream, "<ul>\n");
    for(int i = 0; i<n; i++){
        // Ignoring .
        if(streq(entries[i]->d_name,".")){
            free(entries[i]);
            continue;
        }
        if(streq(r->uri,"/")){//if it is the main directory
            fprintf(r->stream, "<li><a href=\"/%s\">%s</a></li>\n", entries[i]->d_name,entries[i]->d_name);
        }
        else{//it's not the main directory

            // Only add / if it does not end with /
            int length = strlen(r->uri);
            if(streq(&(r->uri[length - 1]),"/"))
                fprintf(r->stream, "<li><a href=\"%s%s\">%s</a></li>\n", r->uri,entries[i]->d_name,entries[i]->d_name);
            else
                fprintf(r->stream, "<li><a href=\"%s/%s\">%s</a></li>\n", r->uri,entries[i]->d_name,entries[i]->d_name);
        }
        free(entries[i]);
    }
    fprintf(r->stream,"</ul>\n");
    fprintf(r->stream,"</body>\n");
    fprintf(r->stream,"</html>\n");
    free(entries);



    /* Return OK */
    return HTTP_STATUS_OK;
}

/**
 * Handle file request.
 *
 * @param   r           HTTP Request structure.
 * @return  Status of the HTTP file request.
 *
 * This opens and streams the contents of the specified file to the socket.
 *
 * If the path cannot be opened for reading, then handle error with
 * HTTP_STATUS_NOT_FOUND.
 **/
Status  handle_file_request(Request *r) {
    log("request is a file");
    FILE *fs;
    char buffer[BUFSIZ];
    char *mimetype = NULL;
    size_t nread;

    /* Open file for reading */
    fs = fopen(r->path, "r");
    if(!fs) {
        return HTTP_STATUS_NOT_FOUND;
    }

    /* Determine mimetype */
    mimetype = determine_mimetype(r->path);
    log("mimetype is %s", mimetype);
    if(!mimetype){
        goto fail;
    }
    /* Write HTTP Headers with OK status and determined Content-Type */
    fprintf(r->stream,"HTTP/1.0 200 OK\r\n");
    fprintf(r->stream,"Content-Type: %s\r\n",mimetype);
    fprintf(r->stream,"\r\n");

    /* Read from file and write to socket in chunks */
    while((nread=fread(buffer,1,BUFSIZ,fs)) > 0){
        fwrite(buffer,1,nread,r->stream);
    }

    /* Close file, deallocate mimetype, return OK */
    fclose(fs);
    free(mimetype);
    return HTTP_STATUS_OK;

fail:
    /* Close file, free mimetype, return INTERNAL_SERVER_ERROR */
    fclose(fs);
    return HTTP_STATUS_INTERNAL_SERVER_ERROR;
}


/**
 * Handle CGI request
 *
 * @param   r           HTTP Request structure.
 * @return  Status of the HTTP file request.
 *
 * This popens and streams the results of the specified executables to the
 * socket.
 *
 * If the path cannot be popened, then handle error with
 * HTTP_STATUS_INTERNAL_SERVER_ERROR.
 **/
Status  handle_cgi_request(Request *r) {
    log("request is a cgi");
    FILE *pfs;
    char buffer[BUFSIZ];
    size_t nread;
    /* Export CGI environment variables from request:
    * http://en.wikipedia.org/wiki/Common_Gateway_Interface */
    if(setenv("DOCUMENT_ROOT",RootPath,1)<0){
        log("could not set document root");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("QUERY_STRING",r->query,1)<0){
        log("could not set query string");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("REMOTE_ADDR",r->host,1)<0){
        log("could not set remote address");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("REMOTE_PORT",r->port,1)<0){
        log("could not set remote port");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("REQUEST_METHOD",r->method,1)<0){
        log("could not set request method");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("REQUEST_URI",r->uri,1)<0){
        log("could not set request uri");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("SCRIPT_FILENAME",r->path,1)<0){
        log("could not set script filename");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    if(setenv("SERVER_PORT",Port,1)<0){
        log("could not set server port");
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }

    /* Export CGI environment variables from request headers */
    for (Header *header = r->headers; header; header = header->next) {
        if(setenv("HTTP_HOST",header->data,1)<0){
            log("could not set HTTP_HOST");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
        if(setenv("HTTP_ACCEPT",header->data,1)<0){
            log("could not set HTTP_ACCEPT");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
        if(setenv("HTTP_ACCEPT_LANGUAGE",header->data,1)<0){
            log("could not set HTTP_ACCEPT_LANGUAGE");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
        if(setenv("HTTP_ACCEPT_ENCODING",header->data,1)<0){
            log("could not set HTTP_ACCEPT_ENCODING");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
        if(setenv("HTTP_CONNECTION",header->data,1)<0){
            log("could not set HTTP_CONNECTION");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
        if(setenv("HTTP_USER_AGENT",header->data,1)<0){
            log("could not set HTTP_USER_AGENT");
            return HTTP_STATUS_INTERNAL_SERVER_ERROR;
        }
    }

    /* Popen CGI Script */
    pfs = popen(r->path,"r");
    if(!pfs){
        return HTTP_STATUS_INTERNAL_SERVER_ERROR;
    }
    /* Copy data from popen to socket */
    while((nread=fread(buffer,1,BUFSIZ,pfs)) > 0){
        fwrite(buffer,1,nread,r->stream);
    }
    /* Close popen, return OK */
    pclose(pfs);
    return HTTP_STATUS_OK;
}

/**
 * Handle displaying error page
 *
 * @param   r           HTTP Request structure.
 * @return  Status of the HTTP error request.
 *
 * This writes an HTTP status error code and then generates an HTML message to
 * notify the user of the error.
 **/
Status  handle_error(Request *r, Status status) {
    log("handling error request");
    const char *status_string = http_status_string(status);


    /* Write HTTP Header */
    fprintf(r->stream, "HTTP/1.0 %s\r\n", status_string);
    fprintf(r->stream, "Content-Type: text/html\r\n");
    fprintf(r->stream,"\r\n");
    fprintf(r->stream,"<!DOCTYPE html>\n");
    fprintf(r->stream,"<html>\n");
    fprintf(r->stream,"<head>\n");
    /* Write HTML Description of Error*/
    fprintf(r->stream, "<h1>%s\n</h1>\n",status_string);
    fprintf(r->stream, "<h2>Jokes aside, you are probably the one that screwed up\n</h2>\n");
    fprintf(r->stream, "<img src=\"https://imgs.xkcd.com/comics/unreachable_state_2x.png\" alt=\"Error Comic\" height=\"470\" width=\"357\">");
    fprintf(r->stream,"</body>\n");
    fprintf(r->stream,"</html>\n");

    /* Return specified status */
    return status;
}

/* vim: set expandtab sts=4 sw=4 ts=8 ft=c: */
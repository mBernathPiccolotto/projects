CC=		gcc
CFLAGS=		-g -Wall -Werror -std=gnu99 -Iinclude
LD=		gcc
LDFLAGS=	-Llib
AR=		ar
ARFLAGS=	rcs
TARGETS=	bin/server

all:		$(TARGETS)

clean:
	@echo Cleaning...
	@rm -f $(TARGETS) lib/*.a src/*.o *.log *.input

.PHONY:		all test clean

# Objects

src/forking.o:	src/forking.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/handler.o:	src/handler.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/request.o:	src/request.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/single.o:	src/single.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/socket.o:	src/socket.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/utils.o:	src/utils.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

src/server.o:	src/server.c	include/server.h
	@echo Compiling $@
	@$(CC) $(CFLAGS) -c -o $@ $<

# Library

lib/libserver.a:	src/forking.o	src/handler.o	src/request.o	src/single.o	src/socket.o	src/utils.o
	@echo Linking $@
	@$(AR) $(ARFLAGS) $@ $^	

# Executables

bin/server: src/server.o	lib/libserver.a
	@echo Linking $@
	@$(LD) $(LDFLAGS) -o $@ $^	$(LIBS)
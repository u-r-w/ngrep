#
# Copyright (c) 2017  Jordan Ritter <jpr5@darkridge.com>
#
# Please refer to the LICENSE file for more information.

CC=gcc

CPPFLAGS = -DHAVE_CONFIG_H -DLINUX  -D_BSD_SOURCE=1 -D__FAVOR_BSD=1 
CFLAGS   =  -Iregex-0.12 -I/usr/include/pcap -g -O2 
LDFLAGS  =  
LIBS     = -lpcap  

STRIPFLAG=-s

OBJS=ngrep.o 
TARGET=ngrep
MANPAGE=ngrep.8

prefix      = /usr
exec_prefix = ${prefix}

bindir      = ${exec_prefix}/bin
datadir     = ${prefix}/share
mandir      = ${prefix}/share/man

BINDIR_INSTALL = $(bindir)
MANDIR_INSTALL = $(mandir)/man8

INSTALL = ./install-sh

REGEX_OBJS=regex-0.12/regex.o
REGEX_DIR=regex-0.12


all: $(TARGET)

$(TARGET): $(REGEX_OBJS) $(OBJS)
	$(CC) $(STRIPFLAG) -o $(TARGET) $(OBJS) $(REGEX_OBJS) $(LDFLAGS) $(LIBS)

debug: $(REGEX_OBJS) $(OBJS)
	$(CC) -g -o $(TARGET) $(OBJS) $(REGEX_OBJS) $(LDFLAGS) $(LIBS)

static: $(REGEX_OBJS) $(OBJS)
	$(CC) $(STRIPFLAG) -static -o $(TARGET).static $(OBJS) $(REGEX_OBJS) $(LDFLAGS) $(LIBS)

install: $(TARGET)
	$(INSTALL) -c -m 0755 $(TARGET)  $(DESTDIR)/$(BINDIR_INSTALL)/$(TARGET)
	$(INSTALL) -c -m 0644 $(MANPAGE) $(DESTDIR)/$(MANDIR_INSTALL)/$(MANPAGE)

.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -g -c $<

clean:
	test -n "$(REGEX_DIR)" && $(MAKE) -C $(REGEX_DIR) clean || exit 0
	rm -f *~ $(OBJS) $(REGEX_OBJS) $(TARGET) $(TARGET).static

distclean: clean
	test -n "$(REGEX_DIR)" && $(MAKE) -C $(REGEX_DIR) distclean || exit 0
	rm -f config.status config.cache config.log config.h Makefile

$(REGEX_OBJS): $(REGEX_OBJS:.o=.c) $(REGEX_DIR)/*.h
	$(MAKE) $(MAKEFLAGS) -C $(REGEX_DIR) $(notdir $(REGEX_OBJS))

$(OBJS): Makefile $(OBJS:.o=.c) $(OBJS:.o=.h)

tardist:
	@( VERSION=`perl -ne '/VERSION\s+"(.*)"/ && print "$$1\n"' ngrep.h` ; \
       PKG="ngrep-$$VERSION"                                            ; \
       TMPDIR="/tmp"                                                    ; \
       DESTDIR="$$TMPDIR/$$PKG"                                         ; \
       echo                                                             ; \
       echo "Building package $$PKG ... "                               ; \
       echo                                                             ; \
       sleep 2                                                          ; \
       rm -rf $$DESTDIR && mkdir $$DESTDIR                             && \
       make distclean                                                  && \
       tar --exclude "CVS" -cf - . | tar xf - -C $$DESTDIR             && \
       find $$DESTDIR -name "*~" -o -name ".*#*" | xargs rm -f         && \
       cd $$TMPDIR && tar zcf $$PKG.tar.gz $$PKG                        ; \
           rm -rf $$DESTDIR                                             ; \
           cd $$TMPDIR && gpg -ba $$PKG.tar.gz                          ; \
       echo                                                             ; \
       ls -l $$TMPDIR/$$PKG.tar.gz $$TMPDIR/$$PKG.tar.gz.asc            ; \
       echo                                                             ; \
    )

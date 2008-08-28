CC := gcc
AR := ar
CFLAGS := -Wall $(CFLAGS)
LDFLAGS := -L. -lossp $(LDFLAGS)

ifeq "$(origin OSSPD_CFLAGS)" "undefined"
OSSPD_CFLAGS := $(shell pkg-config --cflags fuse)
endif

ifeq "$(origin OSSPD_LDFLAGS)" "undefined"
OSSPD_LDFLAGS := $(shell pkg-config --libs fuse)
endif

ifeq "$(origin OSSP_PADSP_CFLAGS)" "undefined"
OSSP_PADSP_CFLAGS := $(shell pkg-config --cflags libpulse)
endif

ifeq "$(origin OSSP_PADSP_LDFLAGS)" "undefined"
OSSP_PADSP_LDFLAGS := $(shell pkg-config --libs libpulse)
endif

headers := ossp.h ossp-util.h

all: osspd ossp-padsp

libossp.a: ossp.c ossp.h ossp-util.c ossp-util.h
	$(CC) $(CFLAGS) -c -o ossp.o ossp.c
	$(CC) $(CFLAGS) -c -o ossp-util.o ossp-util.c
	$(AR) rc $@ ossp.o ossp-util.o

osspd: osspd.c libossp.a $(headers)
	$(CC) $(CFLAGS) $(OSSPD_CFLAGS) -o $@ $< $(OSSPD_LDFLAGS) $(LDFLAGS)

ossp-padsp: ossp-padsp.c libossp.a $(headers)
	$(CC) $(CFLAGS) $(OSSP_PADSP_CFLAGS) -o $@ $< $(OSSP_PADSP_LDFLAGS) $(LDFLAGS)

clean:
	rm -f *.o *.a osspd ossp-padsp

.POSIX:

XCFLAGS = ${CFLAGS} -nostdlib -std=c99 -fPIC -pthread \
		  -Wall -Wextra -Wno-pedantic -Wmissing-prototypes -Wstrict-prototypes \
		  -Wno-unused-parameter -I. $(shell pkg-config --cflags directfb-internal)
XLDFLAGS = ${LDFLAGS} -shared -Wl,-soname,libdirectfb_nvidia.so $(shell pkg-config --libs directfb-internal)

MODULEDIR = $(shell pkg-config --variable=moduledir directfb-internal)

OBJ = \
	nvidia_2d.o \
	nvidia_3d.o \
	nvidia.o \
	nvidia_overlay.o \
	nvidia_primary.o \
	nvidia_state.o \

all: libdirectfb_nvidia.so

.c.o:
	${CC} ${XCFLAGS} -c -o $@ $<

libdirectfb_nvidia.so: ${OBJ}
	${CC} ${XCFLAGS} -o $@ ${OBJ} ${XLDFLAGS}

install: libdirectfb_nvidia.so
	mkdir -p ${DESTDIR}${MODULEDIR}
	cp -f libdirectfb_nvidia.so ${DESTDIR}${MODULEDIR}/libdirectfb_nvidia.so
uninstall:
	rm -f ${DESTDIR}${MODULEDIR}/libdirectfb_nvidia.so

clean:
	rm -f libdirectfb_nvidia.so ${OBJ}

.PHONY: all clean install uninstall

# this Makefile creates a SwissEph library and a swetest sample on 64-bit
# Redhat Enterprise Linux RHEL 7.

# The mode marked as 'Linux' should also work with the GNU C compiler
# gcc on other systems. 

# If you modify this makefile for another compiler, please
# let us know. We would like to add as many variations as possible.
# If you get warnings and error messages from your compiler, please
# let us know. We like to fix the source code so that it compiles
# free of warnings.
# send email to the Swiss Ephemeris mailing list.
# 

CFLAGS =  -g -Wall -fPIC # for Linux and other gcc systems
#CFLAGS =  -O2 -Wall -fPIC # for Linux and other gcc systems
OP=$(CFLAGS)  
CC=cc	#for Linux

# compilation rule for general cases
.o :
	$(CC) $(OP) -o $@ $? -lm
.c.o:
	$(CC) -c $(OP) $<     

SWEOBJ = swedate.o swehouse.o swejpl.o swemmoon.o swemplan.o sweph.o\
	 swephlib.o swecl.o swehel.o

all:	swetest swemini

# build swetest with SE linked in, using dynamically linked system libraries libc, libm, libdl.
swetest: swetest.o libswe.so
	$(CC) $(OP) -o swetest swetest.o -L. -lswe -lm -ldl

swevents: swevents.o $(SWEOBJ)
	$(CC) $(OP) -o swevents swevents.o $(SWEOBJ) -lm -ldl

swemini: swemini.o libswe.so
	$(CC) $(OP) -o swemini swemini.o -L. -lswe -lm -ldl

# create an archive and a dynamic link libary fro SwissEph
# a user of this library will inlcude swephexp.h  and link with -lswe

libswe.so: $(SWEOBJ)
	$(CC) -shared -o libswe.so $(SWEOBJ)

test:
	cd setest && make && ./setest t

test.exp:
	cd setest && make && ./setest -g t

clean:
	rm -f *.o swetest libswe*
	cd setest && make clean


# Define default PREFIX if not provided
PREFIX ?= /usr/local

# Add an install target
install: all
	mkdir -p $(PREFIX)/bin
	mkdir -p $(PREFIX)/lib
	mkdir -p $(PREFIX)/include/sweph
	cp -p swetest $(PREFIX)/bin
	cp -p swemini $(PREFIX)/bin
	cp -p libswe.so $(PREFIX)/lib
	cp -p swephexp.h $(PREFIX)/include/sweph
	cp -p sweodef.h $(PREFIX)/include/sweph
	cp -p swedll.h $(PREFIX)/include/sweph
	cp -p sweph.h $(PREFIX)/include/sweph
	cp -p swephlib.h $(PREFIX)/include/sweph
	cp -p swehouse.h $(PREFIX)/include/sweph
	cp -p swejpl.h $(PREFIX)/include/sweph
	cp -p swemptab.h $(PREFIX)/include/sweph
	cp -p swenut2000a.h $(PREFIX)/include/sweph

###
swecl.o: swejpl.h sweodef.h swephexp.h swedll.h sweph.h swephlib.h
sweclips.o: sweodef.h swephexp.h swedll.h
swedate.o: swephexp.h sweodef.h swedll.h
swehel.o: swephexp.h sweodef.h swedll.h
swehouse.o: swephexp.h sweodef.h swedll.h swephlib.h swehouse.h
swejpl.o: swephexp.h sweodef.h swedll.h sweph.h swejpl.h
swemini.o: swephexp.h sweodef.h swedll.h
swemmoon.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h
swemplan.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h swemptab.h
sweph.o: swejpl.h sweodef.h swephexp.h swedll.h sweph.h swephlib.h
swephlib.o: swephexp.h sweodef.h swedll.h sweph.h swephlib.h
swetest.o: swephexp.h sweodef.h swedll.h
swevents.o: swephexp.h sweodef.h swedll.h

#!/bin/sh
#These codes/vars are now set in the calling makeall.sh 
################################################################################
# NCEP CODES
#SHELL=	/bin/sh
CMD=	seaice_preaverage
JMAIN=	preaverage.C
JCODE=	sicedrft
#JPROG=	GRUMBINE
#JORG=	NP21
################################################################################
#Linux 
#FC= ifort
#CC= g++
#COPTS= -O2 -Wall -DLINUX
#LIBS=$(BASE)/mmab/$(mmablib_ver)/libombf_4.a
#MMAB_INC=$(BASE)/mmab/$(mmablib_ver)/include/
################################################################################
#This is needed for constructing input met. files:
preaverage : preaverage.C
	$(CC) preaverage.C $(COPTS) -I $(MMAB_INC) $(MMAB_LIBF4) -lm -lirc -lsvml -o seaice_preaverage


#!/bin/sh
#These codes/vars are now set in the calling makeall.sh 
################################################################################
# NCEP CODES
CMD=	seaice_preaverage
JMAIN=	preaverage.C
JCODE=	sicedrft
#JPROG=	GRUMBINE
#Author: Robert Grumbine
#JORG=	NP21
################################################################################
#This is needed for constructing input met. files:
preaverage : preaverage.C
	$(CC) preaverage.C $(COPTS) -I $(MMAB_INC) $(LIBS) -lombf_4 -lm -lirc -lsvml -o seaice_preaverage


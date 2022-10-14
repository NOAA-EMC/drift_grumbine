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
################################################################################
#This is needed for constructing input met. files:
preaverage : preaverage.C
	#$(CC) preaverage.C $(COPTS) -I $(MMAB_INC) $(MMAB_LIBF4) -lm -lirc -lsvml -o seaice_preaverage
	$(CC) preaverage.C $(COPTS) -I $(MMAB_INC) $(BASE)/libombf_4.a -lm -lirc -lsvml -o seaice_preaverage


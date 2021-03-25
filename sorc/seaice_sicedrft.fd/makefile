#!/bin/sh
################################################################################
# NCEP CCS CODES -- general
SHELL=	/bin/sh
CMD=	seaice_sicedrft
JMAIN=	sicedrft.f
JCODE=	sicedrft
JPROG=	GRUMBINE
JORG=	NP21
################################################################################
################################################################################
#Linux 
#FC=ifort
#FOPTS=	
#LIBS=-L/Users/rmg3/usrlocal/mmab/v3.5.0/ -L/Volumes/ncep/nceplibs/ -lombf_4  -lw3emc_4 -lw3nco_4 
#LIBS=-L/Users/rmg3/usrlocal/mmab/v3.5.0/ -L/Volumes/ncep/nceplibs/ 
LOPTS=
OBJS= sicedrft.o uice.o movice.o fndflo.o getwin.o flovel.o sk2setup.o \
        gridset.o sk2out.o kmlout.o
OBJS90= convert.o
INCS=	sicedrft.inc
################################################################################

#--------------------------------------------------------------------------

$(CMD):	$(OBJS) $(OBJS90) 
	$(FC) $(LOPTS) $(OBJS) $(OBJS90) $(LIBS) -lombf_4  -o $(CMD)

$(OBJS):	makefile $(INCS) 
.f.o:
	$(FC) -c $(FOPTS) $<

$(OBJS90):	makefile

%.o : %.f90
	$(FC) -c $(FOPTS) $<

#This may be needed for construction of the fixed file input:
forecast.points : skpoints
	./skpoints > forecast.points
skpoints : skpoints.f
	$(FC) skpoints.f -o skpoints

clean:	
	-rm -f $(OBJS) $(OBJS90)

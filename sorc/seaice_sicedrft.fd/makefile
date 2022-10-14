#!/bin/sh
################################################################################
# NCEP CCS CODES -- general
SHELL=	/bin/sh
CMD=	seaice_sicedrft
JMAIN=	sicedrft.f
JCODE=	sicedrft
JPROG=	Grumbine
JORG=	NP21
################################################################################
LOPTS=
OBJS= sicedrft.o uice.o movice.o fndflo.o getwin.o flovel.o sk2setup.o \
        gridset.o sk2out.o kmlout.o convert.o
INCS=	sicedrft.inc
################################################################################

#--------------------------------------------------------------------------

$(CMD):	$(OBJS) 
	$(FC) $(LOPTS) $(OBJS) $(LIBS) -lombf_4  -o $(CMD)

$(OBJS):	makefile $(INCS) 

%.o: %.f90
	$(FC) -c $(FOPTS) $<

#This may be needed for construction of the fixed file input:
forecast.points : skpoints
	./skpoints > forecast.points
skpoints : skpoints.f
	$(FC) skpoints.f -o skpoints

clean:	
	-rm -f $(OBJS) $(OBJS90)

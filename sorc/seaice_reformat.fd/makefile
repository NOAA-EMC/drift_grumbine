#!/bin/sh

#mmablib -- arcdis, wdir
#w3lib -- w3utcdat, w3movdat, w3ai19

CMD= seaice_reformat
OBJS= reformat.o kmlout.o sk2out.o getfcst.o

.f90.o: 
	$(FC) -c $(FOPTS) $<

.f.o:
	$(FC) -c $(FOPTS) $<

%.o : %.f90
	$(FC) -c $(FOPTS) $<


$(CMD) : $(OBJS)
	$(FC) $(OBJS) -o $(CMD) $(LIBS) -lombf_4 

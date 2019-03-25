#mmablib -- arcdis, wdir
#w3lib -- w3utcdat, w3movdat, w3ai19

#LIBS=-L/Volumes/ncep/nceplibs/ -lw3nco_4 -L $(BASE)/mmab/$(mmablib_ver)/ -lombf_4

.f.o:
	$(FC) -c $(FOPTS) $*.f

OBJS = reformat.o kmlout.o sk2out.o getfcst.o

seaice_reformat : $(OBJS)
	$(FC) $(OBJS) -o seaice_reformat $(LIBS) -lombf_4 



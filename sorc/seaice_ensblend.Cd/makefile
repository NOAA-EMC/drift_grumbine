# These are now set by calling environment:
#COPTS= -Wall  -O2 -DLINUX 
#LIB=-L $(BASE)/mmab/$(mmablib_ver)
#INCDIR=$(BASE)/mmab/$(mmablib_ver)/include/

all : seaice_midpoints 

seaice_midpoints : midpoints.C centroid.C
	$(CC) $(COPTS) midpoints.C -I $(INCDIR) -o $(@) $(LIBS) -l ombf_4

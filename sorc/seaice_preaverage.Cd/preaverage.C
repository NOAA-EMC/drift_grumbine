#include "ncepgrids.h"

// Read in information from a gaussian grid,
//    interpolate it to a 1 degree lat-long in
//    NCEP convention, and average all to a 
//    single output file, written in fortran form
// This is done to hide from the sea ice drift program
//   the variable resolution of the GFS native grid,
//   versus the 1 degree of the ensembles.
// Robert Grumbine
// 14 March 2007
// Modify/update: quarter degree output, more consistent with
//   intended drift model resolution and GFS T574 resolution.
// 3 November 2011
// 30 April 2014 quarter degree grid now in mmablib

void cleanup(grid2<float> &x, float nonval) ;

template <class T>
int show(grid2<T> &x) ;


int main(int argc, char *argv[]) {
  FILE *fin, *fout;

  int npts;

// Using 0.5 degree GEFS files, not gaussian grids:
  //mrf1deg<float> ftmp;
  gfs_half<float> ftmp;
  gfs_quarter<float> tmp, avg;
  int i, k;
  float nonval = -9.e20, tmax = 0, tmin = 0;

  avg.set((float) 0.0);

  for (i = 0; i < ftmp.xpoints()*ftmp.ypoints() ; i++) {
    ftmp[i] = 0;
  }

  for (i = 2; i < argc; i++) {
    //printf("i = %d\n",i);
    fin = fopen(argv[i],"r");
    //npts = fread(ftmp, sizeof(float), maxpts, fin);
    npts = ftmp.binin(fin);
    fclose(fin);
    //printf("npts = %d\n",npts); fflush(stdout);
    for (k = 0; k < npts; k++) {
      if (ftmp[k] > tmax) tmax = ftmp[k];
      if (ftmp[k] < tmin) tmin = ftmp[k];
    }
    if (tmax >  3000.) { nonval = tmax; printf("new nonval = %f\n",nonval); }
    if (tmin < -3000.) { nonval = tmin; printf("new nonval = %f\n",nonval); }
    //printf("nonval = %f\n",nonval); fflush(stdout);
    tmp.fromall(ftmp, nonval, nonval);

    cleanup(tmp, nonval);
    avg += tmp;
  } // end of looping over arguments

  avg /= (argc - 2);

  //CDprintf("winds max, min, average, rms: %f %f %f %f\n",avg.gridmax(), avg.gridmin(),
  //CD        avg.average(), avg.rms() );
  fout = fopen(argv[1],"a");
  avg.ftnout(fout);
  fclose(fout);

  return 0;
}

template <class T>
int show(grid2<T> &x) {
  printf("%d by %d for %d points in grid\n",x.xpoints(), x.ypoints(),
            x.xpoints()*x.ypoints() );
  return x.xpoints()*x.ypoints();
}  


void cleanup(grid2<float> &x, float nonval) {
  int i;

  for (i = 0; i < x.xpoints() * x.ypoints() ; i++) {
    if (x[i] == nonval) {
      x[i] = 0.0; 
    }
    else if ( (x[i] >  3000.) || (x[i] < -3000.) )  {
      printf("resetting %f to %f at %d\n",(float) x[i], (float) 0, (int) i);
      x[i] = 0.0;
    }
  }

  return;
}

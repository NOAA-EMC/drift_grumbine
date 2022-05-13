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
// 30 April 2014 quater degree grid now in mmablib

void cleanup(grid2<float> &x, float nonval) ;

template <class T>
int show(grid2<T> &x) ;

// These might be suitable for inclusion in gaussian class?
#define T574 1548800 
#define T382  663552
#define T254  294912
#define T190  165888
#define T170  131072
#define T126   72960
#define T62    18048

int main(int argc, char *argv[]) {
  FILE *fin, *fout;

  //float *ftmp;
  int npts;
  gaussian<float> t574(574);
  gaussian<float> t382(382), t254(254), t170(170), t190(190);
  gaussian<float> t126(126), t62(62);

// Using 1 degree GEFS files, not gaussian grids:
  mrf1deg<float> ftmp;
  gfs_quarter<float> tmp, avg;
  int i, k;
  float nonval = -9.e20, tmax = 0, tmin = 0;

//debug  show(t574); show(t382); show(t254); show(t190); show(t170);
  #ifdef VERBOSE
    int maxpts;
    maxpts = t574.xpoints() * t574.ypoints();
    printf("maxpts = %d\n",maxpts); fflush(stdout);
  //ftmp = new float[maxpts];
  #endif
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
#ifdef GAUSSIAN
    switch(npts) {
       case T574 :
         printf("t574\n");
         for (k = 0; k < T574; k++) {
           t574[k] = ftmp[k];
         }
         tmp.fromall(t574, nonval, nonval);
         break;
       case T382 :
         printf("t382\n");
         for (k = 0; k < T382; k++) {
           t382[k] = ftmp[k];
         }
         tmp.fromall(t382, nonval, nonval);
         break;
       case T254 :
         printf("t254\n");
         for (k = 0; k < T254; k++) {
           t254[k] = ftmp[k];
         }
         tmp.fromall(t254, nonval, nonval);
         break;
       case T190 :
         printf("t190\n");
         for (k = 0; k < T190; k++) {
           t190[k] = ftmp[k];
         }
         tmp.fromall(t190, nonval, nonval);
         break;
       case T170 :
         printf("t170\n");
         for (k = 0; k < T170; k++) {
           t170[k] = ftmp[k];
         }
         tmp.fromall(t170, nonval, nonval);
         break;
       case T126 :
         printf("t126\n");
         for (k = 0; k < T126; k++) {
           t126[k] = ftmp[k];
         }
         tmp.fromall(t126, nonval, nonval);
         break;
       case T62 :
         printf("t62\n");
         for (k = 0; k < T62; k++) {
           t62[k] = ftmp[k];
         }
         tmp.fromall(t62, nonval, nonval);
         break;
       default :
         printf("Encountered an unknown size grid! %d points\n",npts);
         fflush(stdout);
    } // end of switch
#endif

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

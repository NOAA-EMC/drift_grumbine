#!/bin/sh
#Author: Robert Grumbine

rm *.kml fort.6?

if [ ! -f fort.11 ] ; then
  gfortran Unit_in.f90 -o Unit_in
  ./Unit_in
fi
if [ ! -f fort.12 ] ; then
  gfortran Unit_in.f90 -o Unit_in
  ./Unit_in
fi
if [ ! -f fort.47 ] ; then
  ln -sf ../../fix/seaice_forecast.points .
  ln -sf seaice_forecast.points fort.47
fi
if [ ! -f fort.91 ] ; then
  ln -sf ../../fix/seaice_quote fort.91
fi

if [ -f grid_ds ] ; then
  rm grid_ds
fi

echo 20180423 > fort.90
echo 32 | ./seaice_sicedrft 

if [ ! -f outcheck ]  ;then
  gfortran Unit_out.f90 -o outcheck
fi
./outcheck

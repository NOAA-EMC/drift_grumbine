#!/bin/sh

#set -xe
#Author: Robert Grumbine

. ../versions/build.ver

sys=`hostname`

module list > /dev/null 2> /dev/null
if [ $? -ne 0 ] ; then
  echo On a system without the module software
  export BASE=${BASE:-/Users/rmg3/usrlocal/mmablib}
  export FC=gfortran
  export FOPTS='-O2 -std=f2008'
  export LIBS='-L/Volumes/ncep/nceplibs/ -l w3emc_4 -l w3nco_4 -l bacio_4 -L $(BASE)/$(mmablib_ver)/'
  export MMAB_VER=v3.5.0
else
#on a system with module software, such as wcoss2
#WCOSS2   module list
  module reset
  module load PrgEnv-intel/$PrgEnv_intel_ver
  module load intel/$intel_ver
  module load craype/$craype_ver
  module load w3nco/$w3nco_ver
  echo zzz in makeall.sh loaded modules:
  module list
  export FC=ifort
  export FOPTS='-O2 -std95'
  export BASE=${BASE:-$HOME/rgdev/mmablib}
  export LIBS='-L $(BASE)/ $(W3NCO_LIB4) $(W3EMC_LIB4) $(BACIO_LIB4)'
fi

set -x

#GM SPA add
. ../versions/seaice_drift.ver

if [ ! -d mmablib ] ; then
  git clone https://github.com/rgrumbine/mmablib.git mmablib
fi

cd mmablib
git checkout operations
make
export BASE=`pwd`
cd ..

#The ftn, CC aliases require craype
export FC=ftn
#on ifort, standard compliance is -std90, 95, 03, 08
export FOPTS='-O2 -std95'

#Common to all systems:
export mmablib_ver=${mmablib_ver:-""}

export MMAB_INC='$(BASE)/include'
export INCDIR='$(BASE)/include'
export MMAB_LIBF4=$BASE/$mmablib_ver/libombf_4.a
echo BASE = $BASE
echo mmablib_ver = $mmablib_ver
export LIBS='-L $(BASE)/ $(W3NCO_LIB4) $(W3EMC_LIB4) $(BACIO_LIB4)'

#Items to specify for platforms/compilers/...
export SHELL='/bin/sh'
export CC=CC
export COPTS='-O2 -Wall -DLINUX'

export JORG=NP21
export JPROG=Grumbine

#Building:
for d in seaice_preaverage.Cd seaice_sicedrft.fd seaice_midpoints.Cd seaice_reformat.fd
do
  cd $d 
  make -i
  cd ..
done

if [ ! -d ../exec ] ; then
  mkdir ../exec
fi
mv */seaice_* ../exec 

#!/bin/sh
#set -xe
set -x

. ../versions/build.ver

sys=`hostname`

module list > /dev/null 2> /dev/null
if [ $? -ne 0 ] ; then
  echo On a system without the module software
  export BASE=${BASE:-/Users/rmg3/usrlocal/mmab}
  export FC=gfortran
  export FOPTS='-O2 -std=f2008'
  export LIBS='-L/Volumes/ncep/nceplibs/ -L $(BASE)/$(mmablib_ver)/'
  export MMAB_VER=v3.5.0
else
#on a system with module software, such as wcoss
#phase3   module purge
#phase3   #Phase3
#phase3   module load EnvVars/1.0.2 ips/18.0.1.163
#phase3   module load w3nco/2.0.6 impi/18.0.1 w3emc/2.3.0
#phase3   module load bufr/11.2.0 bacio/2.0.2
#phase3   echo in makeall.sh loaded modules:
#acorn   module list
  #source /apps/prod/lmodules/startLmod
  module reset
  #module avail 2> avail.1
  module load PrgEnv-intel/$PrgEnv_intel_ver
  module load intel/$intel_ver
  module load craype/$craype_ver
  module load w3nco/$w3nco_ver
  module list
  #module avail 2> avail.2
fi

git clone https://github.com/rgrumbine/mmablib.git mmablib
cd mmablib
git checkout acorn
make
cd ..

#theia: export BASE=${BASE:-/home/Robert.Grumbine/save}
#export BASE=${BASE:-/u/Robert.Grumbine/save/mmablib}

export FC=ftn
export FOPTS='-O2 '

#Common to all systems:
export mmablib_ver=${mmablib_ver:-""}
export BASE=$PWD/mmablib
export INCDIR='$(BASE)/include'
echo BASE = $BASE
echo mmablib_ver = $mmablib_ver

export LIBS='-L $(BASE)/ $(W3NCO_LIB4) $(W3EMC_LIB4) $(BACIO_LIB4)'
#Items to specify for platforms/compilers/...
export SHELL='/bin/sh'
export CC=CC
export COPTS='-O2 -Wall -DLINUX'

export JORG=NP21
export JPROG=GRUMBINE

#Building:
for d in seaice_preaverage.Cd seaice_sicedrft.fd seaice_ensblend.Cd seaice_reformat.fd
do
  cd $d 
  make -i
  cd ..
done

if [ ! -d ../exec ] ; then
  mkdir ../exec
fi
mv */seaice_* ../exec 

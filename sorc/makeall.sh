#!/bin/sh
#set -xe

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
#on a system with module software, such as wcoss
  module purge
  #Phase3
  module load EnvVars/1.0.2 ips/18.0.1.163
  module load w3nco/2.0.6 impi/18.0.1 w3emc/2.3.0
  module load bufr/11.2.0 bacio/2.0.2
  echo in makeall.sh loaded modules:
  module list
  export FC=ifort
  export FOPTS='-O2 -std90'
  export LIBS='-L $(BASE)/$(mmablib_ver)/ $(W3NCO_LIB4) $(W3EMC_LIB4) $(BACIO_LIB4)'
fi

#theia/hera: export BASE=${BASE:-/home/Robert.Grumbine/save}
export BASE=${BASE:-/u/Robert.Grumbine/para/mmablib}

#Common to all systems:
export mmablib_ver=${mmablib_ver:-v3.5.0}
export INCDIR='$(BASE)/$(mmablib_ver)/include'
echo BASE = $BASE
echo mmablib_ver = $mmablib_ver

#Items to specify for platforms/compilers/...
export SHELL='/bin/sh'
export CC=g++
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

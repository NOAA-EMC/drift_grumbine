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
  #module load EnvVars/1.0.2 ips/18.0.1.163
  #module load w3nco/2.0.6 impi/18.0.1 w3emc/2.3.0
  #module load bufr/11.2.0 bacio/2.0.2
  #wcoss2
  module load envvar/1.0
  module load PrgEnv-intel/8.2.0
  module load intel/19.1.3.304
  module load w3nco/2.4.1
  module load bufr/11.6.0
  module load bacio/2.4.1
  echo in makeall.sh loaded modules:
  module list
  export FC=ifort
  export FOPTS='-O2 -std90'
  export BASE=${BASE:-$HOME/rgdev/mmablib}
  export LIBS='-L $(BASE)/ $(W3NCO_LIB4) $(W3EMC_LIB4) $(BACIO_LIB4)'
fi

#theia/hera: export BASE=${BASE:-$HOME/save}
export BASE=${BASE:-$HOME/para/mmablib}

#Common to all systems:
export mmablib_ver=${mmablib_ver:-""}
export MMAB_INC='$(BASE)/$(mmablib_ver)/include'
export MMAB_LIBF4=$BASE/$mmablib_ver/libombf_4.a
echo BASE = $BASE
echo mmablib_ver = $mmablib_ver

#Items to specify for platforms/compilers/...
export SHELL='/bin/sh'
export CC=g++
export COPTS='-O2 -Wall -DLINUX'

export JORG=NP21
export JPROG=GRUMBINE

#Building:
for d in seaice_preaverage.Cd seaice_sicedrft.fd seaice_reformat.fd seaice_ensblend.Cd
do
  cd $d 
  make -i
  cd ..
done

if [ ! -d ../exec ] ; then
  mkdir ../exec
fi
mv */seaice_* ../exec 

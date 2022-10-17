#!/bin/sh --login

#set -xe
set -e

# WCOSS2
module reset
module load envvar/1.0
module load intel/19.1.3.304
module load craype//2.7.8
module load cray-mpich/8.1.7
module load prod_envir/2.0.5
module load prod_util/2.0.8
module load wgrib2/2.0.8

# -- to check on a module's usage: module spider $m 
# Show what happened:
module list

set -xe


#export HOMEbase=$HOME/rgdev/drift/
export HOMEbase=$HOME/rgdev/slush.drift/feature/

cd $HOMEbase/sms/
export cyc=${cyc:-00}
export envir=developer
export code_ver=v4.1.4
export job=seaice_drift
export SMSBIN=$HOMEbase

. ../versions/seaice_drift.ver
. ../versions/run.ver


tagm=20221016
tag=20221017
end=`date +"%Y%m%d" `
end=$tag
while [ $tag -le $end ]
do
  export PDY=$tag
  export PDYm1=$tagm

  if [ ! -d $HOME/noscrub/com/mmab/developer/seaice_drift.$tag$cyc ] ; then
    export KEEPDATA="NO"         #Normal runs
    export KEEPDATA="YES"        #debugging
    time $HOMEbase/jobs/JSEAICE_DRIFT  > sms.${tag}${cyc}
  fi

  tagm=$tag
  tag=`expr $tag + 1`
  tag=`$HOME/bin/dtgfix3 $tag`
done

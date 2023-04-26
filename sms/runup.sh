#!/bin/bash 
#PBS -N atest
#PBS -o atest
#PBS -j oe
#PBS -A ICE-DEV
#PBS -q dev
#PBS -l walltime=0:41:00
#PBS -l select=1:ncpus=1
#
set -xe
#set -e

export cyc=${cyc:-00}
export envir=developer
export seaice_drift_ver=v4.1.4
export job=seaice_drift

export HOMEbase=$HOME/rgdev/seaice_drift.$seaice_drift_ver/
export SMSBIN=$HOMEbase
cd $HOMEbase/sms/

# WCOSS2
. ../versions/seaice_drift.ver
. ../versions/run.ver

set +x
module reset
module load envvar/1.0
module load prod_util/${prod_util_ver}
module load intel/${intel_ver}
module load wgrib2/${wgrib2_ver}

# -- to check on a module's usage: module spider $m 
# Show what happened:
module list

set -xe

tagm=20230402
tag=20230401
#end=`date +"%Y%m%d" `
end=$tag

pid=$$

while [ $tag -le $end ]
do
  export jobid=seaice_drift.$pid
  export PDY=$tag
  export PDYm1=$tagm

    #export KEEPDATA="NO"         #Normal runs
    export KEEPDATA="YES"        #debugging

  time $HOMEbase/jobs/JSEAICE_DRIFT.hind  > sms.${tag}${cyc}

  pid=`expr $pid + 1`
  tagm=$tag
  tag=`expr $tag + 1`
  tag=`$HOME/bin/dtgfix3 $tag`
done

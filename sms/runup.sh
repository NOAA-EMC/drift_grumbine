#!/bin/bash 
#PBS -N dr202207
#PBS -o dr202207
#PBS -j oe
#PBS -A ICE-DEV
#PBS -q dev
#PBS -l walltime=5:41:00
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

tag=20221001
tagm=20220930

#end=`date +"%Y%m%d" `
end=20221231

pid=$$

while [ $tag -le $end ]
do
  export jobid=seaice_drift.$pid
  export PDY=$tag
  export PDYm1=$tagm

    export KEEPDATA="NO"         #Normal runs
    #export KEEPDATA="YES"        #debugging

  time $HOMEbase/jobs/JSEAICE_DRIFT.hind  > sms.${tag}${cyc}

  pid=`expr $pid + 1`
  tagm=$tag
  tag=`expr $tag + 1`
  tag=`$HOME/bin/dtgfix3 $tag`
done

#!/bin/sh --login

#PBS -N atest
#PBS -o atest
#PBS -j oe
#PBS -A ICE-DEV
#PBS -q dev
#PBS -l walltime=0:41:00
#PBS -l select=1:ncpus=1
#
#set -xe
set -e

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

module reset
module load envvar/1.0
module load prod_util/${prod_util_ver}
module load intel/${intel_ver}
module load wgrib2/${wgrib2_ver}

#module load craype/2.7.8
#module load cray-mpich/8.1.7
#module load prod_envir/2.0.5

# -- to check on a module's usage: module spider $m 
# Show what happened:
module list

set -x
set +e

tagm=20221112
tag=20221113
end=`date +"%Y%m%d" `
#end=$tag
#end=20221021

while [ $tag -le $end ]
do
  export jobid=seaice_drift.$$
  export PDY=$tag
  export PDYm1=$tagm

    #export KEEPDATA="NO"         #Normal runs
    export KEEPDATA="YES"        #debugging

  time $HOMEbase/jobs/JSEAICE_DRIFT  > sms.${tag}${cyc}


  tagm=$tag
  tag=`expr $tag + 1`
  tag=`$HOME/bin/dtgfix3 $tag`
done

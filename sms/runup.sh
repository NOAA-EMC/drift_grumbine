#!/bin/sh --login

#set -e

module purge
module load craype-x86-rome
module load libfabric/1.11.0.0
module load craype-network-ofi
module load envvar/1.0
module load PrgEnv-intel/8.2.0
module load intel/19.1.3.304
#module load prod_envir/2.0.6
module load prod_util/2.0.13
module load wgrib2/2.0.8
#for sidfex
module load python/3.8.6
# -- to check on a module's usage: module spider $m 
# Show what happened:
module list

export cyc=${cyc:-00}
export envir=developer
export code_ver=v4.0.3
export job=seaice_drift
export SMSBIN=$HOME/rgdev/${job}.${code_ver}/sms/

cd $HOME/rgdev/drift/sms/

set -xe
tagm=20220822
tag=20220823
end=`date +"%Y%m%d" `
end=20220825

while [ $tag -le $end ]
do
  export cyc=00
  export PDY=$tag
  export PDYm1=$tagm

  #if [ ! -d $HOME/noscrub/com/mmab/developer/seaice_drift.${tag}${cyc} ] ; then
    #Now call J job, which will call the ex
    export KEEPDATA="NO"
    time $HOME/rgdev/${job}.${code_ver}/jobs/JSEAICE_DRIFT > sms.${tag}${cyc}
  #fi

  tagm=$tag
  tag=`expr $tag + 1`
  tag=`$HOME/bin/dtgfix3 $tag`
done

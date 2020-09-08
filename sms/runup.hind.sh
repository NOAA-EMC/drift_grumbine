#!/bin/bash --login
#BSUB -J drift1905
#BSUB -q "dev"
#BSUB -P RTO-T2O
#BSUB -W 5:59
#BSUB -o drift.out.%J
#BSUB -e drift.err.%J
#BSUB -R "affinity[core(1)]"
#BSUB -R "rusage[mem=128]"

#set -x
set -e

#. $MODULESHOME/init/bash

module purge
# Phase 3
module load EnvVars/1.0.3 
module load prod_envir/1.1.0
module load ips/18.0.5.274 impi/18.0.1
module load grib_util/1.1.1
module load prod_util/1.1.0
module load util_shared/1.1.2 #a guess
module load w3nco/2.0.6 w3emc/2.3.0
module load bufr/11.3.1 bacio/2.0.2
# -- to check on a module's usage: module spider $m 
#for sidfex
module load python/3.6.3
# Show what happened:
module list

#From the sms.fake:
#export HOMEpmb=/gpfs/tp2/nco/ops/nwprod/util
export cyc=${cyc:-00}
export envir=developer
export code_ver=v4.0.3
export job=seaice_drift
export SMSBIN=/u/Robert.Grumbine/para/${job}.${code_ver}/sms/

cd /u/Robert.Grumbine/para/drift/sms/

#set -xe
set -x
tagm=20190516
tag=20190517
end=`date +"%Y%m%d" `
end=20190531
while [ $tag -le $end ]
do
  export cyc=00
  export PDY=$tag
  export PDYm1=$tagm

  if [ ! -d /u/Robert.Grumbine/noscrub/com/mmab/developer/seaice_drift.${tag}${cyc} ] ; then
    #Now call J job, which will call the ex
    #export KEEPDATA="YES"
    export KEEPDATA="NO"
    time /u/Robert.Grumbine/para/${job}.${code_ver}/jobs/JSEAICE_DRIFT.hind > sms.${tag}${cyc}
  fi

  tagm=$tag
  tag=`expr $tag + 1`
  tag=`/u/Robert.Grumbine/bin/dtgfix3 $tag`
done

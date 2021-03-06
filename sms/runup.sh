#!/bin/sh --login

#set -x
set -e

module purge
# Phase 3
module load prod_envir/1.0.2
module load EnvVars/1.0.2 ips/18.0.1.163
module load grib_util/1.1.0
module load prod_util/1.1.0
module load util_shared/1.1.0 #a guess
module load w3nco/2.0.6 impi/18.0.1 w3emc/2.3.0
module load bufr/11.2.0 bacio/2.0.2
# -- to check on a module's usage: module spider $m 
# Show what happened:
module list

#export HOMEpmb=/gpfs/tp2/nco/ops/nwprod/util
cd /u/Robert.Grumbine/para/drift/sms/

#set -xe
tagm=20190305
tag=20190306
end=`date +"%Y%m%d" `
while [ $tag -le $end ]
do
  export PDY=$tag
  export PDYm1=$tagm

  if [ ! -d /u/Robert.Grumbine/noscrub/com/mmab/developer/seaice_drift.$tag ] ; then
    time ./sms.fake > sms.$tag
  fi

  tagm=$tag
  tag=`expr $tag + 1`
  tag=`/u/Robert.Grumbine/bin/dtgfix3 $tag`
done

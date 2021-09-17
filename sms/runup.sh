#!/bin/sh --login

#set -xe
set -e

# Phase 3
#module purge
#module load prod_envir/1.0.2
#module load EnvVars/1.0.2 ips/18.0.1.163
#module load grib_util/1.1.0
#module load prod_util/1.1.0
#module load util_shared/1.1.0 #a guess
#module load w3nco/2.0.6 impi/18.0.1 w3emc/2.3.0
#module load bufr/11.2.0 bacio/2.0.2
# Acorn
#source /apps/prod/lmodules/startLmod
module purge
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

export HOMEbase=/lfs/h2/emc/couple/noscrub/Robert.Grumbine
cd $HOMEbase/drift/sms/

set -xe
tagm=20210823
tag=20210824
end=`date +"%Y%m%d" `
end=$tag
#while [ $tag -le $end ]
#do
  export PDY=$tag
  export PDYm1=$tagm

  if [ ! -d $HOMEbase/com/mmab/developer/seaice_drift.$tag ] ; then
    time ./sms.fake > sms.$tag
  fi

  tagm=$tag
  tag=`expr $tag + 1`
#  tag=`/u/Robert.Grumbine/bin/dtgfix3 $tag`
#done

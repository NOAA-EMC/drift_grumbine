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
dayback=8 #how many days to go back for late data

set -x
tag=`date +"%Y%m%d" `
tagm=`expr $tag - 1`

# Run the drifter history tables and put in fix/$yy
cd /u/Robert.Grumbine/para/drift/ush/
dawn=$tag
days=0
while [ $days -lt $dayback ]
do
  dawn=`expr $dawn - 1`
  dawn=`/u/Robert.Grumbine/bin/dtgfix3 $dawn`
  days=`expr $days + 1`
done
yy=`echo $dawn | cut -c1-4`
mm=`echo $dawn | cut -c5-6`
dd=`echo $dawn | cut -c7-8`
mm=`expr $mm + 0`  #do this to strip the leading 0 if any
dd=`expr $dd + 0`  
if [ -f SIDFEx_targettable.txt ] ; then
  rm *.txt
fi
python3 hist2.py $yy $mm $dd $cyc

if [ -d ../fix/$yy ] ; then
  mv seaice_edge* ../fix/$yy
else
  mkdir -p ../fix/$yy
  mv seaice_edge* ../fix/$yy
fi


# Now do the run-up from today back 'dayback' days
cd /u/Robert.Grumbine/para/drift/sms/
days=0
while [ $days -lt $dayback ]
do
  export cyc=00
  export PDY=$tag
  export PDYm1=$tagm

  #if [ ! -d /u/Robert.Grumbine/noscrub/com/mmab/developer/seaice_drift.${tag}${cyc} ] ; then
    #Now call J job, which will call the ex
    #export KEEPDATA="YES"
    export KEEPDATA="NO"
    time /u/Robert.Grumbine/para/${job}.${code_ver}/jobs/JSEAICE_DRIFT.hind > sms.${tag}${cyc}
  #fi

  days=`expr $days + 1`
  tag=$tagm
  tagm=`expr $tagm - 1`
  tagm=`/u/Robert.Grumbine/bin/dtgfix3 $tagm`
done

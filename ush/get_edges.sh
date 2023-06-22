#!/bin/bash --login
#BSUB -J sidfex
#BSUB -q "dev"
#BSUB -P RTO-T2O
#BSUB -W 0:59:00
#BSUB -o drift.out.%J
#BSUB -e drift.err.%J
#BSUB -R "affinity[core(1)]"
#BSUB -R "rusage[mem=128]"

#set -x
set -e

module purge
module load craype-x86-rome
module load libfabric/1.11.0.0
module load craype-network-ofi
module load envvar/1.0
module load PrgEnv-intel/8.2.0
module load intel/19.1.3.304
module load prod_envir/2.0.6
module load prod_util/2.0.13
module load wgrib2/2.0.8
module load python/3.8.6
# Show what happened:
module list

#From the sms.fake:
export cyc=${cyc:-00}
export envir=developer
export code_ver=v4.0.3
export job=seaice_drift
export SMSBIN=$HOME/rgdev/${job}.${code_ver}/sms/

cd $HOME/rgdev/drift/sms/
dayback=15         #how many days to go back for late data

set -x
tag=`date +"%Y%m%d" `
tag=20220401
#for tag in 20220316 20220301 20220216 20220201 20220116 20220101 20211216 20211201
for tag in 20170116
do

tagm=`expr $tag - 1`
tagm=`$HOME/bin/dtgfix3 $tagm`

# Run the drifter history tables and put in fix/$yy
cd $HOME/rgdev/drift/ush/
dawn=$tag
days=0
while [ $days -lt $dayback ]
do
  dawn=`expr $dawn - 1`
  dawn=`$HOME/bin/dtgfix3 $dawn`
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
python3 $HOME/rgdev/drift/ush/hist2.py $yy $mm $dd $cyc

if [ ! -d ../fix/$yy ] ; then
  mkdir -p ../fix/$yy
fi
mv seaice_edge* ../fix/$yy

done

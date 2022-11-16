#!/bin/sh

# Upload contributions to SIDFEx repository

cd $COMOUT_sidfex

if [ ! -f uploaded ] ; then
  find . -type f -exec $USHsice/upload.sh {} \;
else
  find . -type f -newer uploaded -name 'nc*' -exec $USHsice/upload.sh {} \;
fi
touch uploaded

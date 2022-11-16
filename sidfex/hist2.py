#!/usr/bin/python

#Python3 -- important to add urllib.request, decode
import os
import sys
import re
import urllib
import urllib.request
import datetime
from datetime import date
from datetime import timedelta

#---------------------------------------------------------
if (os.path.exists('SIDFEx_targettable.txt')):
   fin = open('SIDFEx_targettable.txt','r')
else :
   outfile = open('SIDFEx_targettable.txt','w')
   web = urllib.request.urlopen('https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/SIDFEx_targettable.txt')
   data = web.read()
   outfile.write(data.decode('utf-8'))
   outfile.close()
   web.close()
   fin = open('SIDFEx_targettable.txt','r')
#---------------------------------------------------------

#Work from/for history
cycle = int(sys.argv[4])
dawn = datetime.datetime(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), cycle)
print("dawn of time = ",dawn)

freq = timedelta(seconds=3600*6)    # cycle frequency

#---------------------------------------------------------
# Read through table, if dawn is in window

#20 = length of header
i = 0
x = 'blank'
while not (x == ''):
  x = fin.readline()
  if (i >= 20 and x != '' ):
    words = x.split()
    TargetID = words[0]
    # NaN is a fixed location
    if (words[2] == 'NaN' or TargetID == 'POLARSTERN01' or TargetID == 'POLARSTERN02'  ): 
       outfile = open(TargetID+'.txt','w')
       web = urllib.request.urlopen('https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/observations/'+TargetID+'.txt')
       data = web.read()
       outfile.write(data.decode('utf-8'))
       outfile.close()
       web.close()
       fintarget = open(TargetID+'.txt','r')

       y = fintarget.readline() #header
      #go through observations and print out all that are more recent than the dawn of time
       while not (y == ''):
          y = fintarget.readline()
          if (y == ''):
             fintarget.close()
             break
          words = y.split()
          obs_year   = float(words[0])
          obs_day    = float(words[1])
          obs_date  = datetime.datetime(int(obs_year),1,1)
          obs_date += timedelta(seconds=(obs_day-1)*86400)
          obs_lat = float(words[2])
          obs_lon = float(words[3])
##normal scan
          if ((obs_date >= dawn) ):
            fout = open('seaice_edge.t00z.txt.'+obs_date.strftime("%Y%m%d%H"),'a')
            print(obs_lat, obs_lon, TargetID, obs_year, obs_day, file=fout)
            fout.close()


    else: #regular drifting buoy:
      latest_year = float(words[2])
      latest_day  = float(words[3])
      latest_lat  = float(words[4])
      latest_lon  = float(words[5])
      first_year = float(words[8]) # first date of sidfex usage
      first_day  = float(words[9])
  
      latest_date = datetime.datetime(int(latest_year), 1,1)
      latest_date += timedelta(seconds=(latest_day-1)*86400)
      first_date = datetime.datetime(int(first_year),1,1)
      first_date += timedelta(seconds=(first_day-1)*86400)
      #print("first = ",first_date)

      if (dawn >= first_date and dawn <= latest_date):
        #Get the platform, as needed ==============================
         outfile = open(TargetID+'.txt','w')
         web = urllib.request.urlopen('https://swift.dkrz.de/v1/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_index/observations/'+TargetID+'.txt')
         data = web.read()
         outfile.write(data.decode('utf-8'))
         outfile.close()
         web.close()
         fintarget = open(TargetID+'.txt','r')

         #now read forward in time through file
         y = fintarget.readline() #header

         #go through observations and print out all that are more recent than the dawn of time
         while not (y == ''):
           y = fintarget.readline()
           if (y == ''):
              fintarget.close()
              break
           words = y.split()
           tmp_target = words[0]
           obs_year   = float(words[1])
           obs_day    = float(words[5])
           obs_date  = datetime.datetime(int(obs_year),1,1)
           obs_date += timedelta(seconds=(obs_day-1)*86400)
           #print("obs date = ",obs_date)
  
   #More normal scan
           if ((obs_date >= dawn) ): 
             obs_lat    = float(words[6])
             obs_lon    = float(words[7])
             fout = open('seaice_edge.t00z.txt.'+obs_date.strftime("%Y%m%d%H"),'a')
             print(obs_lat, obs_lon, TargetID, obs_year, obs_day, file=fout)
             fout.close()

  i += 1

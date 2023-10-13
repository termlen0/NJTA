#!/usr/bin/ksh

# Displays permenant error since yesterday 

ydy=`TZ=GMT+24 date +%m%d`
ydyy=`TZ=GMT+24 date +%y`
yesterday="${ydy}0000${ydyy}"
#echo $yesterday

ERRs=yy`errpt -s $yesterday -T PERM`
if [ $ERRs != "yy" ] ; then
  echo $ERRs
fi

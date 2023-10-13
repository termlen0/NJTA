#!/usr/bin/ksh

# Display the filessystems whose usage is higher than the threshold (as a parameter)

#Threshold=50
if [ $# -ne 1 ] ; then
  echo Usage $0 threshold
  exit 1
fi
Threshold=$1
if [[ $Threshold == +([0-9]) ]]; then
  df -F %m %z -T local |sed 's/%//' |tail +2 |awk '$4 > th {printf "%s\t%d\%\n",  $3, $4}' th=$Threshold
else
  echo The threshold is not a number
fi

#!/usr/bin/ksh

# If computational memory usage is larger than the threshold (as a parameter) it will display the percentage

if [ $# -ne 1 ] ; then
  echo Usage $0 threshold
  exit 1
fi
Threshold=$1
if [[ $Threshold == +([0-9]) ]]; then
  vmstat -v |grep -e "memory pages" -e "percentage of memory used for computational pages" | while read -r y1 y2
  do
    read -r y3 y4
    echo $y1 $y3
  done |read mem comp

  if [[ $comp -gt $Threshold ]] ; then
    echo Computational memory usage is %$comp
  fi
else
  echo The threshold is not a number
  exit 2
fi

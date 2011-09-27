#!/bin/sh
# calculates the total bandwith per traffic type and it total
# this script is performance-revised so it could process large files (4G) and calculate big numbers

totalSumBytes=0
webSumBytes=0
videoSumBytes=0
filesSumBytes=0
cbrSumBytes=0

inputFile=$1
echo $inputFile
webSumBytes=`more $inputFile | awk '{if ((($3==0 && $4==1) || ($3==1 && $4==0))  && ($8==1 || $8==2)) printf("%d+",$6)}'`
tempWebSumBytes=`echo $webSumBytes 0`
webSumBytes=`echo $tempWebSumBytes | bc`
videoSumBytes=`more $inputFile | awk '{if ((($3==0 && $4==1) || ($3==1 && $4==0)) && ($8==3 || $8==4)) printf("%d+",$6)}'`
tempVideoSumBytes=`echo $videoSumBytes 0`
videoSumBytes=`echo $tempVideoSumBytes | bc`
filesSumBytes=`more $inputFile | awk '{if ((($3==0 && $4==1) || ($3==1 && $4==0)) && ($8==5 || $8==6)) printf("%d+",$6)}'`
tempFilesSumBytes=`echo $filesSumBytes 0`
filesSumBytes=`echo $tempFilesSumBytes | bc`
cbrSumBytes=`more $inputFile | awk '{if ((($3==0 && $4==1) || ($3==1 && $4==0)) && $8==7) printf("%d+",$6)}'`
tempCbrSumBytes=`echo $cbrSumBytes 0`
cbrSumBytes=`echo $tempCbrSumBytes | bc`
totalSumBytes=`echo $webSumBytes + $videoSumBytes + $filesSumBytes + $cbrSumBytes | bc`

echo Total number of bytes sent between eNB and SGW: $totalSumBytes
echo Total web between eNB and SGW: $webSumBytes
echo Total video between eNB and SGW: $videoSumBytes 
echo Total files between eNB and SGW: $filesSumBytes
echo Total voip between eNB and SGW:  $cbrSumBytes

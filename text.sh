#!/bin/sh


totalSumBytes=0
webSumBytes=0
videoSumBytes=0
filesSumBytes=0
cbrSumBytes=0

inputFile=$1
echo $inputFile
webSumBytes=`more $inputFile | awk '{if ($3==0 && $4==1 && ($8==1 || $8==2)) print($6)}' | xargs | tr ' ' + | bc`
videoSumBytes=`more $inputFile | awk '{if ($3==0 && $4==1 && ($8==3 || $8==4)) print($6)}' | xargs | tr ' ' + | bc`
filesSumBytes=`more $inputFile | awk '{if ($3==0 && $4==1 && ($8==5 || $8==6)) print($6)}' | xargs | tr ' ' + | bc`
cbrSumBytes=`more $inputFile | awk '{if ($3==0 && $4==1 && $8==7) print($6)}' | xargs | tr ' ' + | bc`
totalSumBytes=`echo $webSumBytes + $videoSumBytes + $filesSumBytes + $cbrSumBytes | bc`

echo Total number of bytes sent between eNB and SGW: $totalSumBytes
echo Total web between eNB and SGW: $webSumBytes
echo Total video between eNB and SGW: $videoSumBytes
echo Total files between eNB and SGW: $filesSumBytes
echo Total voip between eNB and SGW:  $cbrSumBytes

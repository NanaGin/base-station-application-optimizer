#!/bin/sh


inputFile=$1
#numberOfBaseStations=$2
cd $inputFile
uniqueIps=`ls -l | wc -l`
echo $uniqueIps
#ipPerBs=`expr $uniqueIps / $numberOfBaseStations`
#echo $ipPerBs



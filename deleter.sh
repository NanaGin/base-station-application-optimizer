#!/bin/sh

inputFile=$1
for F in `ls $inputFile` 
do
echo $F
cut -d " " -f 1,2,3,5,7,10 $F > $F
done

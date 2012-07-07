#!/bin/sh
#time duration client_ip result_code bytes request_method url rfc931 hierarcy_code content_type

current=`pwd`
echo $current
inputFile=$1
location=$2
cd $inputFile
for F in `ls $inputFile` 
do
echo $F
cut -d " " -f 1,2,3,5,7 $F >> $location.txt
#cd $current
#awk -f $current/ipSplitter.awk $inputFile/$F
done

#!/bin/sh


totalSumBytes=0
webSumBytes=0
videoSumBytes=0
filesSumBytes=0
cbrSumBytes=0

 more out.tr | awk '{if ($3==0 && $4==1 && $8==7) print($6)}' | xargs | tr ' ' + | bc

while read line ;do
	from=`echo $line | awk '{print $3}'`
	to=`echo $line | awk '{print $4}'`
	pktsize=`echo $line | awk '{print $6}'`	
	flow_id=`echo $line | awk '{print $8}'`

	if [ "$from" -eq 0 ] && [ "$to" -eq 1 ]; then

		if [ "$flow_id" -eq 1 ] || [ "$flow_id" -eq 2 ]; then		
			webSumBytes=`echo $webSumBytes + $pktsize | bc`
		elif [ "$flow_id" -eq 3 ] || [ "$flow_id" -eq 4 ]; then		
			videoSumBytes=`echo $videoSumBytes + $pktsize | bc`
		elif [ "$flow_id" -eq 5 ] || [ "$flow_id" -eq 6 ]; then		
			filesSumBytes=`echo $filesSumBytes + $pktsize | bc`
		elif [ "$flow_id" -eq 7 ]; then
			cbrSumBytes=`echo $cbrSumBytes + $pktsize | bc`
		fi 

	    totalSumBytes=`echo $totalSumBytes + $pktsize | bc`
	fi	
done < $1


echo Total number of bytes sent between eNB and SGW: $totalSumBytes
echo Total web between eNB and SGW: $webSumBytes
echo Total video between eNB and SGW: $videoSumBytes
echo Total files between eNB and SGW: $filesSumBytes
echo Total voip between eNB and SGW:  $cbrSumBytes

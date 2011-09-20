#This program is used to calculate the sum of bytes transfered between eNB to GW
# eNB node id is 0
# SGW node id is 1
# GGW node id is 2
# server node id is 3
 

# Flow IDs
# 1 web cache
# 2 web no cache
# 3 video cache
# 4 video no cache  
# 5 files cache
# 6 files no cache
# 7 cbr

#!/usr/bin/perl

BEGIN {

        totalSumBytes = 0;
	webSumBytes = 0;
	videoSumBytes = 0;
	filesSumBytes = 0;
	cbrSumBytes = 0;

}
{

   action = $1;

   time = $2;

   from = $3;

   to = $4;

   type = $5;

   pktsize = $6;

   flow_id = $8;

   src = $9;

   dst = $10;

   seq_no = $11;

   packet_id = $12;



        if (from==0 && to==1 ) {
		if (flow_id == 1 || flow_id == 2) {
			webSumBytes = webSumBytes + pktsize;
		}
		if (flow_id == 3 || flow_id == 4) {
			videoSumBytes = videoSumBytes + pktsize;
		}
		if (flow_id == 5 || flow_id == 6) {
			filesSumBytes = filesSumBytes + pktsize;
		}
		if (flow_id == 7) {
			cbrSumBytes = cbrSumBytes + pktsize;
		}
		totalSumBytes = totalSumBytes + pktsize;
#		eval $totalSumBytes

		#totalSumBytes = `echo $totalSumBytes + $pktsize | bc`;
	}
}

END {

        printf("Total number of bytes sent between eNB and SGW:%d\n", totalSumBytes);
	printf("Total web between eNB and SGW:%d\n", webSumBytes);
	printf("Total video between eNB and SGW:%d\n", videoSumBytes);
	printf("Total files between eNB and SGW:%d\n", filesSumBytes);
	printf("Total voip between eNB and SGW:%d\n", cbrSumBytes);

}

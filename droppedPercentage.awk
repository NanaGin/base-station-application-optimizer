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


BEGIN {

        totalPacketsServer = 0;
	totalPacketsCache = 0;
	droppedPacketsServer = 0;
	droppedPacketsCache = 0;s
}
{
   action = $1
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
	
  	# in case there is no cache - the packets are sent from server to end user
        if (from==3) {
		if (action == "r") {
			totalPacketsServer = totalPacketsServer + 1;
		}
		if (action == "d") {
			droppedPacketsServer = droppedPacketsServer + 1;
		}
	}
	# in case there is cache the packets are sent from eNB to end users 
	if (from==0 && to!=1 && to!=2 && to!=0) {
		if (action == "r") {
			totalPacketsCache = totalPacketsCache + 1;
		}
		if (action == "d") {
			droppedPacketsCache = droppedPacketsCache + 1;
		}
	}
}
END {

        printf("Total packets send from server to end users:%d\n", totalPacketsServer);
	printf("Total packets sent from eNB to end users:%d\n", totalPacketsCache);
	printf("Total packets dropped send from server:%d\n", droppedPacketsServer);
	printf("Total packets dropped send from eNB:%d\n", droppedPacketsCache);
	
}

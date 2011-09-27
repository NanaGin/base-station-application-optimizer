#This program is used to calculate the end-to-end delay for CBR

#awk  –f  endToEndDelay_NoCache.awk  out.tr nodes=numOfNodes

BEGIN {

	nodes = ARGV[2];	
	web_max_packet_id = 0;
	video_max_packet_id = 0;
	files_max_packet_id = 0;
	cbr_max_packet_id = 0;
	web_total_packets_received = 0;
	web_total_packets_sent = 0;
	web_total_packets_dropped = 0;
	video_total_packets_received = 0;
	video_total_packets_sent = 0;
	video_total_packets_dropped = 0;
	files_total_packets_received = 0;
	files_total_packets_sent = 0;
	files_total_packets_dropped = 0;
	cbr_total_packets_received = 0;
	cbr_total_packets_sent = 0;
	cbr_total_packets_dropped = 0;

	#output filenames
	webFilename=nodes "_web.txt";
	videoFilename=nodes "_video.txt";
	filesFilename=nodes "_files.txt";
	cbrFilename=nodes "_cbr.txt";
	totalFilename=nodes "_total.txt";
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

 
	
	# dropped packets
	if (action == "d" && ((from==3 && to==2) || (from==2 && to==1) || (from==1 && to==0) || (from==0 && to!=1))) {
		if (flow_id == 2) {
			web_total_packets_dropped = web_total_packets_dropped + 1;
			web_end_time[packet_id] = -1;
			if (packet_id > web_max_packet_id)
				web_max_packet_id = packet_id;
		}
		if (flow_id == 4) {
			video_total_packets_dropped = video_total_packets_dropped + 1;
			video_end_time[packet_id] = -1;
			if (packet_id > video_max_packet_id)
				video_max_packet_id = packet_id;
		}
		if (flow_id == 6) {
			files_total_packets_dropped = files_total_packets_dropped + 1;
			files_end_time[packet_id] = -1;
			if (packet_id > files_max_packet_id)
				files_max_packet_id = packet_id;
		}
		if (flow_id == 7) {
			cbr_total_packets_dropped = cbr_total_packets_dropped + 1;
			cbr_end_time[packet_id] = -1;
			if (packet_id > cbr_max_packet_id)
				cbr_max_packet_id = packet_id;
		}
	} 	
	
	# for packets that left the server we save the sending time per traffic type	
	if (action == "+" && from == 3) {
		if (flow_id == 2) {
			web_start_time[packet_id] = time;
#			printf("Inserting start time %f for packet id %d\n",time,packet_id) >> "../delay/" webFilename
			web_total_packets_sent = web_total_packets_sent + 1;
			if (packet_id > web_max_packet_id)
				web_max_packet_id = packet_id;
		}
		if (flow_id == 4) {
			video_start_time[packet_id] = time;
			video_total_packets_sent = video_total_packets_sent + 1;
			if (packet_id > video_max_packet_id)
				video_max_packet_id = packet_id;
		}
		if (flow_id == 6) {
			files_start_time[packet_id] = time;
			files_total_packets_sent = files_total_packets_sent + 1;
			if (packet_id > files_max_packet_id)
				files_max_packet_id = packet_id;
		}
		if (flow_id == 7) {
			cbr_start_time[packet_id] = time;
			cbr_total_packets_sent = cbr_total_packets_sent + 1;
			if (packet_id > cbr_max_packet_id)
				cbr_max_packet_id = packet_id;
		}
	}	

	# for packets received at end users we save the delivered time per traffic type
	if (action == "r" && from == 0 && to!=1) {
 		if (flow_id == 2) {
			web_end_time[packet_id] = time;
#			printf("Inserting end time %f for packet id %d\n",web_end_time[packet_id],packet_id) >> "../delay/" webFilename
			web_total_packets_received = web_total_packets_received + 1;
			if (packet_id > web_max_packet_id)
				web_max_packet_id = packet_id;
		}
		if (flow_id == 4) {
			video_end_time[packet_id] = time;
			video_total_packets_received = video_total_packets_received + 1;
			if (packet_id > video_max_packet_id)
				video_max_packet_id = packet_id;
		}
		if (flow_id == 6) {
			files_end_time[packet_id] = time;
			files_total_packets_received = files_total_packets_received + 1;
			if (packet_id > files_max_packet_id)
				files_max_packet_id = packet_id;
		}
		if (flow_id == 7) {
			cbr_end_time[packet_id] = time;
			cbr_total_packets_received = cbr_total_packets_received + 1;
			if (packet_id > cbr_max_packet_id)
				cbr_max_packet_id = packet_id;
		}

	}
 
}                                                       

END {
	#printf("Web Packets Sent: %d\n", web_total_packets_sent) >> "../delay/" totalFilename
	#printf("Web Packets Received: %d\n", web_total_packets_received) >> "../delay/" totalFilename
	#printf("Web Packets Dropped: %d\n", web_total_packets_dropped) >> "../delay/" totalFilename

#	printf("Video Packets Sent: %d\n", video_total_packets_sent) >> "../delay/" totalFilename
#	printf("Video Packets Received: %d\n", video_total_packets_received) >> "../delay/" totalFilename
#	printf("Video Packets Dropped: %d\n", video_total_packets_dropped) >> "../delay/" totalFilename

#	printf("Files Packets Sent: %d\n", files_total_packets_sent) >> "../delay/" totalFilename
#	printf("Files Packets Received: %d\n", files_total_packets_received) >> "../delay/" totalFilename
#	printf("Files Packets Dropped: %d\n", files_total_packets_dropped) >> "../delay/" totalFilename

#	printf("VOIP Packets Sent: %d\n", cbr_total_packets_sent) >> "../delay/" totalFilename
#	printf("VOIP Packets Received: %d\n", cbr_total_packets_received) >> "../delay/" totalFilename
#	printf("VOIP Packets Dropped: %d\n", cbr_total_packets_dropped) >> "../delay/" totalFilename
	
	# print web statistics    
	printf("Number of web packets %d\n",web_max_packet_id) >> "../delay/" webFilename
	i=0;	
	for ( var in web_start_time ) {
		printf("Current index %d,var %s, time %s\n",i,var,web_start_time[var]) >> "../delay/" webFilename
		i=i+1;
		#start = web_start_time[packet_id];
		#printf("Start time %f\n",start) >> "../delay/" webFilename
 		#end = web_end_time[packet_id];
		#printf("End time %s\n",end) >> "../delay/" webFilename
		#if (start != 0 end != -1 && end > start) {
		#	packet_duration = end - start;		
		#	printf("%s %s\n",start,packet_duration) >> "../delay/" webFilename
		#} 
	}

}

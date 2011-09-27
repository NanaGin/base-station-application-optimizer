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
	webFilename=nodes "_cache_web.txt";
	videoFilename=nodes "_cache_video.txt";
	filesFilename=nodes "_cache_files.txt";
	cbrFilename=nodes "_cache_cbr.txt";
	totalFilename=nodes "_cache_total.txt";
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
	if ((action == "d") && ((from==3 && to==2) || (from==2 && to==1) || (from==1 && to==0) || (from==0 && to!=1))) {
		if (flow_id == 2 || flow_id == 1) {
			web_total_packets_dropped = web_total_packets_dropped + 1;
			web_end_time[packet_id] = -1;
			if (packet_id > web_max_packet_id)
				web_max_packet_id = packet_id;
		}
		if (flow_id == 4 || flow_id == 3) {
			video_total_packets_dropped = video_total_packets_dropped + 1;
			video_end_time[packet_id] = -1;
			if (packet_id > video_max_packet_id)
				video_max_packet_id = packet_id;
		}
		if (flow_id == 6 || flow_id == 5) {
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
	# since here we are using cache we need to count all packets sent from server and all packet sent from enb to end users
	if ((action == "+") && ((from == 3) || ((from == 0) && (to != 1)))) {
		if (flow_id == 2 || flow_id == 1) {
			# we want to update start time only when the packet leaves the sender, not in the middle of the way - in cache scenario we have 2 possible 				# senders - server or eNB
			if (web_start_time[packet_id] == 0) {			
				web_start_time[packet_id] = time;
				web_total_packets_sent = web_total_packets_sent + 1;
				if (packet_id > web_max_packet_id)
					web_max_packet_id = packet_id;
			}
		}
		if (flow_id == 4 || flow_id == 3) {
			if (video_start_time[packet_id] == 0) {			
				video_start_time[packet_id] = time;
				video_total_packets_sent = video_total_packets_sent + 1;
				if (packet_id > video_max_packet_id)
					video_max_packet_id = packet_id;
			}
		}
		if (flow_id == 6 || flow_id == 5) {
			if (files_start_time[packet_id] == 0) {			
				files_start_time[packet_id] = time;
				files_total_packets_sent = files_total_packets_sent + 1;
				if (packet_id > files_max_packet_id)
					files_max_packet_id = packet_id;
			}
		}
		if (flow_id == 7) {
			if (cbr_start_time[packet_id] == 0) {			
				cbr_start_time[packet_id] = time;
				cbr_total_packets_sent = cbr_total_packets_sent + 1;
				if (packet_id > cbr_max_packet_id)
					cbr_max_packet_id = packet_id;
			}
		}
	}	

	# for packets received at end users we save the delivered time per traffic type
	if (action == "r" && from == 0 && to!=1) {
 		if (flow_id == 2 || flow_id == 1) {
			web_end_time[packet_id] = time;
			web_total_packets_received = web_total_packets_received + 1;
			if (packet_id > web_max_packet_id)
				web_max_packet_id = packet_id;
		}
		if (flow_id == 4 || flow_id == 3) {
			video_end_time[packet_id] = time;
			video_total_packets_received = video_total_packets_received + 1;
			if (packet_id > video_max_packet_id)
				video_max_packet_id = packet_id;
		}
		if (flow_id == 6 || flow_id == 5) {
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
	printf("Web Packets Sent: %d\n", web_total_packets_sent) >> "../delay/" totalFilename
	printf("Web Packets Received: %d\n", web_total_packets_received) >> "../delay/" totalFilename
	printf("Web Packets Dropped: %d\n", web_total_packets_dropped) >> "../delay/" totalFilename

	printf("Video Packets Sent: %d\n", video_total_packets_sent) >> "../delay/" totalFilename
	printf("Video Packets Received: %d\n", video_total_packets_received) >> "../delay/" totalFilename
	printf("Video Packets Dropped: %d\n", video_total_packets_dropped) >> "../delay/" totalFilename

	printf("Files Packets Sent: %d\n", files_total_packets_sent) >> "../delay/" totalFilename
	printf("Files Packets Received: %d\n", files_total_packets_received) >> "../delay/" totalFilename
	printf("Files Packets Dropped: %d\n", files_total_packets_dropped) >> "../delay/" totalFilename

	printf("VOIP Packets Sent: %d\n", cbr_total_packets_sent) >> "../delay/" totalFilename
	printf("VOIP Packets Received: %d\n", cbr_total_packets_received) >> "../delay/" totalFilename
	printf("VOIP Packets Dropped: %d\n", cbr_total_packets_dropped) >> "../delay/" totalFilename

		# print web statistics
	numPackets=0;
	avg=0;    
	for ( var in web_start_time ) {		
		start = web_start_time[var];
 		end = web_end_time[var];
		if (start != 0 && end > start) {
			packet_duration = end - start;
			numPackets=numPackets + 1;
			avg=avg + packet_duration;
			printf("%s %s\n",start,packet_duration) >> "../delay/" webFilename
		} 
	}
	printf("Web with cache average delay: %s",avg / numPackets) >> "../delay/" webFilename

	# print video statistics
	numPackets=0;
	avg=0;    
	for ( var in video_start_time ) {		
		start = video_start_time[var];
 		end = video_end_time[var];
		if (start != 0 && end > start) {
			packet_duration = end - start;
			numPackets=numPackets + 1;
			avg=avg + packet_duration;
			printf("%s %s\n",start,packet_duration) >> "../delay/" videoFilename
		} 
	}
	printf("Video with cache average delay: %s",avg / numPackets) >> "../delay/" videoFilename

	# print files statistics
	numPackets=0;
	avg=0;    
	for ( var in files_start_time ) {		
		start = files_start_time[var];
 		end = files_end_time[var];
		if (start != 0 && end > start) {
			packet_duration = end - start;
			numPackets=numPackets + 1;
			avg=avg + packet_duration;
			printf("%s %s\n",start,packet_duration) >> "../delay/" filesFilename
		} 
	}
	printf("Files with cache average delay: %s",avg / numPackets) >> "../delay/" filesFilename

	# print voip statistics
	numPackets=0;
	avg=0;    
	for ( var in cbr_start_time ) {		
		start = cbr_start_time[var];
 		end = cbr_end_time[var];
		if (start != 0 && end > start) {
			packet_duration = end - start;
			numPackets=numPackets + 1;
			avg=avg + packet_duration;
			printf("%s %s\n",start,packet_duration) >> "../delay/" cbrFilename
		} 
	}
	printf("VOIP with cache average delay: %s",avg / numPackets) >> "../delay/" cbrFilename


}

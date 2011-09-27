#This program is used to calculate total bandwith per traffic per second

#awk  –f  bandwithPerSecond.awk  out.tr nodes=NumberOfNodes

BEGIN {
	
	nodes = ARGV[2];
	# create filenames according to input parameters
	webFilename=nodes "_cache_webTraffic.txt";
	videoFilename=nodes "_cache_video.txt";
	filesFilename=nodes "_cache_files.txt";
	cbrFilename=nodes "_cache_cbr.txt";
	totalFilename=nodes "_cache_total.txt";

	for (i=0; i<=1800; i++) {
		web[i]=0;
		video[i]=0;
		files[i]=0;
		cbr[i]=0;
		total[i]=0;
	}
}
{

	time = $2;

	from = $3;

	to = $4;

	pktsize = $6;

	flow_id = $8;



        if ((from==0 && to==1) || (from==1 && to==0)) {
		secIndex=sprintf("%d",time);
		if (flow_id == 1 || flow_id == 2) {			
			web[secIndex] = web[secIndex] + pktsize;
		}
		if (flow_id == 3 || flow_id == 4) {
			video[secIndex] = video[secIndex] + pktsize;
		}
		if (flow_id == 5 || flow_id == 6) {
			files[secIndex] = files[secIndex] + pktsize;
		}
		if (flow_id == 7) {
			cbr[secIndex] = cbr[secIndex] + pktsize;
		}
		total[secIndex] = total[secIndex] + pktsize;
	}
}	
END {
 	for (i=0; i<=1800; i++) {
		printf("%d\n", web[i]) >> "/media/LENOVO/nana/bytesPerSecond/" webFilename
		printf("%d\n", video[i]) >> "/media/LENOVO/nana/bytesPerSecond/" videoFilename
		printf("%d\n", files[i]) >> "/media/LENOVO/nana/bytesPerSecond/" filesFilename
		printf("%d\n", cbr[i]) >> "/media/LENOVO/nana/bytesPerSecond/" cbrFilename
		printf("%d\n", total[i]) >> "/media/LENOVO/nana/bytesPerSecond/" totalFilename
	}
}

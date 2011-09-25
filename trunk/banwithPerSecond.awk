#This program is used to calculate total bandwith per traffic per second

#awk  –f  bandwithPerSecond.awk  out.tr

BEGIN {
	
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



        if (from==0 && to==1 ) {
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
		printf("%d,%d\n", i,web[i]);
	}
	printf("*********************");
 #       printf("web array:%d\n", video[3]);
  #      printf("web array:%d\n", files[3]);
   #     printf("web array:%d\n", cbr[3]);
}

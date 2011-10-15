# imports
source configurationLowHitRate.tcl
source createTopology.tcl
source createTraffic.tcl
source utilities.tcl

# in case commande line parameters were provided, override default values from configuration.tcl file
foreach { key value } $argv {
	switch -- $key {
		-traceFile { set cfg_(TRACE_FILENAME) $value } 	
		-nn   { set cfg_(NUM_OF_CLIENTS) $value }
		-bw  { set cfg_(DROP_TAIL_BW) $value }
		-dl  { set cfg_(DROP_TAIL_DELAY) $value }
		-qs   { set cfg_(QUEUE_SIZE) $value }
		-cache { set cfg_(CACHE) $value }
		-webUsers { set cfg_(WEB) $value }
		-videoUsers { set cfg_(VIDEO) $value } 
		-filesUsers { set cfg_(FILES) $value } 
		-voipUsers { set cfg_(VOIP) $value }  
		-webHitRate { set cfg_(WEB_HIT_RATE) $value }
		-videoHitRate { set cfg_(VIDEO_HIT_RATE) $value }
		-filesHitRate { set cfg_(FILES_HIT_RATE) $value }
	}
}


# define Simulator
global ns
set ns [new Simulator]


#Open the trace file
set f [open $cfg_(TRACE_FILENAME) w]
$ns trace-all $f
#add-packet-header IP TCP;
#Trace set show_tcphdr_ 1;

#Open the nam trace file 
set nf [open out.nam w]
$ns namtrace-all $nf

puts "Trace files opened..."

# calculate queue size between UE to eNB
calculateUserENBLinkQueueSize

puts $cfg_(QUEUE_SIZE)

# create Topology - createTopology uses the file produced by initialTopology
createTopology

# define colors for better presentation. the numbers represent botht the color in graphical simulation and the flow id in traces
defineColors


# define number of users per traffic channel according to Alot distribution
calculateUsersDistribution

# calculate the distribution of users that will receive cache hit - meaning their traffic will be only until eNB. will be used only in cache scenario
calculateHitRateUsersDistribution 


puts "-------------------------------------"
puts "Users Distribution:"
puts "Web cache: $WEB_CACHE_USERS"
puts "Web total: $WEB_USERS"
puts "Video cache: $VIDEO_CACHE_USERS"
puts "Video total: $VIDEO_USERS"
puts "Files cache: $FILES_CACHE_USERS"
puts "Files total: $FILES_USERS"
puts "VOIP total: $VOIP_USERS"
puts "-------------------------------------"

# define the traffic according to: traffic distribution, cache hit rate
# we go over all cfg_(NUM_OF_CLIENTS) users
# since end users are saved in an array, we need to find the correct index of start / end of each traffic group
# each group index starts from the last group index and ends at group size index

# define web users
set startIndex 0
set first 0
set last [expr {$first+$WEB_USERS}]
# counter for cache group size
set usersHitRateCount 0 
for { set i $first} { $i<$last } {incr i} {
	# cache scenario
	if {$cfg_(CACHE) == true && $usersHitRateCount < $WEB_CACHE_USERS} {
		# create traffic until eNB to simulate cache
		#puts "web with cache: $i"
		set paretoWebDownload($i) [createParetoFlow $ns $UE($i) $eNB $cfg_(WEB_BURST_TIME) $cfg_(WEB_PACKET_SIZE) $cfg_(WEB_IDLE_TIME) $cfg_(WEB_RATE) $cfg_(WEB_SHAPE) 1 $i]
		set paretoWebUpload($i) [createParetoFlow $ns $eNB $UE($i) $cfg_(WEB_BURST_TIME) $cfg_(WEB_PACKET_SIZE) $cfg_(WEB_IDLE_TIME) $cfg_(WEB_RATE) $cfg_(WEB_SHAPE) 1 $i]  		
	} else {
		#puts "web without cache: $i"
		set paretoWebDownload($i) [createParetoFlow $ns $UE($i) $server $cfg_(WEB_BURST_TIME) $cfg_(WEB_PACKET_SIZE) $cfg_(WEB_IDLE_TIME) $cfg_(WEB_RATE) $cfg_(WEB_SHAPE) 2 $i]	  		
		set paretoWebUpload($i) [createParetoFlow $ns $server $UE($i) $cfg_(WEB_BURST_TIME) $cfg_(WEB_PACKET_SIZE) $cfg_(WEB_IDLE_TIME) $cfg_(WEB_RATE) $cfg_(WEB_SHAPE) 2 $i]
	}
	$ns at 0.0 "$paretoWebDownload($i) start"			
	$ns at 0.0 "$paretoWebUpload($i) start"		
	incr usersHitRateCount
   
}
# define video users
set first $last
set last [expr {$last+$VIDEO_USERS}]
# counter for cache group size
set usersHitRateCount 0  
for { set i $first} { $i<$last } {incr i} {
	if {$cfg_(CACHE) == true && $usersHitRateCount < $VIDEO_CACHE_USERS} {
		# create traffic until eNB to simulate cache
		#puts "video with cache: $i"
		set paretoVideoDownload($i) [createParetoFlow $ns $UE($i) $eNB $cfg_(VIDEO_BURST_TIME) $cfg_(VIDEO_PACKET_SIZE) $cfg_(VIDEO_IDLE_TIME) $cfg_(VIDEO_RATE) $cfg_(VIDEO_SHAPE) 3 $i]
		set paretoVideoUpload($i) [createParetoFlow $ns $eNB $UE($i) $cfg_(VIDEO_BURST_TIME) $cfg_(VIDEO_PACKET_SIZE) $cfg_(VIDEO_IDLE_TIME) $cfg_(VIDEO_RATE) $cfg_(VIDEO_SHAPE) 3 $i]		
	} else {
		#puts "video without cache: $i"
		set paretoVideoDownload($i) [createParetoFlow $ns $UE($i) $server $cfg_(VIDEO_BURST_TIME) $cfg_(VIDEO_PACKET_SIZE) $cfg_(VIDEO_IDLE_TIME) $cfg_(VIDEO_RATE) $cfg_(VIDEO_SHAPE) 4 $i]
		set paretoVideoUpload($i) [createParetoFlow $ns $server $UE($i) $cfg_(VIDEO_BURST_TIME) $cfg_(VIDEO_PACKET_SIZE) $cfg_(VIDEO_IDLE_TIME) $cfg_(VIDEO_RATE) $cfg_(VIDEO_SHAPE) 4 $i]
	}
	$ns at 0.0 "$paretoVideoDownload($i) start"
	$ns at 0.0 "$paretoVideoUpload($i) start"
	incr usersHitRateCount	 			
}
# define files users
set first $last
set last [expr {$last+$FILES_USERS}]
# counter for cache group size
set usersHitRateCount 0 
for { set i $first} { $i<$last } {incr i} {
	if {$cfg_(CACHE) == true && $usersHitRateCount < $FILES_CACHE_USERS} {
		# create traffic until eNB to simulate cache
		#puts "files with cache: $i"	
		set paretoFilesDownload($i) [createParetoFlow $ns $UE($i) $eNB $cfg_(FILES_BURST_TIME) $cfg_(FILES_PACKET_SIZE) $cfg_(FILES_IDLE_TIME) $cfg_(FILES_RATE) $cfg_(FILES_SHAPE) 5 $i]
		set paretoFilesUpload($i) [createParetoFlow $ns $eNB $UE($i) $cfg_(FILES_BURST_TIME) $cfg_(FILES_PACKET_SIZE) $cfg_(FILES_IDLE_TIME) $cfg_(FILES_RATE) $cfg_(FILES_SHAPE) 5 $i]
	} else {
		#puts "files without cache: $i"
		set paretoFilesDownload($i) [createParetoFlow $ns $UE($i) $server $cfg_(FILES_BURST_TIME) $cfg_(FILES_PACKET_SIZE) $cfg_(FILES_IDLE_TIME) $cfg_(FILES_RATE) $cfg_(FILES_SHAPE) 6 $i]
		set paretoFilesUpload($i) [createParetoFlow $ns $server $UE($i) $cfg_(FILES_BURST_TIME) $cfg_(FILES_PACKET_SIZE) $cfg_(FILES_IDLE_TIME) $cfg_(FILES_RATE) $cfg_(FILES_SHAPE) 6 $i]
	}
	$ns at 0.0 "$paretoFilesDownload($i) start"
	$ns at 0.0 "$paretoFilesUpload($i) start"
	incr usersHitRateCount 				 				
}
# define voip users
set first $last
set last [expr {$last+$VOIP_USERS}]
for { set i $first} { $i<$last } {incr i} {
   #puts "voip: $i"
   set cbrVoipDownload($i) [createCbrFlow $ns $UE($i) $server $cfg_(VOIP_PACKET_SIZE)  $cfg_(VOIP_RATE) 7 $i]
   set cbrVoipUpload($i) [createCbrFlow $ns $server $UE($i) $cfg_(VOIP_PACKET_SIZE)  $cfg_(VOIP_RATE) 7 $i]
   $ns at 0.0 "$cbrVoipDownload($i) start"
   $ns at 0.0 "$cbrVoipUpload($i) start" 			 			 			 			
}


#Finish the simulation at 3.0 sec
$ns at $cfg_(SIMULATION_TIME) "finish"

proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
      puts "Simulation complete"
	exit 0
}
#
$ns run







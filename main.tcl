# imports
source configuration.tcl
source createTopology.tcl
source createTraffic.tcl
source utilities.tcl

# in case commande line parameters were provided, override default values from configuration.tcl file
foreach { key value } $argv {
	switch -- $key {
		-nn   { set cfg_(NUM_OF_CLIENTS) $value }
		-topX   { set cfg_(TOPOLOGY_X) $value }
		-topY   { set cfg_(TOPOLOGY_Y) $value }
		-bw  { set cfg_(DROP_TAIL_BW) $value }
		-dl  { set cfg_(DROP_TAIL_DELAY) $value }
		-qs   { set cfg_(QUEUE_SIZE) $value }
		-cache { set cfg_(CACHE) $value }
		-webUsers { set cfg_(WEB) $value }
		-videoUsers { set cfg_(VIDEO) $value } 
		-filesUsers { set cfg_(FILES) $value } 
		-voipUsers { set cfg_(VOIP) $value }  
	}
}


# define Simulator
global ns
set ns [new Simulator]


#Open the trace file
set f [open out.tr w]
$ns trace-all $f
set httpLog [open "http.log" w]
#add-packet-header IP TCP;
#Trace set show_tcphdr_ 1;

#Open the nam trace file 
set nf [open out.nam w]
$ns namtrace-all $nf

puts "Trace files opened..."


# create Topology - createTopology uses the file produced by initialTopology
createTopology

# if we are in scenario with cache
if {$cfg_(CACHE) == true} { 
	setUpENBCache 
}

#   define colors for better presentation
defineColors


# define number of users per traffic channel according to Alot distribution
calculateUsersDistribution


# define web users
set startIndex 0
set first 0
set last [expr {$first+$WEB_USERS}]
for { set i $first} { $i<$last } {incr i} {
   puts "web: $i"
   set paretoWebClient($i) [createParetoFlow $ns $UE($i) $server $cfg_(WEB_BURST_TIME) $cfg_(WEB_PACKET_SIZE) $cfg_(WEB_IDLE_TIME) $cfg_(WEB_RATE) $cfg_(WEB_SHAPE) 1 $i]  
   $ns at 0.0 "$paretoWebClient($i) start"			
}
# define video users
set first $last
set last [expr {$last+$VIDEO_USERS}]
for { set i $first} { $i<$last } {incr i} {
   puts "videp: $i"	
   set paretoVideoClient($i) [createParetoFlow $ns $UE($i) $server $cfg_(VIDEO_BURST_TIME) $cfg_(VIDEO_PACKET_SIZE) $cfg_(VIDEO_IDLE_TIME) $cfg_(VIDEO_RATE) $cfg_(VIDEO_SHAPE) 2 $i]
   $ns at 0.0 "$paretoVideoClient($i) start"	 			
}
# define files users
set first $last
set last [expr {$last+$FILES_USERS}]
for { set i $first} { $i<$last } {incr i} {
    puts "files: $i"	
    set paretoFilesClient($i) [createParetoFlow $ns $UE($i) $server $cfg_(FILES_BURST_TIME) $cfg_(FILES_PACKET_SIZE) $cfg_(FILES_IDLE_TIME) $cfg_(FILES_RATE) $cfg_(FILES_SHAPE) 3 $i]
    $ns at 0.0 "$paretoFilesClient($i) start" 				 				
}
# define voip users
set first $last
set last [expr {$last+$VOIP_USERS}]
for { set i $first} { $i<$last } {incr i} {
    puts "voip: $i"
   set cbrVoipClient($i) [createCbrFlow $ns $UE($i) $server $cfg_(VOIP_PACKET_SIZE) $cfg_(VOIP_MAX_PACKETS)  $cfg_(VOIP_RATE) $cfg_(VOIP_INTERVAL) 5 $i]
   $ns at 0.0 "$cbrVoipClient($i) start" 			 			
}


#Finish the simulation at 3.0 sec
$ns at 10.0 "finish"

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







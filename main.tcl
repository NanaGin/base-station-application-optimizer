# imports
source configuration.tcl
source createTopology.tcl
source createTraffic.tcl
source utilities.tcl

# in case commande line parameters were provided, override default values from configuration.tcl file
foreach { key value } $argv {
	switch -- $key {
		-tpFile  { set cfg_(TOPOLOGY_FILE) $value }
		-nn   { set cfg_(NUM_OF_CLIENTS) $value }
		-topX   { set cfg_(TOPOLOGY_X) $value }
		-topY   { set cfg_(TOPOLOGY_Y) $value }
		-bw  { set cfg_(DROP_TAIL_BW) $value }
		-dl  { set cfg_(DROP_TAIL_DELAY) $value }
		-qs   { set cfg_(QUEUE_SIZE) $value }
		-cache { set cfg_(CACHE) $value }

	}
}


# define Simulator
global ns
set ns [new Simulator]


#Open the trace file
set f [open out.tr w]
$ns trace-all $f
set httpLog [open "http.log" w]


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
   set paretoWebServer($i) [createParetoFlow $ns $server $UE($i) 210 500ms 500ms 0.5mb 1.1 1]
   set paretoWebClient($i) [createParetoFlow $ns $UE($i) $server 210 500ms 500ms 0.5mb 1.1 1]
   $ns at 0.0 "$paretoWebServer($i) start" 
   $ns at 0.0 "$paretoWebClient($i) start"			
}
# define video users
set first $last
set last [expr {$last+$VIDEO_USERS}]
for { set i $first} { $i<$last } {incr i} {
   puts "videp: $i"	
   set paretoVideoServer($i) [createParetoFlow $ns $server $UE($i) 210 500ms 500ms 0.5mb 1.1 2]
   set paretoVideoClient($i) [createParetoFlow $ns $UE($i) $server 210 500ms 500ms 0.5mb 1.1 2]
   $ns at 0.0 "$paretoVideoServer($i) start" 
   $ns at 0.0 "$paretoVideoClient($i) start"	 			
}
# define files users
set first $last
set last [expr {$last+$FILES_USERS}]
for { set i $first} { $i<$last } {incr i} {
    puts "files: $i"	
    set paretoFilesServer($i) [createParetoFlow $ns $server $UE($i) 210 500ms 500ms 0.5mb 1.1 3]
    set paretoFilesClient($i) [createParetoFlow $ns $UE($i) $server 210 500ms 500ms 0.5mb 1.1 3]
    $ns at 0.0 "$paretoFilesServer($i) start"
    $ns at 0.0 "$paretoFilesClient($i) start" 				 				
}
# define voip users
set first $last
set last [expr {$last+$VOIP_USERS}]
for { set i $first} { $i<$last } {incr i} {
    puts "voip: $i"
   set cbrVoipServer($i) [createCbrFlow $ns $server $UE($i) 210 0.25mb 5]
   set cbrVoipClient($i) [createCbrFlow $ns $UE($i) $server 210 0.25mb 5]
   $ns at 0.0 "$cbrVoipServer($i) start"
   $ns at 0.0 "$cbrVoipClient($i) start" 			 			
}


#Finish the simulation at 3.0 sec
$ns at 3.0 "finish"

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







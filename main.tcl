# imports
source configuration.tcl
source createTopology.tcl
source createTraffic.tcl

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


# create Topology - createTopology uses the file produced by iitialTopology
createTopology

# if we are in scenario with cache
if {$cfg_(CACHE) == true} { 
	setUpENBCache 
}

 #   3. traffic generation:


  #  for traffic generation we have the following options:
   # 2. POO_Traffic—generates traffic according to a Pareto On/Off distribution. This is identical to the Exponential
   # On/Off distribution, except the on and off periods are taken from a pareto distribution. These sources can be used to
   # generate aggregate traffic that exhibits long range dependency.
   # 3. CBR_Traffic—generates traffic according to a deterministic rate. Packets are constant size. Optionally, some
   # randomizing dither can be enabled on the interpacket departure intervals.

 
# for web, video and file sharing we shoud use pareto
# for vop and voice we should use cbr

#########################################

#Create a UDP agent and attach it to node n0
#set udp0 [new Agent/UDP]
#$ns attach-agent $n0 $udp0
#$udp0 set class_ 0

#Create a traffic sink and attach it to node n3
#set null0 [new Agent/Null]
#$ns attach-agent $n3 $null0

#$ns connect $udp0 $null0

#Create a CBR traffic source and attach it to udp0
#set cbr0 [new Application/Traffic/CBR]
#$cbr0 attach-agent $udp0

#$ns at 1.0 "$cbr0 start"

#puts "CBR traffic flow over UDP connection between nodes 0 and 3..." 
#puts "CBR traffic starts at time 1.0 sec..."
#########################################

#Create a UDP agent and attach it to node n3
#set udp1 [new Agent/UDP]
#$ns attach-agent $n3 $udp1
#$udp1 set class_ 1

#Create a traffic sink and attach it to node n1
#set null1 [new Agent/Null]
#$ns attach-agent $n1 $null1

#$ns connect $udp1 $null1

#Create a CBR traffic source and attach it to udp1
#set cbr1 [new Application/Traffic/CBR]
#$cbr1 attach-agent $udp1

#$ns at 1.1 "$cbr1 start"

#puts "CBR traffic flow over UDP connection between nodes 3 and 1..." 
#puts "CBR traffic starts at time 1.1 sec..."
#########################################

#Create a TCP agent
#set tcp [new Agent/TCP]
#$tcp set class_ 2

#Create a TCP sink
#set sink [new Agent/TCPSink]

#TCP connection from node n0 to node n3
#$ns attach-agent $n0 $tcp
#$ns attach-agent $n3 $sink
#$ns connect $tcp $sink

#Create an ftp traffic source
##set ftp [new Application/FTP]
#$ftp attach-agent $tcp

#Start the ftp session at 1.2 sec
#$ns at 1.2 "$ftp start"

#Stop the ftp session at 1.35 sec
#$ns at 1.35 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

#puts "ftp traffic flow over TCP connection between nodes 0 and 3..." 
#puts "ftp traffic starts at time 1.2 sec and finishes at time 1.35 sec..." 
#########################################

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



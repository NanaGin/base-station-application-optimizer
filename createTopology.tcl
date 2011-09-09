# Create topology


proc createTopology {} {
	global ns node cfg_
	
	# define topology
	global topology
	set topology    [new Topography]
	$topology load_flatgrid $cfg_(TOPOLOGY_X) $cfg_(TOPOLOGY_Y)

	# define wired nodes
	defineWiredNode 
	# create gateways and server
	
	set eNB [$ns node];#node id is 0
	$ns at 0.0 "$eNB label eNB"  
	set SGW [$ns node];#node id is 1
	$ns at 0.0 "$SGW label SGW"  
	set GGW [$ns node];#node id is 2
	$ns at 0.0 "$GGW label GGW"  
	set server [$ns node];#node id is 3	
	$ns at 0.0 "$server label server"  

	#defineWirelessNode
	# create nodes
	for { set i 0} {$i<$cfg_(NUM_OF_CLIENTS)} {incr i} {
		set UE($i) [$ns node]
		$ns at 0.0 "$UE($i) label UE_$i"  		
	}
	
	# load nodes locations - randomized
	# uses TOPOLOGY_FILE from configuration file, unless provided as input argument to main.tcl
	source $cfg_(TOPOLOGY_FILE)

	# step 2: define the links to connect the nodes
	for { set i 0} {$i<$cfg_(NUM_OF_CLIENTS)} {incr i} {
		$ns simplex-link $UE($i) $eNB $cfg_(DROP_TAIL_BW) $cfg_(DROP_TAIL_DELAY) $cfg_(DROP_TAIL) 
		$ns simplex-link $eNB $UE($i) $cfg_(DROP_TAIL_BW) $cfg_(DROP_TAIL_DELAY) $cfg_(DROP_TAIL)  
		#set queue limit_
		$ns queue-limit $UE($i) $eNB $cfg_(QUEUE_SIZE)
	}


	# The bandwidth between GGW and server is not the bottleneck, so we use DropTail
	$ns duplex-link $eNB $SGW $cfg_(DROP_TAIL_BW) $cfg_(DROP_TAIL_DELAY) $cfg_(DROP_TAIL) 
	$ns duplex-link-op $eNB $SGW  orient right 
	$ns queue-limit $eNB $SGW $cfg_(QUEUE_SIZE)	
	$ns duplex-link $SGW $GGW $cfg_(DROP_TAIL_BW) $cfg_(DROP_TAIL_DELAY) $cfg_(DROP_TAIL) 
	$ns duplex-link-op $SGW $GGW orient right 
	$ns queue-limit $SGW $GGW $cfg_(QUEUE_SIZE)
	$ns duplex-link $GGW $server $cfg_(DROP_TAIL_BW) $cfg_(DROP_TAIL_DELAY) $cfg_(DROP_TAIL) 
	$ns duplex-link-op $GGW $server orient right 
	$ns queue-limit $GGW $server $cfg_(QUEUE_SIZE)


	puts "Topology defined..."

}



proc defineWiredNode {} {
	# define wired node
	global ns cfg_ topology
	$ns node-config -llType $cfg_(LL_TYPE)	\
			-macType $cfg_(MAC_TYPE) \
			-ifqType $cfg_(QUEUE_TYPE) \
			-ifqLen $cfg_(QUEUE_SIZE) \
			-antType $cfg_(ANTENA_TYPE) \
			-propType $cfg_(PROPAGATION_TYPE) \
			-phyType $cfg_(PHYSICAL_TYPE) \
			-topoInstance $topology \
			-agentTrace ON \
			-routerTrace ON \
			-macTrace ON \
			-movementTrace OFF
}

proc defineWirelessNode {} {
	# define wireless node
	global ns cfg_ topology
	$ns node-config -llType $cfg_(LL_TYPE)	\
			-macType $cfg_(MAC_TYPE) \
			-ifqType $cfg_(QUEUE_TYPE) \
			-ifqLen $cfg_(QUEUE_SIZE) \
			-antType $cfg_(ANTENA_TYPE) \
			-propType $cfg_(PROPAGATION_TYPE) \
			-phyType $cfg_(PHYSICAL_WIRELESS_TYPE) \
			-channel $cfg_(CHANNEL_WIRELESS) \
			-topoInstance $topology \
			-agentTrace ON \
			-routerTrace ON \
			-macTrace ON \
			-movementTrace OFF
}



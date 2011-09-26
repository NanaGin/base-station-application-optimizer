#Application/Traffic/Pareto
#    Application/Traffic/Pareto objects generate On/Off traffic with burst times and idle times taken from pareto distributions. Configuration parameters are:
#    PacketSize_   constant size of packets generated.
#    burst_time_   average on time for generator.
#    idle_time_    average off time for generator.
#    rate_         sending rate during on time.
#    shape_        the shape parameter used by pareto distribution.  (mean object size - check in Allot)

# Application/Traffic/CBR
#    CBR objects generate packets at a constant bit rate.

 #   $cbr start
 #   Causes the source to start generating packets.

 #  $cbr stop
 #  Causes the source to stop generating packets.
 # Configuration parameters are:
#    PacketSize_
#        constant size of packets generated. 
#    rate_
#        sending rate.
#    interval_
#        (optional) interval between packets.
#    random_
#        whether or not to introduce random noise in the scheduled departure times. defualt is off.
#    maxpkts_
#        maximum number of packets to send. 


# format: set pareto($k) [createParetoFlow ns src dst burst size idle rate shape color]
proc createParetoFlow {ns src dst burst size idle rate shape fid i} {	
	#Setup a TCP connection
	set tcp($i) [new Agent/TCP]
	$tcp($i) set maxcwnd_ 16	
	#$ns add-agent-trace $tcp($i) tcp
	$tcp($i) set class_ 3 
	$ns attach-agent $src $tcp($i)		
	set sink($i) [new Agent/TCPSink] 
	$ns attach-agent $dst $sink($i)  
	$ns connect $tcp($i) $sink($i) 
	$tcp($i)  set fid_ $fid 
	
	#Setup a Pareto ON/OFF traffic  session over UDP connection 
	set p($i) [new Application/Traffic/Pareto] 
	$p($i) attach-agent $tcp($i)
	$p($i) set packet_size_ $size 
	$p($i) set burst_time_ $burst
	$p($i) set idle_time_ $idle
	$p($i) set rate_ $rate
	$p($i) set shape_ $shape
	return $p($i)
}

# format: set cbr($k) [createCbrFlow ns src dst size maxPackets rate interval color i]
proc createCbrFlow {ns src dst size rate fid i} {
	#Setup a UDP connection 
	set udp($i) [new Agent/UDP]
	$udp($i) set class_ 1 
	$ns attach-agent $src $udp($i) 
	set null($i) [new Agent/Null] 
	$ns attach-agent $dst $null($i) 
	$ns connect $udp($i) $null($i) 
	$udp($i) set fid_ $fid 

	#Setup a CBR traffic session over UDP connection 
	set c($i) [new Application/Traffic/CBR] 
	$c($i) attach-agent $udp($i)
	$c($i) set type_ CBR 
	$c($i) set packet_size_ $size
	$c($i) set rate_ $rate 
	$c($i) set random_ false
	return $c($i) 
}

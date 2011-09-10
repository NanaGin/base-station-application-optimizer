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
proc createParetoFlow {ns src dst burst size idle rate shape fid} {
	#Setup a UDP connection 
	set udp [new Agent/UDP] 
	$ns attach-agent $src $udp 
	set null [new Agent/Null] 
	$ns attach-agent $dst $null 
	$ns connect $udp $null 
	$udp set fid_ $fid 
	
	#Setup a Pareto ON/OFF traffic  session over UDP connection 
	set p [new Application/Traffic/Pareto] 
	$p attach-agent $udp 
	$p set packet_size_ $size 
	$p set burst_time_ $burst
	$p set idle_time_ $idle
	$p set rate_ $rate
	$p set shape_ $shape
	return $p
}

# format: set cbr($k) [createCbrFlow ns src dst size rate color]
proc createCbrFlow {ns src dst size rate fid} {
	#Setup a UDP connection 
	set udp [new Agent/UDP] 
	$ns attach-agent $src $udp 
	set null [new Agent/Null] 
	$ns attach-agent $dst $null 
	$ns connect $udp $null 
	$udp set fid_ $fid 

	#Setup a CBR traffic session over UDP connection 
	set c [new Application/Traffic/CBR] 
	$c attach-agent $udp 
	$c set type_ CBR 
	$c set packet_size_ $size 
	$c set rate_ $rate 
	$c set random_ false 

	return $c
}

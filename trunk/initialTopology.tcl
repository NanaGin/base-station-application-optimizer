set val(nn)               [lindex $argv 0] ;#number of nodes
set val(x)                [lindex $argv 1]   
set val(y)                [lindex $argv 2]
set val(outfile)          [lindex $argv 3] ;#output file name 


if { $argc != 4 } {
        puts "The initial_topology.tcl script requires four parameters to be inputed."
        puts "1.number of node >0"
	puts "2. X coordinate"
	puts "3. Y coordinate"
        puts "4. output file name"
	puts "Please try again."
}  else {
	set topo [open $val(outfile) w] ;#open the file for writing
	set rng_ [new RNG]
    	$rng_ seed 0
	for {set i 0} {$i<$val(nn)} {incr i} {	
		set randX  [$rng_ uniform 0.0 $val(x)]
		set randY  [$rng_ uniform 0.0 $val(x)]   
		puts $topo "\$UE($i) set X_ $randX"
		puts $topo "\$UE($i) set Y_ $randY"
		puts $topo "\$UE($i) set Z_ 0.0"
		puts $topo "\$ns initial_node_pos \$UE($i) 30"
    }
   close $topo
}



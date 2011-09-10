

# this procedure divides users according to the distribution from configuration.tcl
# 1. divides all "whole" users - results of percentage calculations
# 2. sums up all remainders from the division
# 3. while there are users left, divide them according to the highest remainder
proc calculateUsersDistribution {} {
	global cfg_ WEB_USERS VIDEO_USERS FILES_USERS VOIP_USERS
	set WEB_USERS  [expr {($cfg_(NUM_OF_CLIENTS)*$cfg_(WEB))/100}]
	set webRemainder [expr {fmod($cfg_(NUM_OF_CLIENTS)*$cfg_(WEB),100)/100}]
	set VIDEO_USERS  [expr {($cfg_(NUM_OF_CLIENTS)*$cfg_(VIDEO))/100}]
	set videoRemainder [expr {fmod($cfg_(NUM_OF_CLIENTS)*$cfg_(VIDEO),100)/100}]
	set FILES_USERS  [expr {($cfg_(NUM_OF_CLIENTS)*$cfg_(FILES))/100}]
	set filesRemainder [expr {fmod($cfg_(NUM_OF_CLIENTS)*$cfg_(FILES),100)/100}]
	set VOIP_USERS  [expr {($cfg_(NUM_OF_CLIENTS)*$cfg_(VOIP))/100}]
	set voipRemainder [expr {fmod($cfg_(NUM_OF_CLIENTS)*$cfg_(VOIP),100)/100}]
	set leftUsers [expr {$cfg_(NUM_OF_CLIENTS) - $VOIP_USERS - $FILES_USERS - $VIDEO_USERS - $WEB_USERS}]

	set x 0
	while {$x<$leftUsers} {
	    set max $webRemainder
	    set position 0
	    if {$videoRemainder>$max} {	
		set max $videoRemainder
		set position 1 
	    }
	    if {$filesRemainder>$max} {	
		set max $filesRemainder
		set position 2 
	    }
	    if {$voipRemainder>$max} {	
		set max $voipRemainder
		set position 3 
	    }

	    if {$position == 0} {
		set webRemainder 0
		incr WEB_USERS
	    }
	    if {$position == 1} {
		set videoRemainder 0
		incr VIDEO_USERS
	    }
	    if {$position == 2} {
		set filesRemainder 0
		incr FILES_USERS
	    }
	    if {$position == 3} {
		set voipRemainder 0
		incr VOIP_USERS
	    }
	    incr x
	}

}

proc defineColors {} {
 global ns
 # colors
 # used for web
 $ns color 1 Blue   
 # used for video
 $ns color 2 green  
 # used for cbr
 $ns color 3 Red   
 $ns color 4 purple 
 # used for files
 $ns color 5 orange  
 $ns color 6 yellow 
}


# global variables
global cfg_  

# topology configurations, can be overwritten by command-line options
set cfg_(NUM_OF_CLIENTS) 10
set cfg_(DROP_TAIL_BW) 10Mb
set cfg_(DROP_TAIL_DELAY) 10ms
set cfg_(QUEUE_SIZE) 100
set cfg_(TOPOLOGY_X) 5000
set cfg_(TOPOLOGY_Y) 5000
set cfg_(TOPOLOGY_FILE) topology.tcl

# nodes configuration - wired / wireless

set cfg_(LL_TYPE) LL
set cfg_(MAC_TYPE) Mac/802_11
set cfg_(PROPAGATION_TYPE) Propagation/TwoRayGround
set cfg_(QUEUE_TYPE) Queue/DropTail/PriQueue
set cfg_(DROP_TAIL) DropTail
set cfg_(PHYSICAL_TYPE) Phy/Sat
set cfg_(PHYSICAL_WIRELESS_TYPE) Phy/WirelessPhy
set cfg_(ANTENA_TYPE) Antenna/OmniAntenna
#set cfg_(ENERGY_MODEL) 
#set cfg_(INIT_ENERGY)
#set cfg_(RX_POWER)
#set cfg_(TX_POWER)
set cfg_(CHANNEL_WIRELESS) Channel/WirelessChannel
set cfg_(CHANNEL_WIRED) Channel/Sat 







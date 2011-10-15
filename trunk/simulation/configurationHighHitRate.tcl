
# global variables
global cfg_  

# simulation time
set cfg_(SIMULATION_TIME) 300.0
set cfg_(TRACE_FILENAME) out.tr

set cfg_(NUM_OF_CLIENTS) 10
set cfg_(DROP_TAIL_BW) 10Mb
set cfg_(DROP_TAIL_DELAY) 10ms
set cfg_(DROP_TAIL_DELAY_SERVER) 150ms
set cfg_(UE_QUEUE_SIZE) 10
set cfg_(TOPOLOGY_X) 5000
set cfg_(TOPOLOGY_Y) 5000

# the defaut scenario is without a cache
set cfg_(CACHE) false


# traffic parameters

# usage distribution
set cfg_(WEB) 26
set cfg_(VIDEO) 37
set cfg_(FILES) 30
set cfg_(VOIP) 7

# cache parameters - hit rate per traffic
set cfg_(WEB_HIT_RATE) 22
set cfg_(VIDEO_HIT_RATE) 44
set cfg_(FILES_HIT_RATE) 44


# web params
set cfg_(WEB_BURST_TIME) 200ms
set cfg_(WEB_IDLE_TIME) 2000ms
set cfg_(WEB_RATE) 300Kb
set cfg_(WEB_PACKET_SIZE) 1040
set cfg_(WEB_SHAPE) 1.3

# video params
set cfg_(VIDEO_BURST_TIME) 2000ms
set cfg_(VIDEO_IDLE_TIME) 2000ms
set cfg_(VIDEO_RATE) 600Kb
set cfg_(VIDEO_PACKET_SIZE) 1300
set cfg_(VIDEO_SHAPE) 1.5

# files params
set cfg_(FILES_BURST_TIME) 2000ms
set cfg_(FILES_IDLE_TIME) 200ms
set cfg_(FILES_RATE) 100Kb
set cfg_(FILES_PACKET_SIZE) 1600
set cfg_(FILES_SHAPE) 1.7

# voip params
set cfg_(VOIP_PACKET_SIZE) 200
set cfg_(VOIP_RATE) 64Kb


# nodes configuration - wired / wireless

set cfg_(LL_TYPE) LL
set cfg_(MAC_TYPE) Mac/802_11
set cfg_(PROPAGATION_TYPE) Propagation/TwoRayGround
set cfg_(QUEUE_TYPE) Queue/DropTail/PriQueue
set cfg_(DROP_TAIL) DropTail
set cfg_(PHYSICAL_TYPE) Phy/Sat
set cfg_(PHYSICAL_WIRELESS_TYPE) Phy/WirelessPhy
set cfg_(ANTENA_TYPE) Antenna/OmniAntenna
set cfg_(CHANNEL_WIRELESS) Channel/WirelessChannel
set cfg_(CHANNEL_WIRED) Channel/Sat 






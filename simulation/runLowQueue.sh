#!/bin/sh

cd ~/code/base-station-application-optimizer/simulation
ns mainLowQueue.tcl -nn 20 -cache false -traceFile /media/LENOVO/nana/20_noCache_lowQueue.tr
ns mainLowQueue.tcl -nn 20 -cache true -traceFile /media/LENOVO/nana/20_withCache_lowQueue.tr
ns mainLowQueue.tcl -nn 50 -cache false -traceFile /media/LENOVO/nana/50_noCache_lowQueue.tr
ns mainLowQueue.tcl -nn 50 -cache true -traceFile /media/LENOVO/nana/50_withCache_lowQueue.tr
ns mainLowQueue.tcl -nn 100 -cache false -traceFile /media/LENOVO/nana/100_noCache_lowQueue.tr
ns mainLowQueue.tcl -nn 100 -cache true -traceFile /media/LENOVO/nana/100_withCache_lowQueue.tr

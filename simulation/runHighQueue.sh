#!/bin/sh

cd ~/code/base-station-application-optimizer/simulation
ns mainHighQueue.tcl -nn 20 -cache false -traceFile /media/LENOVO/nana/20_noCache_highQueue.tr
ns mainHighQueue.tcl -nn 20 -cache true -traceFile /media/LENOVO/nana/20_withCache_highQueue.tr
ns mainHighQueue.tcl -nn 50 -cache false -traceFile /media/LENOVO/nana/50_noCache_highQueue.tr
ns mainHighQueue.tcl -nn 50 -cache true -traceFile /media/LENOVO/nana/50_withCache_highQueue.tr
ns mainHighQueue.tcl -nn 100 -cache false -traceFile /media/LENOVO/nana/100_noCache_highQueue.tr
ns mainHighQueue.tcl -nn 100 -cache true -traceFile /media/LENOVO/nana/100_withCache_highQueue.tr

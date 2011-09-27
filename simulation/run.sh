#!/bin/sh

cd ~/code/base-station-application-optimizer/simulation
ns main.tcl -nn 20 -cache false -traceFile /media/LENOVO/nana/20_noCache.tr
ns main.tcl -nn 20 -cache true -traceFile /media/LENOVO/nana/20_withCache.tr
ns main.tcl -nn 50 -cache false -traceFile /media/LENOVO/nana/50_noCache.tr
ns main.tcl -nn 50 -cache true -traceFile /media/LENOVO/nana/50_withCache.tr
ns main.tcl -nn 100 -cache false -traceFile /media/LENOVO/nana/100_noCache.tr
ns main.tcl -nn 100 -cache true -traceFile /media/LENOVO/nana/100_withCache.tr

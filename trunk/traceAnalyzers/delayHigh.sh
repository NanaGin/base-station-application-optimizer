#!/bin/sh

cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelayCache.awk /media/LENOVO/nana/20_withCache_lowHitRate.tr low_nodes=20
awk -f endToEndDelayCache.awk /media/LENOVO/nana/50_withCache_lowHitRate.tr low_nodes=50
awk -f endToEndDelayCache.awk /media/LENOVO/nana/100_withCache_lowHitRate.tr low_nodes=100


# run delay , dropped percentage - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelayCache.awk /media/LENOVO/nana/20_withCache_highHitRate.tr high_nodes=20
awk -f endToEndDelayCache.awk /media/LENOVO/nana/50_withCache_highHitRate.tr high_nodes=50
awk -f endToEndDelayCache.awk /media/LENOVO/nana/100_withCache_highHitRate.tr high_nodes=100


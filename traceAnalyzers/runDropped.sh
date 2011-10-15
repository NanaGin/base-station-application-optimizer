#!/bin/sh

# run delay , dropped percentage - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelayCache.awk /media/LENOVO/nana/20_withCache.tr nodes=20
awk -f endToEndDelayCache.awk /media/LENOVO/nana/50_withCache.tr nodes=50
awk -f endToEndDelayCache.awk /media/LENOVO/nana/100_withCache.tr nodes=100


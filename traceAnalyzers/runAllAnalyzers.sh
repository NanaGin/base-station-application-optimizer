#!/bin/sh


# run total bytes analyses
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Total Bytes on 20 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/20_noCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/20_noCache_lowHitRate.txt
echo "Running Total Bytes on 20 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/20_withCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/20_withCache_lowHitRate.txt
echo "Running Total Bytes on 50 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/50_noCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/50_noCache_lowHitRate.txt
echo "Running Total Bytes on 50 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/50_withCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/50_withCache_lowHitRate.txt
echo "Running Total Bytes on 100 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/100_noCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/100_noCache_lowHitRate.txt
echo "Running Total Bytes on 100 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/100_withCache_lowHitRate.tr > /media/LENOVO/nana/totalBytes/100_withCache_lowHitRate.txt
echo "Finished Running Total Bytes statistics"

# run bytes er second analysis - no cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Bytes Per Second on 20 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/20_noCache_lowHitRate.tr low_nodes=20
echo "Running Bytes Per Second on 50 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/50_noCache_lowHitRate.tr low_nodes=50
echo "Running Bytes Per Second on 1000 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/100_noCache_lowHitRate.tr lownodes=100

# run bytes per second analysis - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Bytes Per Second on 20 nodes with cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/20_withCache_lowHitRate.tr low_nodes=20
echo "Running Bytes Per Second on 50 nodes with cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/50_withCache_lowHitRate.tr low_nodes=50
echo "Running Bytes Per Second on 100 nodes 100 cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/100_withCache_lowHitRate.tr low_nodes=100
echo "Finished Running Bytes Per Second statistics"



# run delay , dropped percentage - no cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelay.awk /media/LENOVO/nana/20_noCache_lowHitRate.tr low_nodes=20
awk -f endToEndDelay.awk /media/LENOVO/nana/50_noCache_lowHitRate.tr low_nodes=50
awk -f endToEndDelay.awk /media/LENOVO/nana/100_noCache_lowHitRate.tr low_nodes=100

# run delay , dropped percentage - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelayCache.awk /media/LENOVO/nana/20_withCache_lowHitRate.tr low_nodes=20
awk -f endToEndDelayCache.awk /media/LENOVO/nana/50_withCache_lowHitRate.tr low_nodes=50
awk -f endToEndDelayCache.awk /media/LENOVO/nana/100_withCache_lowHitRate.tr low_nodes=100


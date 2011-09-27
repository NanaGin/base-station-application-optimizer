#!/bin/sh


# run total bytes analyses
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Total Bytes on 20 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/20_noCache.tr > /media/LENOVO/nana/totalBytes/20_noCache.txt
echo "Running Total Bytes on 20 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/20_withCache.tr > /media/LENOVO/nana/totalBytes/20_withCache.txt
echo "Running Total Bytes on 50 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/50_noCache.tr > /media/LENOVO/nana/totalBytes/50_noCache.txt
echo "Running Total Bytes on 50 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/50_withCache.tr > /media/LENOVO/nana/totalBytes/50_withCache.txt
echo "Running Total Bytes on 100 nodes no cache"
./totalBandwith.sh /media/LENOVO/nana/100_noCache.tr > /media/LENOVO/nana/totalBytes/100_noCache.txt
echo "Running Total Bytes on 100 nodes with cache"
./totalBandwith.sh /media/LENOVO/nana/100_withCache.tr > /media/LENOVO/nana/totalBytes/100_withCache.txt
echo "Finished Running Total Bytes statistics"

# run bytes er second analysis - no cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Bytes Per Second on 20 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/20_noCache.tr nodes=20
echo "Running Bytes Per Second on 50 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/50_noCache.tr nodes=50
echo "Running Bytes Per Second on 1000 nodes no cache"
awk -f banwithPerSecond.awk /media/LENOVO/nana/100_noCache.tr nodes=100

# run bytes per second analysis - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
echo "Running Bytes Per Second on 20 nodes with cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/20_withCache.tr nodes=20
echo "Running Bytes Per Second on 50 nodes with cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/50_withCache.tr nodes=50
echo "Running Bytes Per Second on 100 nodes 100 cache"
awk -f banwithPerSecondWithCache.awk /media/LENOVO/nana/100_withCache.tr nodes=100
echo "Finished Running Bytes Per Second statistics"

exit

# run delay , dropped percentage - no cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelay.awk /media/LENOVO/nana/20_noCache.tr nodes=20
awk -f endToEndDelay.awk /media/LENOVO/nana/50_noCache.tr nodes=50
awk -f endToEndDelay.awk /media/LENOVO/nana/100_noCache.tr nodes=100

# run delay , dropped percentage - with cache
cd /home/benny/code/base-station-application-optimizer/traceAnalyzers
awk -f endToEndDelayCache.awk /media/LENOVO/nana/20_noCache.tr nodes=20
awk -f endToEndDelayCache.awk /media/LENOVO/nana/50_noCache.tr nodes=50
awk -f endToEndDelayCache.awk /media/LENOVO/nana/100_noCache.tr nodes=100


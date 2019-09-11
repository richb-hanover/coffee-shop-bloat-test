#!/bin/sh

# Coffee Shop Bloat Test
# Collect objective measurements of bufferbloat in a coffee shop (or anywhere)
# Originally proposed by Dave Täht on the Bloat mailing list in
# https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html
#
# Usage: sh coffee-shop-bloat-test.sh "Coffee Shop Name"

# Options: The sole option is the name of the coffee shop, in quotes.
#           The name will be saved with the results, and displayed in the plots.
#           If no name is provided, default to computer name

# Results are saved as files named:
#	rrul_be-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	rrul-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	tcp_nup-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	tcp_ndown-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz

# Copyright (c) 2019 - Rich Brown rich.brown@blueberryhillsoftware.com
# GPLv2

CSN=`hostname`        # Coffee Shop Name - default to the host name
# Get the Coffee Shop Name and grep " " to "_"
if [ $# -eq 1 ]
then
  CSN=$1  
fi
CSN=${CSN// /_}

# Other global variables
H="flent-fremont.bufferbloat.net"
PINGHOST="1.1.1.1"
F="flent -x -H $H -t $CSN --te=ping_hosts=$PINGHOST"

# Print baseline latency
echo "Testing from $CSN to $H"
echo "Measuring baseline latency to $PINGHOST..."
fping -D -q -c 5 $PINGHOST # ping five times
echo ""

# Run successive Flent tests: tcp_ndown, tcp_nup, rrul, rrul_be
$F --te=download_streams=4 tcp_ndown
$F --te=upload_streams=4 tcp_nup # removed --socket-stats option for macOS
# $F --te=upload_streams=4 tcp_2up_square # not useful enough
$F rrul
$F rrul_be

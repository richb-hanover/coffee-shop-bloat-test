#!/bin/bash

# Coffee Shop Bloat Test
# Collect objective measurements of bufferbloat in a coffee shop (or anywhere)
# Originally proposed by Dave Täht on the Bloat mailing list in
# https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html
#
# Usage: sh coffee-shop-bloat-test.sh "Coffee Shop Name"

# Options: The sole option is the name of the coffee shop, in quotes.
#           The name will be saved within the results, and displayed in the plots.
#           If no name is provided, default to computer name

# Results are saved as files named:
#	rrul_be-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	rrul-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	tcp_nup-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz
#	tcp_ndown-YYYY-MM-DDThhmmss.xxxxxx.Coffee_Shop_Name.flent.gz

# Use nearby anycast addresses for PINGHOST4 and PINGHOST6 to minimize base
#   latency measurements. Adding 3 msec of bloat to a 15 msec base is a
#   larger percentage change than 3 msec added onto 50 msec at the -H host
# See https://blog.cloudflare.com/dns-resolver-1-1-1-1/ for information
#   about Cloudflare's IPv4 & IPv6 anycast addresses

# Note: Early versions of this script removed the --socket-stats option
#   because that's not currently available for macOS

# Copyright (c) 2019 - Rich Brown rich.brown@blueberryhillsoftware.com
# GPLv2

# Global variables
H="flent-fremont.bufferbloat.net" # default Flent server
PINGHOST4="1.1.1.1"               # Cloudflare Anycast IPv4 DNS resolver
PINGHOST6="2606:4700:4700::1111"  # Cloudflare Anycast IPv6 DNS resolver
CSN=`hostname`                    # Coffee Shop Name - default to the host name

# Process any arguments
# Get the Coffee Shop Name and grep " " to "_"
if [ $# -eq 1 ]
then
  CSN=$1  
fi
CSN=`echo $CSN | tr -s ' ' | tr ' ' '_'`

# Build the base Flent command
F="flent -x -H $H -t $CSN --te=ping_hosts=$PINGHOST4"

# ----- Start the testing -----
# Print baseline latency for IPv4 & IPv6 (no error if IPv6 not available)
echo "Testing from $CSN to $H"
echo "Measuring baseline latency to $PINGHOST4 and $PINGHOST6..."
fping -D -q -c 5 -4 $PINGHOST4 # ping five times
fping -D -q -c 5 -6 $PINGHOST6 # ping five times
echo ""

# Run successive Flent tests: tcp_ndown, tcp_nup, rrul, rrul_be
$F --te=download_streams=4 tcp_ndown
$F --te=upload_streams=4 tcp_nup 
$F rrul
$F rrul_be

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

# Copyright (c) 2019-2020 - Rich Brown rich.brown@blueberryhillsoftware.com
# GPLv2

# Constants
# Cloudflare Anycast DNS resolvers - we'll ping them (v4 or v6) when testing
# PINGHOST4=1.1.1.1                 # or 1.0.0.1 
# PINGHOST6=2606:4700:4700::1111    # or 2606:4700:4700::1001
PINGHOST4="one.one.one.one"         # looks as if these names work for both v4 & v6
PINGHOST6="one.one.one.one"

# Global variables
CSN=`hostname`                    # Coffee Shop Name - default to this computer's host name
H="flent-fremont.bufferbloat.net" # default Flent server for this test
V46="-4"                          # default to IPv4
PINGHOST=$PINGHOST4               # default to IPv4
TEST_DIRECTORY="Test_Results"     # Save tests to a separate directory

# extract options and their arguments into variables.
while [ $# -gt 0 ] 
do
    case "$1" in
      -4) PINGHOST=$PINGHOST4 ;
		  V46="-4" ; 
		  shift 1 ;;   
      -6) PINGHOST=$PINGHOST6 ;
		  V46="-6" ; 
		  shift 1 ;;   
      -H|--host)
          case "$2" in
              "") echo "Missing hostname" ; exit 1 ;;
              *) H=$2 ; shift 2 ;;
          esac ;;
      ?|--help) 
		  echo 'Usage: sh coffee-shop-bloat-test.sh "Coffee Shop Name" [ -H netperf-server ] [ -4 | -6 ]'; exit 1 ;;
      *) CSN=$1
		 CSN=`echo $CSN | tr -s ' ' | tr ' ' '_'`
		 shift 1
		;;
    esac
done

# Build the base Flent command
F="flent -x $V46 -H $H -t $CSN --te=ping_hosts=$PINGHOST"

# ----- Start the testing -----
# Print baseline latency for IPv4 & IPv6 (no error if IPv6 not available)
echo "======== Coffee Shop Bloat Test ========"
echo "Testing from $CSN to $H"
echo "Measuring IPv4 & IPv6 baseline latency..." # ping five times each
fping -D -q -c 5 -4 $PINGHOST4 | printf "IPv4: %s"
fping -D -q -c 5 -6 $PINGHOST6 | printf "IPv6: %s"
echo ""

# Run successive Flent tests: tcp_ndown, tcp_nup, rrul, rrul_be
cd $TEST_DIRECTORY                     # save test results in their own directory
$F --te=download_streams=4 tcp_ndown
$F --te=upload_streams=4 tcp_nup 
$F rrul
$F rrul_be

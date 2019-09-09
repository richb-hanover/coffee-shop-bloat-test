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

# Get the Coffee Shop Name and grep " " to "_"
if [ $# -ne 0 ]
then
  CSN=${1// /_}
else
  H=`hostname`        # Otherwise, just use the host name
  CSN="Tested_from_$H"
fi

F="flent -x -H flent-fremont.bufferbloat.net -t $CSN"

$F --te=download_streams=4 tcp_ndown
$F --te=upload_streams=4 tcp_nup # removed --socket-stats option for macOS
# $F --te=upload_streams=4 tcp_2up_square # not useful enough
$F rrul
$F rrul_be

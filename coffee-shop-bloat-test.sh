#!/bin/sh
# Coffee Shop Bloat Test
# Collect objective measurements of bufferbloat in a coffee shop (or anywhere)
# Originally proposed by Dave Täht on the Bloat mailing list in
# https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html
#
# Parameter is the name of the coffee shop "IN QUOTES"
# Results are saved as files named:
#	rrul_be-YYYY-MM-DDThhmmss.xxxxxx.Coffee-Shop-Name.flent.gz
#	rrul-YYYY-MM-DDThhmmss.xxxxxx.Coffee-Shop-Name.flent.gz
#	tcp_nup-YYYY-MM-DDThhmmss.xxxxxx.Coffee-Shop-Name.flent.gz
#	tcp_ndown-YYYY-MM-DDThhmmss.xxxxxx.Coffee-Shop-Name.flent.gz

T="Los_Gatos_Starbucks"
F="flent -x -H flent-fremont.bufferbloat.net -t $T"

$F --te=download_streams=4 tcp_ndown
$F --te=upload_streams=4 tcp_nup # removed --socket-stats option for macOS
# $F --te=upload_streams=4 tcp_2up_square # not useful enough
$F rrul
$F rrul_be

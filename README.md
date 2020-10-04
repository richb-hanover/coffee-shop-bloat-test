# Coffee Shop Bloat Test

This script is an elaboration on [Dave Täht's original script](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html) on the Bloat mailing list.
[Dave says:](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009332.html)

> The coffee shop tests were fun, but I (we) needed more rigor when doing them. What I'd typically do is go in,
get on the wifi, start 6 minutes worth of tests, get in line, get
coffee... I would feel a twinge of guilt when I'd
start seeing heads pop up from their laptops while running the rrul
test, but in two cases I managed to talk to
the owner, help 'em get QoS configured right on their router, show'd
'em the difference, and got a free meal out of it...

Now you too can "instrument" your local coffee shop, with the goal of making the world's internet access a little bit better. 

## Prerequisites
You must install the [Flent](https://flent.org) software on your laptop before running the script. 
See the [Flent Quick Start](https://flent.org/intro.html#quick-start) for advice about your operating system. 

## Run the Bloat Test
To run the script, use the command below. Place the coffee shop name in quotes:

`sh coffee-shop-bloat-test.sh "Coffee Shop Name" [ -H <host> ] [ -4 | -6 ]`

- `-H` The default netperf server is flent-fremont.bufferbloat.net.
You can use the `-H` option to configure any of the netperf servers at netperf*.bufferbloat.net.

- `[ -4 | -6 ]` Force ping-time measurements to use v4/v6 with this option.
Default is `-4`.


## Operation

The script first measures baseline latency to a "nearby" IPv4 and IPv6 host.
The script uses the Cloudflare anycast DNS server for this (at 1.1.1.1, or 2606:4700:4700::1001).
Both these are available by the DNS name "one.one.one.one" (!).

It then runs several Flent tests in succession: tcp\_ndown, tcp\_nup, rrul, rrul\_be.
Each of the tests runs for 70 seconds, so the full suite of tests will take five or six minutes.
Each test writes its results to the terminal in this form:

```
bash-3.2$ sh coffee-shop-bloat-test.sh "Coffee Shop Name"
Testing from Coffee_Shop_Name to flent-fremont.bufferbloat.net
Measuring IPv4 & IPv6 baseline latency...
IPv4: one.one.one.one : xmt/rcv/%loss = 5/5/0%, min/avg/max = 24.7/24.9/25.3
IPv6: one.one.one.one : xmt/rcv/%loss = 5/5/0%, min/avg/max = 30.9/33.2/36.6

Started Flent 1.9.9-git-436d5b6 using Python 3.7.3.
Starting tcp_ndown test. Expected run time: 70 seconds.
Data file written to ./tcp_ndown-2019-09-15T123123.380936.Coffee_Shop_Name.flent.gz

Summary of tcp_ndown test run from 2019-09-15 16:31:23.380936
  Title: 'Coffee_Shop_Name'

                                           avg       median          # data pts
 Ping (ms) ICMP                 :       117.30       109.00 ms              350
 Ping (ms) ICMP 1.1.1.1 (extra) :        35.25        31.20 ms              350
 TCP download avg               :         1.69          N/A Mbits/s         353
 TCP download sum               :         6.77          N/A Mbits/s         353
 TCP download::1                :         1.92         1.95 Mbits/s         353
 TCP download::2                :         1.79         1.84 Mbits/s         353
 TCP download::3                :         1.46         1.45 Mbits/s         353
 TCP download::4                :         1.60         1.59 Mbits/s         353
 ...
```

The script also saves four result files in the local `Test_Results` directory, tagged with the date/time, coffee shop name, and the flent test name.

*Note:* For quick analysis, check the "(extra)" Ping line. 
It shows measurements from a nearby anycast address (1.1.1.1). 
The Ping times shown on the first line are the latency to the remote netserver:
it might be considerably farther away, giving a larger result (as seen in these numbers).

## Display the results as plots

To view the results in the Flent GUI, enter:

`flent --gui <result-file-name>`


You'll see an image like this:

![Sample run of Flent GUI](https://i.imgur.com/kUI553T.jpg)

The plot shows five seconds of idle time (with pings below 95 msec - brown plot), 
followed by 60 seconds of ~7mbps transfer (green plot) with the ping times bouncing up to 20 msec higher. 
Finally, the plot shows another five seconds of idle, for a total test time of 70 seconds.

For further explanation of the plots, see the 
[RRUL Chart Explanation](https://www.bufferbloat.net/projects/bloat/wiki/RRUL_Chart_Explanation/) 
on [bufferbloat.net.](http://bufferbloat.net)

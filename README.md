# Coffee Shop Bloat Test

This script is an elaboration on [Dave Täht's original script](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html) on the Bloat mailing list.
[Dave says:](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009332.html)

> The coffee shop tests were fun, but I(we) needed more rigor when doing them. What I'd typically do is go in,
get on the wifi, start 6 minutes worth of tests, get in line, get
coffee... I would feel a twinge of guilt when I'd
start seeing heads pop up from their laptops while running the rrul
test, but in two cases I managed to talk to
the owner, help 'em get QoS configured right on their router, show'd
'em the difference, and got a free meal out of it...

Now you too can "instrument" your local coffee shop, with the goal of making the world's internet access a little bit better. 

To run the script, use the command below. Place the coffee shop name in quotes:

`sh coffee-shop-bloat-test.sh "Coffee Shop Name"`

This will run several Flent tests in succession: tcp\_ndown, tcp\_nup, rrul, rrul\_be.
Each of the tests runs for 70 seconds, so the full suite of tests will take five or six minutes.
Each test outputs its results to the terminal in this form:

```
bash-3.2$ sh coffee-shop-bloat-test.sh "Coffee Shop Name"
Testing from Coffee_Shop_Name to flent-fremont.bufferbloat.net
Measuring baseline latency to 1.1.1.1...
1.1.1.1 : xmt/rcv/%loss = 5/5/0%, min/avg/max = 15.8/16.1/16.3

Started Flent 1.3.0 using Python 2.7.15.
Starting tcp_ndown test. Expected run time: 70 seconds.
Data file written to ./tcp_ndown-2019-09-11T135217.023272.Coffee_Shop_Name.flent.gz.

Summary of tcp_ndown test run from 2019-09-11 17:52:17.023272
  Title: 'Coffee_Shop_Name'

                                           avg       median          # data pts
 Ping (ms) ICMP                 :       100.19        99.35 ms              350
 Ping (ms) ICMP 1.1.1.1 (extra) :        23.31        21.75 ms              350
 TCP download avg               :         1.65         1.70 Mbits/s         301
 TCP download sum               :         6.58         6.79 Mbits/s         301
 TCP download::1                :         1.58         1.62 Mbits/s         292
 TCP download::2                :         1.62         1.68 Mbits/s         292
 TCP download::3                :         1.70         1.75 Mbits/s         286
 TCP download::4                :         1.70         1.75 Mbits/s         286
 ...
```

The script also saves four result files in the local directory, tagged with the date/time, coffee shop name, and the flent test name.

To view the results in the Flent GUI, enter:

`flent --gui <result-file-name>`


You'll see an image like this:

![Sample run of Flent GUI](https://i.imgur.com/kUI553T.jpg)

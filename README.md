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

The script first measures baseline latency to a nearby IPv4 and IPv6 host. 

It then runs several Flent tests in succession: tcp\_ndown, tcp\_nup, rrul, rrul\_be.
Each of the tests runs for 70 seconds, so the full suite of tests will take five or six minutes.
Each test outputs its results to the terminal in this form:

```
bash-3.2$ sh coffee-shop-bloat-test.sh "Coffee Shop Name"
Testing from Richs-MBP-10337.lan to flent-fremont.bufferbloat.net
Measuring baseline latency to 1.1.1.1 and 2606:4700:4700::1111...
1.1.1.1 : xmt/rcv/%loss = 5/5/0%, min/avg/max = 15.1/15.8/16.1
2606:4700:4700::1111 : xmt/rcv/%loss = 5/5/0%, min/avg/max = 21.0/21.5/21.9

Started Flent 1.9.9-git-436d5b6 using Python 3.7.3.
Starting tcp_ndown test. Expected run time: 70 seconds.
Data file written to ./tcp_ndown-2019-09-15T123123.380936.Richs-MBP-10337_lan.flent.gz

Summary of tcp_ndown test run from 2019-09-15 16:31:23.380936
  Title: 'Richs-MBP-10337.lan'

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

The script also saves four result files in the local directory, tagged with the date/time, coffee shop name, and the flent test name.

To view the results in the Flent GUI, enter:

`flent --gui <result-file-name>`


You'll see an image like this:

![Sample run of Flent GUI](https://i.imgur.com/kUI553T.jpg)

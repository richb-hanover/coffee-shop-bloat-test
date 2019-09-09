# Coffee Shop Bloat Test

This script is an elaboration on Dave Täht's original on the Bloat mailing list in
[https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html)

To run the script, use the command below. Place the coffee shop name in quotes:

`coffee-shop-bloat-test.sh "Coffee Shop Name"`

This will run Flent several times with various options, and output the results to the terminal in this form:

```
...
Started Flent 1.3.0 using Python 2.7.15.
Starting tcp_ndown test. Expected run time: 70 seconds.
Data file written to ./tcp_ndown-2019-09-06T074544.888052.Rich_Test.flent.gz.

Summary of tcp_ndown test run from 2019-09-06 11:45:44.888052
  Title: 'Rich_Test'

                             avg       median          # data pts
 Ping (ms) ICMP   :       104.03       105.00 ms              350
 TCP download avg :         1.71         1.74 Mbits/s         300
 TCP download sum :         6.83         6.95 Mbits/s         300
 TCP download::1  :         1.55         1.56 Mbits/s         281
 TCP download::2  :         1.85         1.83 Mbits/s         282
 TCP download::3  :         1.53         1.54 Mbits/s         282
 TCP download::4  :         1.91         1.90 Mbits/s         287
bash-3.2$
```

The script also saves result files in the local directory, tagged with the date/time, coffee shop name, and the flent test name.

To view the results in the Flent GUI, enter:

`flent --gui <result-file-name>`


You'll see an image like this:

![sample run of Flent GUI](https://user-images.githubusercontent.com/1094930/64439228-7e5a5880-d097-11e9-9068-1f80fd634be7.png)


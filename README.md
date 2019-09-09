# Coffee Shop Bloat Test

This script is an elaboration on Dave Täht's original on the Bloat mailing list in
[https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html](https://lists.bufferbloat.net/pipermail/bloat/2019-September/009336.html)

To run the script, use the command below. Place the coffee shop name in quotes:

`sh coffee-shop-bloat-test.sh "Coffee Shop Name"`

This will run Flent several times with various options.
Each of the tests runs for 70 seconds, so the full suite of tests will take five or six minutes.
Each test outputs its results to the terminal in this form:

```
...
Started Flent 1.3.0 using Python 2.7.15.
Starting tcp_ndown test. Expected run time: 70 seconds.
Data file written to ./tcp_ndown-2019-09-09T095251.724949.Coffee_Shop_Name.flent.gz.

Summary of tcp_ndown test run from 2019-09-09 13:52:51.724949
  Title: 'Coffee_Shop_Name'

                             avg       median          # data pts
 Ping (ms) ICMP   :       104.34       105.00 ms              350
 TCP download avg :         1.71         1.74 Mbits/s         300
 TCP download sum :         6.84         6.96 Mbits/s         300
 TCP download::1  :         1.66         1.64 Mbits/s         283
 TCP download::2  :         1.39         1.35 Mbits/s         279
 TCP download::3  :         2.05         2.11 Mbits/s         288
 TCP download::4  :         1.75         1.73 Mbits/s         287
...
```

The script also saves result files in the local directory, tagged with the date/time, coffee shop name, and the flent test name.

To view the results in the Flent GUI, enter:

`flent --gui <result-file-name>`


You'll see an image like this:

![Sample run of Flent GUI](https://i.imgur.com/kUI553T.jpg)

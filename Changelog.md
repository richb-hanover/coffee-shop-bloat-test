# Changelog

* Sep 2019 - Originally published
* Feb 2020 - Updated script to use Cloudflare Anycast DNS resolver name ("one.one.one.one") instead of simply using the IPv4 address for ping\_hosts. (Change necessitated because Flent selects v4 or v6 when looking up its -H host, then uses the same v4/v6 version for its ping\_hosts)
* Oct 2020 
 	- Tweak script to output to Test_Results/ (and .gitignore it)
	- restore use of "one.one.one.one" for v4/v6

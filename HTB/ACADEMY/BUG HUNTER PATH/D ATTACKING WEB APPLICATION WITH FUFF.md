# USAGE

- Fuzzing for directories
- Fuzzing for files and extensions
- Identifying hidden vhosts
- Fuzzing for PHP parameters
- Fuzzing for parameter values

### Directory fuzzing

```shell
ffuf -w /usr/share/wordlists/dirb/common.txt:FUZZ -u http://94.237.52.198:53050/FUZZ
```

### Extension Fuzzing

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://SERVER_IP:PORT/blog/indexFUZZ
```

### Page Fuzzing

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/blog/FUZZ.php
```

#### Recursive Fuzzing
```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/FUZZ -recursion -recursion-depth 1 -e .php -v
```
---
#### Subdomain fuzzing

```shell
ffuf -w /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://FUZZ.academy.htb/
```
- in this scan consider we mapped ip academy.htb in /etc/hosts
- in subdomain fuzzing, first subdomains are checked in host file and then public dns(8.8.8.8)
#### Subdomains vs VHOST

- VHost is basically a 'sub-domain' served on the same server and has the same IP
- subdomains are mapped into differect ips and different servers
- publicly accessable(available in DNS server) subdomains can only be fuzzed 
#### VHOST Fuzzing
```shell
ffuf -w /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://academy.htb:PORT/ -H 'Host: FUZZ.academy.htb'
```

#### Filtering
- garbage vhosts,subdomains can be listed more to filter it . use -fs 
```shell
ffuf -w /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://academy.htb:PORT/ -H 'Host: FUZZ.academy.htb' -fs 900
```

---

#### Parameter Fuzzing
##### GET parameter Fuzzing
- parameter passed with url
```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt -u http://admin.academy.htb:53050/admin/admin.php?FUZZ=key 
```
- after running this many parameters with respose size 798 is displayed ..so to filer out that
```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt -u http://admin.academy.htb:53050/admin/admin.php?FUZZ=key -fs 798
```
##### POST Parameter Fuzzing
- parameter passed in body of the request
- add -X POST (for post request) ,-d (for data parameter)
> Tip: In PHP, "POST" data "content-type" can only accept "application/x-www-form-urlencoded". So, we can set that in "ffuf" with "-H 'Content-Type: application/x-www-form-urlencoded'".

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u http://admin.academy.htb:PORT/admin/admin.php -X POST -d 'FUZZ=key' -H 'Content-Type: application/x-www-form-urlencoded' -fs xxx

```
- Found parameter... what is the value
#### Value Fuzzing
- here id parameter .. so create a wordlist with 1-1000 numbers using bash
```bash
for i in $(seq 1 1000); do echo $i >> ids.txt; done
```
- lets fuzzzzzzz
```shell
ffuf -w ids.txt:FUZZ -u http://admin.academy.htb:PORT/admin/admin.php -X POST -d 'id=FUZZ' -H 'Content-Type: application/x-www-form-urlencoded' -fs xxx
```


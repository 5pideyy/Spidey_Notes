
# NMAP

```
 nmap 10.10.11.47 -p- --min-rate 10000 -T5 --source-port 53               
```

```
nmap 10.10.11.47 -p22,80 -sCV
```


# WEB FUZZ


### Directory fuzzing

```shell
ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -u http://94.237.52.198:53050/FUZZ
```

### Extension Fuzzing

```shell
ffuf -w /usr/share/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://SERVER_IP:PORT/blog/indexFUZZ
```

### Page Fuzzing

```shell
ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/blog/FUZZ.php
```

#### Subdomain fuzzing

```shell
ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://FUZZ.linkvortex.htb/
```

#### VHOST Fuzzing
```shell
ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://linkvortex.htb/ -H 'Host: FUZZ.linkvortex.htb'
```


#### Recursive Fuzzing
```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/FUZZ -recursion -recursion-depth 1 -e .php -v
```


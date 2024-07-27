we setup webproxy using foxyproxy in web browser..... then how do we set up proxy when we use tool like curl...... htere comes PROXYCHAINS

- proxies is enabling the interception of web requests made by command-line tools and thick client applications
- enabling the interception of web requests made by command-line tools 
- Routes all traffic coming from any command-line tool to any proxy

### Setting up ProxyChains

```bash
nano /etc/proxychains.conf
```
add
```shell-session
#socks4         127.0.0.1 9050
http 127.0.0.1 8080
```

to reduce noise uncomment `quiet_mode`


Done....


### Using Proxy Chains


```shell-session
pradyun2005@htb[/htb]$ proxychains curl http://SERVER_IP:PORT
```




```
ProxyChains-3.1 (http://proxychains.sf.net)
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Ping IP</title>
    <link rel="stylesheet" href="./style.css">
</head>
...SNIP...
</html>    
```


now go to burp proxy yeahhhh intercepted...


### Proxy through Nmap(experimental)

```shell-session
pradyun2005@htb[/htb]$ nmap --proxies http://127.0.0.1:8080 SERVER_IP -pPORT -Pn -sC
```


```shell-session
Starting Nmap 7.91 ( https://nmap.org )
Nmap scan report for SERVER_IP
Host is up (0.11s latency).

PORT      STATE SERVICE
PORT/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 0.49 seconds
```


### Setting up proxy using metasploit

```shell
use auxiliary/scanner/http/http_put
```

```shell
set PROXIES HTTP:127.0.0.1:8080

```
10.10.14.251=> website ip
```shell
set rhost 94.237.50.13
```
80 => port
```shell
set rport 34947
```

```shell
run
```


# Burp Shortcuts

| **Shortcut**     | **Description**  |
| ---------------- | ---------------- |
| [`CTRL+R`]       | Send to repeater |
| [`CTRL+SHIFT+R`] | Go to repeater   |
| [`CTRL+I`]       | Send to intruder |
| [`CTRL+SHIFT+I`] | Go to intruder   |
| [`CTRL+U`]       | URL encode       |
| [`CTRL+SHIFT+U`] | URL decode       |
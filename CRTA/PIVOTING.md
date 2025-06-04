

![[Pasted image 20250523103511.png]]


- opens up a listener port in our machine , that forward tcp packets to victim compromised machine

```
ssh -D 8090 user@target1
```

- this command logged in to user at target1 , opens up 8090 port in attacker machine , that forwards tcp packets to victim machine


```
/etc/proxychains.conf
```
- add socks5 at bottom of the file 
```
[ProxyList]
socks5 127.0.0.1 8090
```


- use nmap with proxychains

```
proxychains nmap -sT -Pn -p 80 192.168.10.5
```





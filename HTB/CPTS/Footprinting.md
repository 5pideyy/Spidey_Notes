
#### Online presence

![[Pasted image 20241226184300.png]]
- ==crtsh==

```shell-session
curl -s https://crt.sh/\?q\=examlple.com\&output\=json | jq .
```

- unique subdoamins

```shell-session
curl -s https://crt.sh/\?q\=inlanefreight.com\&output\=json | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u
```

- check for directly accessible from internet domains ( have public ips )

```shell-session
for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f1,4;done
```

- now we get list of ips accessible , next using shodan we can find the open ports ==shodan==

```shell-session
for i in $(cat subdomainlist);do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt;done

	for i in $(cat ip-addresses.txt);do shodan host $i;done
```

#### Cloud resource

- AWS google dork
```
intext:<company name> inurl:amazonaws.com
```

- Azure
```
intext: <company name> inurl:blob.core.windows.net
```

[domain.glass](https://domain.glass/)


## DNS

- the records shown when dig , nslookup are files that are shown to us from the server
- ==main objective subdomain enumerate==

### SERVER CONFIG
- `named.conf.local`
- `named.conf.options`
- `named.conf.log`
##### Local DNS Configuration
```shell-session
root@bind9:~# cat /etc/bind/named.conf.local

//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
zone "domain.com" {
    type master;
    file "/etc/bind/db.kct.ac.in";
    allow-update { key rndc-key; };
};
```

#### Zone Files
```shell-session
root@bind9:~# cat /etc/bind/db.domain.com

;
; BIND reverse data file for local loopback interface
;
$ORIGIN domain.com
$TTL 86400
@     IN     SOA    dns1.domain.com.     hostmaster.domain.com. (
                    2001062501 ; serial
                    21600      ; refresh after 6 hours
                    3600       ; retry after 1 hour
                    604800     ; expire after 1 week
                    86400 )    ; minimum TTL of 1 day

      IN     NS     ns1.domain.com.
      IN     NS     ns2.domain.com.

      IN     MX     10     mx.kct.ac.in.
      IN     MX     20     mx2.kct.ac.in.

             IN     A       10.129.14.5

server1      IN     A       10.129.14.5
server2      IN     A       10.129.14.7
ns1          IN     A       10.129.14.2
ns2          IN     A       10.129.14.3

ftp          IN     CNAME   server1
mx           IN     CNAME   server1
mx2          IN     CNAME   server2
www          IN     CNAME   server2
```



- SOA responsible for operation of domain

```shell-session
dig soa www.inlanefreight.com
```

 using this get the nameserver ip 

  - now query any record 

- we can query other nameservers with one you found using soa too using ns record

```
dig ns kct.ac.in @172.16.15.200
```

- find version of dns server

```shell-session
dig CH TXT version.bind 172.16.15.200
```

- transfer zones (files in nameserver) to secondary server

```shell-session
dig axfr kct.ac.in @172.16.15.200
```

the nameserver should allow zone transfer  `allow-transfer`  should be enabled , else axfr fails

- now allow-transfer is disabled . but TCP 53 is open for 172.16.15.200 . we can bruteforce the subdomains by querying A record 

```shell-session
for sub in $(cat /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt);do dig $sub.inlanefreight.htb @10.129.14.128 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
```


### TOOL

```shell
dnsenum --dnsserver 10.129.14.128 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb
```



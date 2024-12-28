
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
    file "/etc/bind/db.domain.com";
    allow-update { key rndc-key; };
};
```




- SOA responsible for operation of domain

```shell-session
dig soa www.inlanefreight.com
```

 using this get the nameserver ip 

  - 

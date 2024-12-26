
#### Online presence

![[Pasted image 20241226184300.png]]
- crtsh

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

- now we get list of ips accessible , next using shodan we can find the open ports
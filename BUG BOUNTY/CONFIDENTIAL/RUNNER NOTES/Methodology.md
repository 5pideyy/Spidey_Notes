### Subdomain Enumeration

1. Assetfinder

```
assetfinder target.com -subs-only | tee -a asset.txt
```

2. CrtSh

```
crtsh -d target.com | tee -a crtsh.txt
```

3. Findomain

```
findomain -t target.com -o 
```

4. Subfinder

```
subfinder -d target.com
```

5. Github-Subdomains

```
github-subdomains -d target.com
```
### Sort out the unique ones

```
cat filename.txt | anew filename2.txt
```

### Check The Alive Subdomains

```
cat subs.txt | httprobe | tee -a alivesubs.txt
```

### Automated Scanners

-  Nuclei

```
cat subs.txt | nuclei
```

-  Nmap

```
nmap -sVC -T4 target.com
```

-  Nikto

```
nikto -host target.com
```

### Finding Known Tech

builtwith, whatruns,wappalyzer

### Low Hanging Fruits

- XSS

```
paramspider -d target.com | qsreplace  '"/><script>confirm(1)</script>' > xss.txt | while read host do ; do curl --silent --path-as-is --insecure "$host" | grep -qs "<script>confirm(1)" && echo "$host \033[0;31mVulnerable\n" || echo "$host \033[0;32mNot Vulnerable\n";done
```

### URLs

```
cat alivesubs.txt | waybackurls | tee -a urls.txt
```


```
cat urls.txt | httprobe | tee -a aliveurls.txt
```


### GOOGLE DORKING

[Dorks](https://nitinyadav00.github.io/Bug-Bounty-Search-Engine/?source=post_page-----2b69c3b168fe--------------------------------)



N = int(input())
T = int(input())
numbers = []
for _ in range(N):
    numbers.append(int(input()))
for _ in range(T):
    K = int(input())
    print(numbers[K])


#### Subdomain Enumeration

1. **Assetfinder**

    
    `assetfinder target.com -subs-only | tee -a asset.txt`
    
2. **CrtSh**

    
    `crtsh -d target.com | tee -a crtsh.txt`
    
3. **Findomain**
    

    
    `findomain -t target.com -o` 
    
4. **Subfinder**
    

    
    `subfinder -d target.com`
    
5. **Github-Subdomains**

    
    `github-subdomains -d target.com`
6. Amass

	```shell
amass enum -d example.com
```

7. OSINT

https://inteltechniques.com/tools/index.html

8. gau (get all urls)

```
gau example.com
```

9. crawley
```
# print all links from first page:
crawley http://some-test.site

# print all js files and api endpoints:
crawley -depth -1 -tag script -js http://some-test.site

# print all endpoints from js:
crawley -js http://some-test.site/app.js

# download all png images from site:
crawley -depth -1 -tag img http://some-test.site | grep '\.png$' | wget -i -

# fast directory traversal:
crawley -headless -delay 0 -depth -1 -dirs only http://some-test.site
```
#### Sort out the unique ones


`cat filename.txt | anew filename2.txt`

#### Check The Alive Subdomains



`cat subs.txt | httprobe | tee -a alivesubs.txt`

#### Automated Scanners

- **Nuclei**
    
 
    
    `cat subs.txt | nuclei`
    
- **Nmap**
    

    
    `nmap -sVC -T4 target.com`
    
- **Nikto**
    

    
    `nikto -host target.com`
    

#### Finding Known Tech

- builtwith
- whatruns
- wappalyzer

#### Low Hanging Fruits

- **XSS**
    

    
    `paramspider -d target.com | qsreplace '"/><script>confirm(1)</script>' > xss.txt | while read host; do curl --silent --path-as-is --insecure "$host" | grep -qs "<script>confirm(1)" && echo "$host \033[0;31mVulnerable\n" || echo "$host \033[0;32mNot Vulnerable\n"; done`
    

#### URLs



`cat alivesubs.txt | waybackurls | tee -a urls.txt`


`cat urls.txt | httprobe | tee -a aliveurls.txt`

### Google Dorking

[Dorks](https://nitinyadav00.github.io/Bug-Bounty-Search-Engine/?source=post_page-----2b69c3b168fe--------------------------------)

### Useful Wordlists

|**Command**|**Description**|
|---|---|
|`/opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt`|Directory/Page Wordlist|
|`/opt/useful/SecLists/Discovery/Web-Content/web-extensions.txt`|Extensions Wordlist|
|`/opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt`|Domain Wordlist|
|`/opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt`|Parameters Wordlist|

### Burp Suite Shortcuts

|**Shortcut**|**Description**|
|---|---|
|`CTRL+R`|Send to repeater|
|`CTRL+SHIFT+R`|Go to repeater|
|`CTRL+I`|Send to intruder|
|`CTRL+SHIFT+B`|Go to intruder|
|`CTRL+U`|URL encode|
|`CTRL+SHIFT+U`|URL decode|


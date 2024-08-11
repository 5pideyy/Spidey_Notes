


### Phase 1: Information Gathering
- [ ] `whois target.com`
- [ ] `nslookup target.com`
- [ ] `dig target.com`
- [ ] `curl http://ipinfo.io/<ip>`
- [ ] `host -t ns target.com`
- [ ] `host -t mx target.com`
- [ ] `whatweb -i live_hosts.txt`
- [ ] `dnsrecon -d target.com`
- [ ] `censys search target.com`
- [ ] `github-search target.com`
- [ ] `gitrob -repo target.com`
- [ ] `github-dorker -d target.com`
- [ ] `gf redirect > gf_redirects.txt`

### Phase 2: Subdomain Enumeration

- [ ] `sublist3r -d target.com`
- [ ] `amass enum -d target.com | tee subs.txt`
- [ ] `assetfinder --subs-only target.com | tee -a subs.txt`
- [ ] `findomain -t target.com | tee -a subs.txt`
- [ ] `subfinder -d target.com -o subfinder_results.txt`
- [ ] `cat subfinder_results.txt | tee -a subs.txt`
- [ ] `subfinder -dL domains.txt -o subs1.txt`
- [ ] `cat subs1.txt | anew subs.txt`



- [ ] Security Tails Subdomains 
```
curl -s --request GET --url https://api.securitytrails.com/v1/domain/target.com/subdomains?apikey=N-hfpe2Zx8hXPFz37l4NISQi6hl38-gh | jq '.subdomains[]' | sed 's/\"//g' >test.txt 2>/dev/null && sed "s/$/.target.com/" test.txt | sed 's/ //g' && rm test.txt
```


- [ ] RapidDns Subdomain function

```Usage:rapiddns target
rapiddns(){ curl -s "https://rapiddns.io/subdomain/\?full=1" \ | grep -oP '_blank">\K[^<]*' \ | grep -v http \ | sort -u }
```


- [ ] `massdns -r resolvers.txt -t A -o S -w results.txt subs.txt`
- [ ] `httprobe < results.txt > live_subdomains.txt`
- [ ] `httpx -l live_subdomains.txt -o live_hosts.txt`

- [ ] `cat live_hosts.txt | waybackurls | tee -a urls.txt`
- [ ] `cat urls.txt | httprobe | tee -a aliveurls.txt`

- [ ] `gau target.com | tee gau_urls.txt`
- Finding Js Files
	- [ ] `cat domains | httpx -silent | subjs | anew`
	- [ ] `echo target.com | gau | grep '\.js$' | httpx -status-code -mc 200 -content-type | grep 'application/javascript'`
	- [ ] Find Js `katana -u https://target.com -jc -d 2 | grep ".js$" | uniq | sort > js.txt`
	- [ ] Extracting Secret keys from js `cat js.txt | while read url; do python3 SecretFinder.py -i $url -o cli >> secrets.txt; done

	Found KEYS => dont know What to do then https://github.com/streaak/keyhacks


	- [ ] finding urls from JS
	```find_urls_from_js
	python ~/Downloads/Tools/JSParser/handler.py
	
	and then visit http://localhost:8008/
	```

	- [ ] Finding Endpoints from js 	`python ~/Downloads/Tools/LinkFinder/linkfinder.py -i https://example.com/1.js -o results.html`
	- [ ] Finding Api End points  
```
		cat file.js | grep -aoP "(?<=(\"|\'|\`))\/[a-zA-Z0-9_?&=\/\-\#\.]*(?=(\"|\'|\`))" | sort -u
```

- [ ] `hakrawler -url target.com -depth 2 -plain | tee hakrawler_output.txt`

```
cat SecLists/Discovery/DNS/dns-Jhaddix.txt | subgen -d DOMAIN.TLD | zdns A --name-servers 1.1.1.1 --threads 500 | jq -r "select(.data.answers[0].name) | .name"
```


### Phase 3: Vulnerability Scanning

  - [ ] `nmap -iL live_hosts.txt -oA nmap_scan`
  - [ ] `nuclei -l live_hosts.txt -t templates/`


  - [ ] `metabigor net --org target.com`
  - [ ] `metagoofil -d target.com -t doc,pdf,xls,docx,xlsx,ppt,pptx -l 100`
  - [ ] `theHarvester -d target.com -l 500 -b all`
  - [ ] `dnsenum target.com`
  - [ ] `spiderfoot -s target.com -o spiderfoot_report.html`


  - [ ] `subjack -w subdomains.txt -t 20 -o subjack_results.txt`


  - [ ] `waymore -u target.com -o waymore_results.txt`
  - [ ] `unfurl -u target.com -o unfurl_results.txt`


  - [ ] `cat subs.txt | httprobe | tee alive.txt`
  - [ ] `cat alive.txt | gau --blacklist png,jpg,jpeg,svg,img,woff1,woff2,woff3,eot,css | tee gaures.txt`
  - [ ] `cat alive.txt | hakrawler | grep -i “.js$” | tee js.txt`
  - [ ] `dalfox file live_hosts.txt`


  - [ ] `ffuf -u FUZZ.site.com -w subs.txt | tee brute.txt`


### Phase 4: Directory and File Searching
- [ ] `feroxbuster -u https://target.com -e *`
- [ ] `dirsearch -u target.com -e *`
- [ ] `dirb https://target.com/ do dirb_output.txt`
- [ ] `wpscan --url target.com`

### Phase 5: Parameter Discovery
- [ ] `parameth - This tool can be used to brute discover GET and POST parameters`
- [ ] `param-miner - This extension identifies hidden, unlinked parameters. It's particularly useful for finding web cache poisoning vulnerabilities.`
- [ ] `ParamPamPam - This tool for brute discover GET and POST parameters.`
- [ ] `arjun -u https://target.com -oT arjun_output.txt`
- [ ] `ParamSpider - Mining parameters from dark corners of Web Archives.`
- [ ] `x8 - Hidden parameters discovery suite written in Rust.`

- [ ] Find Hidden GET parameters
```
assetfinder example.com | gau | egrep -v '(.css|.png|.jpeg|.jpg|.svg|.gif|.wolf)' | while read url; do vars=$(curl -s $url | grep -Eo "var [a-zA-Z0-9]+" | sed -e 's,'var','"$url"?',g' -e 's/ //g' | grep -v '.js' | sed 's/.*/&=xss/g'); echo -e "\e[1;33m$url\n\e[1;32m$vars"; done
```

#### GOOGLE DORKING

https://taksec.github.io/google-dorks-bug-bounty/
https://dorks.faisalahmed.me/#
https://nitinyadav00.github.io/Bug-Bounty-Search-Engine/

https://intelx.io/



### Phase 6: Post Enumeration
- [ ] `gospider -s https://target.com -o gospider_output/`
- [ ] `recon-ng -w workspace -i target.com`
- [ ] `xray webscan --basic-crawler http://target.com`
- [ ] `shuffledns -d target.com -list resolvers.txt -o shuffledns_results.txt`
- [ ] `dnsgen -f subdomains.txt | massdns -r resolvers.txt -t A -o S -w dnsgen_results.txt`
- [ ] `mapcidr -silent -cidr target.com -o mapcidr_results.txt`
- [ ] `tko-subs -domains=target.com -data=providers-data.csv`
- [ ] `frederick2 -d target.com`
- [ ] `paramspider --domain target.com --output paramspider_output.txt`
- [ ] `cloud_enum -k target.com -l cloud_enum_output.txt`
- [ ] `gobuster dns -d target.com -t 50 -w wordlist.txt`
- [ ] `subzer0 -d target.com`
- [ ] `dnstwalk target.com`
- [ ] `masscan -iL live_hosts.txt -p0-65535 -oX masscan_results.xml`
- [ ] kxss
- [ ] `xsstrike -u https://target.com/`
- [ ] `byp4xx https://target.com/FUZZ`
- [ ] `dnstwist -l subdomains.txt -resp-only -o dnsx_results.txt`
- [ ] `waybackpack target.com -d output/`
- [ ] `puredns resolve subdomains.txt -r resolvers.txt -w puredns_results.txt`
- [ ] `ctfr --d target.com -o ctfr_results.txt`
- [ ] `dnsvalidator -f 100+ -r resolvers.txt -o validated_resolvers.txt`
- [ ] `httpx -l live_subdomains.txt -mc 200 -title -tech-detect -o httpx_results.txt`
- [ ] `cloud_enum -k target.com -l cloud_enum_results.txt`



## Bypass Rate limits by adding X- HTTP headers
```
- X-Originating-IP: IP
- X-Forwarded-For: IP
- X-Remote-IP: IP
- X-Remote-Addr: IP
- X-Client-IP: IP
- X-Host: IP
- X-Forwared-Host: IP
```

```
- 192.168.0.0/16
- 172.16.0.0/12
- 127.0.0.0/8
- 10.0.0.0/8
```


Burp suite  proxy filter setting

```
.*\.google\.com
.*\.gstatic\.com
.*\.googleapis\.com
.*\.pki\.goog
.*\.mozilla\..*
```






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


#### REPORTS


[report dumps](https://pentester.land/writeups/?source=post_page-----849db2828c8--------------------------------)

https://github.com/reddelexc/hackerone-reports/blob/master/tops_by_bug_type/TOPIDOR.md




### RESOURCE

https://gowsundar.gitbook.io/book-of-bugbounty-tips
https://pentestbook.six2dez.com/
https://gowthams.gitbook.io/bughunter-handbook


==https://www.infosecmatter.com/bug-bounty-tips/ ==

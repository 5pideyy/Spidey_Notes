

---

## Phase 1: Information Gathering

### Domain Information
- [ ] `whois target.com` - Retrieves domain registration information.
- [ ] `nslookup target.com` - Performs a DNS query to find the IP address of the domain.
- [ ] `dig target.com` - Performs a detailed DNS lookup.
- [ ] `curl http://ipinfo.io/<ip>` - Retrieves information about the IP address.
- [ ] `host -t ns target.com` - Lists the authoritative nameservers.
- [ ] `host -t mx target.com` - Lists the mail servers for the domain.

### Web Technology Fingerprinting
- [ ] `whatweb -i live_hosts.txt` - Identifies technologies used by the web application.

### DNS Enumeration
- [ ] `dnsrecon -d target.com` - Enumerates DNS records.
- [ ] `censys search target.com` - Searches for SSL certificates and associated assets.
- [ ] `github-search target.com` - Searches GitHub for sensitive data related to the target.
- [ ] `gitrob -repo target.com` - Scans for sensitive information in GitHub repositories.
- [ ] `github-dorker -d target.com` - Automates GitHub dorking to find exposed secrets.
- [ ] `gf redirect > gf_redirects.txt` - Looks for potential redirect vulnerabilities.

---

## Phase 2: Subdomain Enumeration

### Subdomain Discovery Tools
- [ ] `sublist3r -d gleague.nba.com -o subs.txt` - Enumerates subdomains using multiple sources.
- [ ] `amass enum -d gleague.nba.com | tee -a subs.txt` - Comprehensive subdomain enumeration.
- [ ] `assetfinder --subs-only gleague.nba.com | tee -a subs.txt` - Finds subdomains via various APIs.
- [ ] `findomain -t gleague.nba.com | tee -a subs.txt` - Another subdomain enumeration tool.
- [ ] `subfinder -d gleague.nba.com -o subfinder_results.txt -silent` - Finds subdomains using multiple sources.
- **SecurityTrails Subdomains**:
    ```bash
    curl -s --request GET --url https://api.securitytrails.com/v1/domain/target.com/subdomains?apikey=API_KEY | jq '.subdomains[]' | sed 's/\"//g' >test.txt 2>/dev/null && sed "s/$/.target.com/" test.txt | sed 's/ //g' && rm test.txt
    ```
- **RapidDNS Subdomain Discovery**:
    ```bash
    rapiddns(){ curl -s "https://rapiddns.io/subdomain/\?full=1" | grep -oP '_blank">\K[^<]*' | grep -v http | sort -u }
    ```

### Subdomain Resolution and Probing
- [ ] `massdns -r resolvers.txt -t A -o S -w results.txt subs.txt` - Resolves subdomains to IPs.
- [ ] `httprobe < results.txt > live_subdomains.txt` - Finds live subdomains.
- [ ] `httpx -l live_subdomains.txt -o live_hosts.txt` - Probes HTTP services on subdomains.

### URL and JavaScript File Discovery




```
target="testphp.vulnweb.com"; (gau $target > gau_output.txt | lolcat -a -d 5 -s 20 && echo "Cooldown for 3 seconds after gau..." | lolcat -a -d 5 -s 20 && sleep 3 & waybackurls $target > waybackurls_output.txt | lolcat -a -d 5 -s 20 && echo "Cooldown for 3 seconds after waybackurls..." | lolcat -a -d 5 -s 20 && sleep 3 & katana -u $target --depth 3 > katana_output.txt | lolcat -a -d 5 -s 20 && echo "Cooldown for 3 seconds after katana..." | lolcat -a -d 5 -s 20 && sleep 3 & wait; cat gau_output.txt waybackurls_output.txt katana_output.txt | sort | uniq | tee results.txt | lolcat -a -d 5 -s 20)

```


- [ ] `cat live_hosts.txt | waybackurls | tee -a urls.txt` - Extracts URLs from Wayback Machine.
- [ ] crawley
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


- [ ] `cat urls.txt | httprobe | tee -a aliveurls.txt` - Probes live URLs.
- [ ] `gau target.com | tee gau_urls.txt` - Fetches URLs from various sources.
- [ ] `cat domains | httpx -silent | subjs | anew` - Extracts JavaScript files from live domains.
- [ ] `echo target.com | gau | grep '\.js$' | httpx -status-code -mc 200 -content-type | grep 'application/javascript'` - Filters live JavaScript files.
- [ ] `katana -u https://target.com -jc -d 2 | grep ".js$" | uniq | sort > js.txt` - Finds JavaScript files with deep crawling.

### Secret and API Endpoint Discovery
- [ ] `cat js.txt | while read url; do python3 SecretFinder.py -i $url -o cli >> secrets.txt; done` - Extracts secrets from JavaScript files.
- [ ] **Find URLs in JavaScript Files**:
    ```bash
    python ~/Downloads/Tools/JSParser/handler.py
    # Visit http://localhost:8008/ to interactively find URLs.
    ```
- [ ] `python ~/Downloads/Tools/LinkFinder/linkfinder.py -i https://example.com/1.js -o results.html` - Finds API endpoints in JavaScript files.
- [ ] `cat file.js | grep -aoP "(?<=(\"|\'|\`))\/[a-zA-Z0-9_?&=\/\-\#\.]*(?=(\"|\'|\`))" | sort -u` - Extracts API endpoints directly from JS files.
- [ ] `hakrawler -url target.com -depth 2 -plain | tee hakrawler_output.txt` - Crawls URLs to discover hidden content.

---

## Phase 3: Vulnerability Scanning

### Network and Service Scanning
- [ ] `nmap -iL live_hosts.txt -oA nmap_scan` - Scans for open ports and services.
- [ ] `masscan -iL live_hosts.txt -p0-65535 -oX masscan_results.xml` - High-speed port scan.

### Automated Vulnerability Scanning
- [ ] `nuclei -l live_hosts.txt -t templates/` - Scans for known vulnerabilities using templates.
- [ ] `metabigor net --org target.com` - Gathers network information from external sources.
- [ ] `metagoofil -d target.com -t doc,pdf,xls,docx,xlsx,ppt,pptx -l 100` - Extracts metadata from publicly available documents.
- [ ] `theHarvester -d target.com -l 500 -b all` - Harvests email addresses, subdomains, and more from public sources.
- [ ] `dnsenum target.com` - Enumerates DNS records including subdomains and zone transfers.
- [ ] `shuffledns -d target.com -list resolvers.txt -o shuffledns_results.txt` - Performs DNS enumeration with resolver validation.

### Spidering and Content Discovery
- [ ] `spiderfoot -s target.com -o spiderfoot_report.html` - Comprehensive automated OSINT tool.
- [ ] `gospider -s https://target.com -o gospider_output/` - Crawls the target to find hidden content and files.
- [ ] `waymore -u target.com -o waymore_results.txt` - Fetches and filters URLs from multiple sources.
- [ ] `unfurl -u target.com -o unfurl_results.txt` - Unfurls and analyzes URLs for further inspection.

### Subdomain Takeover
- [ ] `subjack -w subdomains.txt -t 20 -o subjack_results.txt` - Detects subdomain takeover vulnerabilities.
- [ ] `tko-subs -domains=target.com -data=providers-data.csv` - Checks for vulnerable subdomains that could be taken over.

### Vulnerability Scanning
- [ ] `dalfox file live_hosts.txt` - Scans for XSS vulnerabilities.
- [ ] `xsstrike -u https://target.com/` - Advanced XSS detection tool.

### Brute Forcing
- [ ] `ffuf -u FUZZ.site.com -w subs.txt | tee brute.txt` - Brute forces subdomains and directories.

---

## Phase 4: Directory and File Searching

### Directory Brute Forcing
- [ ] `feroxbuster -u https://target.com -e *` - Directory brute force tool with recursion.
- [ ] `dirsearch -u target.com -e *` - Brute forces directories and files on the target.
- [ ] `dirb https://target.com/ -o dirb_output.txt` - Performs a directory brute force attack.

### CMS Scanning
- [ ] `wpscan --url target.com` - Scans WordPress sites for known vulnerabilities.

---

## Phase 5: Parameter Discovery

### Parameter Brute Forcing and Mining
- [ ] `parameth` - Brute forces to discover GET and POST parameters.
- [ ] `param-miner` - Finds hidden, unlinked parameters that can be exploited.
- [ ] `ParamPamPam` - Discovers hidden parameters via brute forcing.
- [ ] `arjun -u https://target.com -oT arjun_output.txt` - Finds GET and POST parameters.
- [ ] `ParamSpider --domain target.com --output paramspider_output.txt` - Mines parameters from web archives.
- [ ] `x8` - Hidden parameter discovery suite.

### GET Parameter Discovery
```bash
assetfinder example.com | gau | egrep -v '(.css|.png|.jpeg|.jpg|.svg|.gif|.wolf)' | while read url; do vars=$(curl -s $url | grep -Eo "var [a-zA-Z0-9]+" | sed -e 's,'var','"$url"?',g' -e 's/ //g' | grep -v '.js' | sed 's/.*/&=xss/g'); echo -e "\e[1;33m$url\n\e[1;32m$vars"; done
```


### GOOGLE DORKS

| https://taksec.github.io/google-dorks-bug-bounty/                                                                 |
| ----------------------------------------------------------------------------------------------------------------- |
| https://dorks.faisalahmed.me/#                                                                                    |
| https://nitinyadav00.github.io/Bug-Bounty-Search-Engine/                                                          |
| https://intelx.io/                                                                                                |
| https://inteltechniques.com/tools/index.html                                                                      |
| [Appsecwiki](https://appsecwiki.com/?source=post_page-----7052da28445a--------------------------------#/frontend) |


## Phase 6: Post Enumeration

### Advanced and Extended Scanning

- [ ]  `recon-ng -w workspace -i target.com` - Framework for performing automated reconnaissance.
- [ ]  `xray webscan --basic-crawler http://target.com` - Automated vulnerability scanner with crawling capabilities.
- [ ]  `dnsgen -f subdomains.txt | massdns -r resolvers.txt -t A -o S -w dnsgen_results.txt` - Generates and resolves potential subdomains.
- [ ]  `mapcidr -silent -cidr target.com -o mapcidr_results.txt` - Maps out CIDR ranges for the target.
- [ ]  `frederick2 -d target.com` - DNS reconnaissance and subdomain discovery tool.
- [ ]  `puredns resolve subdomains.txt -r resolvers.txt -w puredns_results.txt` - High-performance DNS resolver.
- [ ]  `ctfr --d target.com -o ctfr_results.txt` - Leverages certificate transparency logs for subdomain discovery.
- [ ]  `httpx -l live_subdomains.txt -mc 200 -title -tech-detect -o httpx_results.txt` - HTTP probing and fingerprinting.
- [ ]  `cloud_enum -k target.com -l cloud_enum_results.txt` - Enumerates cloud assets related to the target.

---

## Additional Techniques

### Bypass Rate Limits



- X-Originating-IP: IP
- X-Forwarded-For: IP 
- X-Remote-IP: IP 
- X-Remote-Addr: IP 
- X-Client-IP: IP 
- X-Host: IP 
- X-Forwared-Host: IP`

### Useful Wordlists

| **wordlist**                                                              | **Description**         |
| ------------------------------------------------------------------------- | ----------------------- |
| `/opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt` | Directory/Page Wordlist |
| `/opt/useful/SecLists/Discovery/Web-Content/web-extensions.txt`           | Extensions Wordlist     |
| `/opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt`      | Domain Wordlist         |
| `/opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt`     | Parameters Wordlist     |

### Burp Suite Shortcuts

| **Shortcut**       | **Description**      |
|--------------------|----------------------|
| `CTRL+R`           | Send to repeater     |
| `CTRL+SHIFT+R`     | Go to repeater       |
| `CTRL+I`           | Send to intruder     |
| `CTRL+SHIFT+B`     | Go to intruder       |
| `CTRL+U`           | URL encode           |
| `CTRL+SHIFT+U`     | URL decode           |


---

## Reports and Resources

### Reports

- [ ]  [Pentester.land Writeups](https://pentester.land/writeups/?source=post_page-----849db2828c8--------------------------------) - Collection of bug bounty writeups.
- [ ]  [HackerOne Reports](https://github.com/reddelexc/hackerone-reports/blob/master/tops_by_bug_type/TOPIDOR.md) - Top reports by bug type.

### Resources

- [ ]  [Bug Bounty Tips](https://gowsundar.gitbook.io/book-of-bugbounty-tips)
- [ ]  [PentestBook](https://pentestbook.six2dez.com/)
- [ ]  [Bug Hunter Handbook](https://gowthams.gitbook.io/bughunter-handbook)

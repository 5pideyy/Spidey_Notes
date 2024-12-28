
### ACTIVE

|Technique|Description|Example|Tools|Risk of Detection|
|---|---|---|---|---|
|`Port Scanning`|Identifying open ports and services running on the target.|Using Nmap to scan a web server for open ports like 80 (HTTP) and 443 (HTTPS).|Nmap, Masscan, Unicornscan|High: Direct interaction with the target can trigger intrusion detection systems (IDS) and firewalls.|
|`Vulnerability Scanning`|Probing the target for known vulnerabilities, such as outdated software or misconfigurations.|Running Nessus against a web application to check for SQL injection flaws or cross-site scripting (XSS) vulnerabilities.|Nessus, OpenVAS, Nikto|High: Vulnerability scanners send exploit payloads that security solutions can detect.|
|`Network Mapping`|Mapping the target's network topology, including connected devices and their relationships.|Using traceroute to determine the path packets take to reach the target server, revealing potential network hops and infrastructure.|Traceroute, Nmap|Medium to High: Excessive or unusual network traffic can raise suspicion.|
|`Banner Grabbing`|Retrieving information from banners displayed by services running on the target.|Connecting to a web server on port 80 and examining the HTTP banner to identify the web server software and version.|Netcat, curl|Low: Banner grabbing typically involves minimal interaction but can still be logged.|
|`OS Fingerprinting`|Identifying the operating system running on the target.|Using Nmap's OS detection capabilities (`-O`) to determine if the target is running Windows, Linux, or another OS.|Nmap, Xprobe2|Low: OS fingerprinting is usually passive, but some advanced techniques can be detected.|
|`Service Enumeration`|Determining the specific versions of services running on open ports.|Using Nmap's service version detection (`-sV`) to determine if a web server is running Apache 2.4.50 or Nginx 1.18.0.|Nmap|Low: Similar to banner grabbing, service enumeration can be logged but is less likely to trigger alerts.|
|`Web Spidering`|Crawling the target website to identify web pages, directories, and files.|Running a web crawler like Burp Suite Spider or OWASP ZAP Spider to map out the structure of a website and discover hidden resources.|Burp Suite Spider, OWASP ZAP Spider, Scrapy (customisable)|Low to Medium: Can be detected if the crawler's behaviour is not carefully configured to mimic legitimate traffic.|

### Passive

|Technique|Description|Example|Tools|Risk of Detection|
|---|---|---|---|---|
|`Search Engine Queries`|Utilising search engines to uncover information about the target, including websites, social media profiles, and news articles.|Searching Google for "`[Target Name] employees`" to find employee information or social media profiles.|Google, DuckDuckGo, Bing, and specialised search engines (e.g., Shodan)|Very Low: Search engine queries are normal internet activity and unlikely to trigger alerts.|
|`WHOIS Lookups`|Querying WHOIS databases to retrieve domain registration details.|Performing a WHOIS lookup on a target domain to find the registrant's name, contact information, and name servers.|whois command-line tool, online WHOIS lookup services|Very Low: WHOIS queries are legitimate and do not raise suspicion.|
|`DNS`|Analysing DNS records to identify subdomains, mail servers, and other infrastructure.|Using `dig` to enumerate subdomains of a target domain.|dig, nslookup, host, dnsenum, fierce, dnsrecon|Very Low: DNS queries are essential for internet browsing and are not typically flagged as suspicious.|
|`Web Archive Analysis`|Examining historical snapshots of the target's website to identify changes, vulnerabilities, or hidden information.|Using the Wayback Machine to view past versions of a target website to see how it has changed over time.|Wayback Machine|Very Low: Accessing archived versions of websites is a normal activity.|
|`Social Media Analysis`|Gathering information from social media platforms like LinkedIn, Twitter, or Facebook.|Searching LinkedIn for employees of a target organisation to learn about their roles, responsibilities, and potential social engineering targets.|LinkedIn, Twitter, Facebook, specialised OSINT tools|Very Low: Accessing public social media profiles is not considered intrusive.|
|`Code Repositories`|Analysing publicly accessible code repositories like GitHub for exposed credentials or vulnerabilities.|Searching GitHub for code snippets or repositories related to the target that might contain sensitive information or code vulnerabilities.|GitHub, GitLab|Very Low: Code repositories are meant for public access, and searching them is not suspicious.|






## WHOIS

- used for social engineering and OSINT because it leaks the names, email addresses, and phone numbers of individuals responsible for managing the domain

```
whois <domain>
```

- need to see historical whois lookup ?  https://whoisfreaks.com/tools/user/whois/history/lookup/

### SUBDOMAIN BRUTE



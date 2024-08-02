# Overview
![[Pasted image 20240607182610.png]]
- helps to under stand attack surface
- technologies used
- working
![[20240620_010149.jpg]]

|Area|Description|
|---|---|
|Domains and Subdomains|Often, we are given a single domain or perhaps a list of domains and subdomains that belong to an organization. Many organizations do not have an accurate asset inventory and may have forgotten both domains and subdomains exposed externally. This is an essential part of the reconnaissance phase. We may come across various subdomains that map back to in-scope IP addresses, increasing the overall attack surface of our engagement (or bug bounty program). Hidden and forgotten subdomains may have old/vulnerable versions of applications or dev versions with additional functionality (a Python debugging console, for example). Bug bounty programs will often set the scope as something such as `*.inlanefreight.com`, meaning that all subdomains of `inlanefreight.com`, in this example, are in-scope (i.e., `acme.inlanefreight.com`, `admin.inlanefreight.com`, and so forth and so on). We may also discover subdomains of subdomains. For example, let's assume we discover something along the lines of `admin.inlanefreight.com`. We could then run further subdomain enumeration against this subdomain and perhaps find `dev.admin.inlanefreight.com` as a very enticing target. There are many ways to find subdomains (both passively and actively) which we will cover later in this module.|
|IP ranges|Unless we are constrained to a very specific scope, we want to find out as much about our target as possible. Finding additional IP ranges owned by our target may lead to discovering other domains and subdomains and open up our possible attack surface even wider.|
|Infrastructure|We want to learn as much about our target as possible. We need to know what technology stacks our target is using. Are their applications all ASP.NET? Do they use Django, PHP, Flask, etc.? What type(s) of APIs/web services are in use? Are they using Content Management Systems (CMS) such as WordPress, Joomla, Drupal, or DotNetNuke, which have their own types of vulnerabilities and misconfigurations that we may encounter? We also care about the web servers in use, such as IIS, Nginx, Apache, and the version numbers. If our target is running outdated frameworks or web servers, we want to dig deeper into the associated web applications. We are also interested in the types of back-end databases in use (MSSQL, MySQL, PostgreSQL, SQLite, Oracle, etc.) as this will give us an indication of the types of attacks we may be able to perform.|
|Virtual Hosts|Lastly, we want to enumerate virtual hosts (vhosts), which are similar to subdomains but indicate that an organization is hosting multiple applications on the same web server. We will cover vhost enumeration later in the module as well.|


# PASSIVE RECON


#### whois

```
whois <target>
```
- allow us to retrieve information about the domain name of an already registered domain

> [ICANN](https://www.icann.org/get-started) equires that accredited registrars enter the holder's contact information, the domain's creation, and expiration dates, and other information in the Whois database immediately after registering a domain

- `Domain Name`
- `Registrar`
- `Registrant Contact
- `Administrative Contact`
- `Technical Contact`
- `Creation and Expiration Dates`
#### dns


![[Pasted image 20240607184925.png]]


- to find out publicly accessible domains

> With Nslookup, we can search for domain name servers on the Internet and ask them for information about hosts and domains. Although the tool has two modes, interactive and non-interactive, we will mainly focus on the non-interactive module.



```SHELL
dig <target>
```

```shell
nslookup <target>
```

```shell-session
nslookup -query=TXT <target>
```


```shell-session
dig any <atrget>
```


#### VIRUS TOTAL
![[Pasted image 20240607190847.png]]
#### censys
![[Pasted image 20240607192103.png]]
#### crt.sh
![[Pasted image 20240607192129.png]]

- to extract subdomains
```shell
curl -s "https://crt.sh/?q=${TARGET}&output=json" | jq -r '.[] | "\(.name_value)\n\(.common_name)"' | sort -u > "${TARGET}_crt.sh.txt"
```

- or using openssl
```shell
openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' -connect "${TARGET}:${PORT}" | openssl x509 -noout -text -in - | grep 'DNS' | sed -e 's|DNS:|\n|g' -e 's|^\*.*||g' | tr -d ',' | sort -u
```


#### TheHarvester
- simple-to-use yet powerful and effective tool for early-stage penetration testing
- bug bounty
- collects various infromation by following applications

| Tool/Website                                             | Description                                                                                                                     |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| [Baidu](http://www.baidu.com/)                           | Baidu search engine.                                                                                                            |
| `Bufferoverun`                                           | Uses data from Rapid7's Project Sonar - [www.rapid7.com/research/project-sonar/](http://www.rapid7.com/research/project-sonar/) |
| [Crtsh](https://crt.sh/)                                 | Comodo Certificate search.                                                                                                      |
| [Hackertarget](https://hackertarget.com/)                | Online vulnerability scanners and network intelligence to help organizations.                                                   |
| `Otx`                                                    | AlienVault Open Threat Exchange - [https://otx.alienvault.com](https://otx.alienvault.com/)                                     |
| [Rapiddns](https://rapiddns.io/)                         | DNS query tool, which makes querying subdomains or sites using the same IP easy.                                                |
| [Sublist3r](https://github.com/aboul3la/Sublist3r)       | Fast subdomains enumeration tool for penetration testers                                                                        |
| [Threatcrowd](http://www.threatcrowd.org/)               | Open source threat intelligence.                                                                                                |
| [Threatminer](https://www.threatminer.org/)              | Data mining for threat intelligence.                                                                                            |
| `Trello`                                                 | Search Trello boards (Uses Google search)                                                                                       |
| [Urlscan](https://urlscan.io/)                           | A sandbox for the web that is a URL and website scanner.                                                                        |
| `Vhost`                                                  | Bing virtual hosts search.                                                                                                      |
| [Virustotal](https://www.virustotal.com/gui/home/search) | Domain search.                                                                                                                  |
| [Zoomeye](https://www.zoomeye.org/)                      | A Chinese version of Shodan.                                                                                                    |


- to automate using the above webs.. create a files containing names..
- then
```shell
cat sources.txt | while read source; do theHarvester -d "${TARGET}" -b $source -f "${source}_${TARGET}";done
```
- sort the subdomains
```shell
cat *.json | jq -r '.hosts[]' 2>/dev/null | cut -d':' -f 1 | sort -u > "${TARGET}_theHarvester.txt"
```
- merge subdomains
```shell
cat facebook.com_*.txt | sort -u > facebook.com_subdomains_passive.txt
```
#### Netcraft
- using htis we can gather some below

| Category          | Description                                                                                  |
|-------------------|----------------------------------------------------------------------------------------------|
| Background        | General information about the domain, including the date it was first seen by Netcraft crawlers. |
| Network           | Information about the netblock owner, hosting company, nameservers, etc.                     |
| Hosting history   | Latest IPs used, webserver, and target OS.                                                   |

#### waybackurls
- fetch domains from wwaaybackmachines
```shell

waybackurls -dates https://facebook.com > waybackurls.txt
```

---
# ACTIVE RECON
### Infrastructure Identification

```shell
curl -I "http://${TARGET}"
```


```shell
HTTP/1.1 200 OK
Date: Thu, 23 Sep 2021 15:10:42 GMT
Server: Apache/2.4.25 (Debian)
X-Powered-By: PHP/7.3.5
Link: <http://192.168.10.10/wp-json/>; rel="https://api.w.org/"
Content-Type: text/html; charset=UTF-8
```

- X-Powered-By header:  can see values like PHP, ASP.NET, JSP, etc.
    
- Cookies:  attractive value to look at as each technology by default has its cookies. 
    
    - .NET: `ASPSESSIONID<RANDOM>=<COOKIE_VALUE>`
    - PHP: `PHPSESSID=<COOKIE_VALUE>`
    - JAVA: `JSESSION=<COOKIE_VALUE>`

#### whatweb

```shell
whatweb -a3 <target> -v
```


#### wappalyzer

- extension to detect technologies

#### wafwoof
- a web application firewall (`WAF`) fingerprinting tool that sends requests and analyses responses
- finds if any security
```shell-session
wafw00f -v <target>
```

#### aquatone

- visits website and capture screenshots to visualize bulk amount of websites
```shell
cat facebook_aquatone.txt | aquatone -out ./aquatone -screenshot-timeout 1000
```

- generates html page with screenshots

### Active Subdomain Enumeration
- probing the infrastructure managed by the target organization or the 3rd party DNS servers
##### Zone transfers
- used in the Domain Name System (DNS) to replicate the DNS database across multiple DNS servers
- ensures redundancy,avalability,efficiency of dns resolution
- https://hackertarget.com/zone-transfer/ used to find the information about zone transfer
or 
```shell-session
nslookup -type=any -query=AXFR <domain> <target>
```

``` shell
dig axfr @<ns-server> <domain>

```
to find ns server
```shell-
nslookup -type=NS <target>
```

 
if this happens successful we have gathered all subdomains...


### Vhost enumeration
-  allows several websites to be hosted on a single server

#### IP address Based vhost
- many network interface(many ips) for one host, each ip assigned to one domain
-  Network Interface 1: 192.168.1.10 (primary IP address)
- Network Interface 1 Alias: 192.168.1.11 (alias IP address)
- Network Interface 2: 192.168.1.20 (secondary network interface)

##### Web Server Configuration

- **Site1**:
    - IP Address: 192.168.1.10
    - Domain: [www.site1.com](http://www.site1.com)
- **Site2**:
    - IP Address: 192.168.1.11
    - Domain: [www.site2.com](http://www.site2.com)
- **Mail Server for Site1**:
    - IP Address: 192.168.1.20
    - Domain: mail.site1.com
##### Setting up
```shell
# Assign IP address to the primary interface
ip addr add 192.168.1.10/24 dev eth0

# Create an alias for the primary interface
ip addr add 192.168.1.11/24 dev eth0:1

# Assign IP address to the secondary interface
ip addr add 192.168.1.20/24 dev eth1
```

```apache
# Configuration for site1.com
<VirtualHost 192.168.1.10:80>
    ServerName www.site1.com
    DocumentRoot /var/www/site1
</VirtualHost>

# Configuration for site2.com
<VirtualHost 192.168.1.11:80>
    ServerName www.site2.com
    DocumentRoot /var/www/site2
</VirtualHost>
```
    
#### Name based vhost

- distinguish for which domain the service was requested (application level)
- `admin.inlanefreight.htb` and `backup.inlanefreight.htb` points to same ip 
- but internally different folders admin.inlanefreight.htb => /var/www/admin ,backup.inlanefreight.htb => /var/www/backup


##### Automate using fuff
```shell
ffuf -w /opt/useful/SecLists/Discovery/DNS/namelist.txt -u http://192.168.10.10 -H "HOST: FUZZ.randomtarget.com" -fs 612
```












# CHEETSHEET

## WHOIS

| **Command**                  | **Description**                           |
| ---------------------------- | ----------------------------------------- |
| `export TARGET="domain.tld"` | Assign target to an environment variable. |
| `whois $TARGET`              | WHOIS lookup for the target.              |

---

## DNS Enumeration

| **Command**                        | **Description**                                      |
| ---------------------------------- | ---------------------------------------------------- |
| `nslookup $TARGET`                 | Identify the `A` record for the target domain.       |
| `nslookup -query=A $TARGET`        | Identify the `A` record for the target domain.       |
| `dig $TARGET @<nameserver/IP>`     | Identify the `A` record for the target domain.       |
| `dig a $TARGET @<nameserver/IP>`   | Identify the `A` record for the target domain.       |
| `nslookup -query=PTR <IP>`         | Identify the `PTR` record for the target IP address. |
| `dig -x <IP> @<nameserver/IP>`     | Identify the `PTR` record for the target IP address. |
| `nslookup -query=ANY $TARGET`      | Identify `ANY` records for the target domain.        |
| `dig any $TARGET @<nameserver/IP>` | Identify `ANY` records for the target domain.        |
| `nslookup -query=TXT $TARGET`      | Identify the `TXT` records for the target domain.    |
| `dig txt $TARGET @<nameserver/IP>` | Identify the `TXT` records for the target domain.    |
| `nslookup -query=MX $TARGET`       | Identify the `MX` records for the target domain.     |
| `dig mx $TARGET @<nameserver/IP>`  | Identify the `MX` records for the target domain.     |

---

## Passive Subdomain Enumeration

| **Resource/Command**                                                                                               | **Description**                                                                                |
| ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| `VirusTotal`                                                                                                       | [https://www.virustotal.com/gui/home/url](https://www.virustotal.com/gui/home/url)             |
| `Censys`                                                                                                           | [https://censys.io/](https://censys.io/)                                                       |
| `Crt.sh`                                                                                                           | [https://crt.sh/](https://crt.sh/)                                                             |
| `curl -s https://sonar.omnisint.io/subdomains/{domain} \| jq -r '.[]' \| sort -u`                                  | All subdomains for a given domain.                                                             |
| `curl -s https://sonar.omnisint.io/tlds/{domain} \| jq -r '.[]' \| sort -u`                                        | All TLDs found for a given domain.                                                             |
| `curl -s https://sonar.omnisint.io/all/{domain} \| jq -r '.[]' \| sort -u`                                         | All results across all TLDs for a given domain.                                                |
| `curl -s https://sonar.omnisint.io/reverse/{ip} \| jq -r '.[]' \| sort -u`                                         | Reverse DNS lookup on IP address.                                                              |
| `curl -s https://sonar.omnisint.io/reverse/{ip}/{mask} \| jq -r '.[]' \| sort -u`                                  | Reverse DNS lookup of a CIDR range.                                                            |
| `curl -s "https://crt.sh/?q=${TARGET}&output=json" \| jq -r '.[] \| "\(.name_value)\n\(.common_name)"' \| sort -u` | Certificate Transparency.                                                                      |
| `cat sources.txt \| while read source; do theHarvester -d "${TARGET}" -b $source -f "${source}-${TARGET}";done`    | Searching for subdomains and other information on the sources provided in the source.txt list. |

#### Sources.txt

Code: txt

```txt
baidu
bufferoverun
crtsh
hackertarget
otx
projecdiscovery
rapiddns
sublist3r
threatcrowd
trello
urlscan
vhost
virustotal
zoomeye
```

---

## Passive Infrastructure Identification

| **Resource/Command**                                   | **Description**                                                                      |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| `Netcraft`                                             | [https://www.netcraft.com/](https://www.netcraft.com/)                               |
| `WayBackMachine`                                       | [http://web.archive.org/](http://web.archive.org/)                                   |
| `WayBackURLs`                                          | [https://github.com/tomnomnom/waybackurls](https://github.com/tomnomnom/waybackurls) |
| `waybackurls -dates https://$TARGET > waybackurls.txt` | Crawling URLs from a domain with the date it was obtained.                           |

---

## Active Infrastructure Identification

|**Resource/Command**|**Description**|
|---|---|
|`curl -I "http://${TARGET}"`|Display HTTP headers of the target webserver.|
|`whatweb -a https://www.facebook.com -v`|Technology identification.|
|`Wappalyzer`|[https://www.wappalyzer.com/](https://www.wappalyzer.com/)|
|`wafw00f -v https://$TARGET`|WAF Fingerprinting.|
|`Aquatone`|[https://github.com/michenriksen/aquatone](https://github.com/michenriksen/aquatone)|
|`cat subdomain.list \| aquatone -out ./aquatone -screenshot-timeout 1000`|Makes screenshots of all subdomains in the subdomain.list.|

---

## Active Subdomain Enumeration

| **Resource/Command**                                                                                       | **Description**                                                                          |
| ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `HackerTarget`                                                                                             | [https://hackertarget.com/zone-transfer/](https://hackertarget.com/zone-transfer/)       |
| `SecLists`                                                                                                 | [https://github.com/danielmiessler/SecLists](https://github.com/danielmiessler/SecLists) |
| `nslookup -type=any -query=AXFR $TARGET nameserver.target.domain`                                          | Zone Transfer using Nslookup against the target domain and its nameserver.               |
| `gobuster dns -q -r "${NS}" -d "${TARGET}" -w "${WORDLIST}" -p ./patterns.txt -o "gobuster_${TARGET}.txt"` | Bruteforcing subdomains.                                                                 |

---

## Virtual Hosts

| **Resource/Command**                                                                                                                                                                       | **Description**                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| `curl -s http://192.168.10.10 -H "Host: randomtarget.com"`                                                                                                                                 | Changing the HOST HTTP header to request a specific domain.                |
| `cat ./vhosts.list \| while read vhost;do echo "\n********\nFUZZING: ${vhost}\n********";curl -s -I http://<IP address> -H "HOST: ${vhost}.target.domain" \| grep "Content-Length: ";done` | Bruteforcing for possible virtual hosts on the target domain.              |
| `ffuf -w ./vhosts -u http://<IP address> -H "HOST: FUZZ.target.domain" -fs 612`                                                                                                            | Bruteforcing for possible virtual hosts on the target domain using `ffuf`. |

---

## Crawling

| **Resource/Command**                                                                                                                                 | **Description**                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `ZAP`                                                                                                                                                | [https://www.zaproxy.org/](https://www.zaproxy.org/)                          |
| `ffuf -recursion -recursion-depth 1 -u http://192.168.10.10/FUZZ -w /opt/useful/SecLists/Discovery/Web-Content/raft-small-directories-lowercase.txt` | Discovering files and folders that cannot be spotted by browsing the website. |
| `ffuf -w ./folders.txt:FOLDERS,./wordlist.txt:WORDLIST,./extensions.txt:EXTENSIONS -u http://www.target.domain/FOLDERS/WORDLISTEXTENSIONS`           | Mutated bruteforcing against the target web server.                           |

### **U18CSE0023 Ethical Hacking and Network Defence**

**Course Faculty**: Dr. J. Cynthia, Professor, CSE

---

### **Lab Exercise 1: Reconnaissance Phase of Ethical Hacking**

**Objective**: To perform reconnaissance on a target network using Kali Linux tools to gather detailed information about IP addresses, open ports, services, and potential vulnerabilities.

---

### **Safety and Ethics**

- **Legal Compliance**: Ensure that all reconnaissance activities are conducted on networks and domains for which explicit permission has been obtained.
- **Ethical Considerations**: Adhere to ethical guidelines to avoid unauthorized access and maintain confidentiality of the information gathered.

---

### **Tools Used**

- **Nmap**: Network exploration tool and security scanner.
- **Whois**: Query and response protocol that is widely used for querying databases that store the registered users of an Internet resource.
- **nslookup**: Network administration command-line tool for querying the Domain Name System (DNS).
- **theHarvester**: Tool designed to gather open-source intelligence (OSINT) about a domain.
- **Shodan**: Search engine for Internet-connected devices.
- **Subfinder**: A subdomain discovery tool that discovers valid subdomains for websites.
- **Maltego**: A tool for graphical link analyses, especially useful in cybersecurity.

---

### **Lab Tasks and Results**

---

#### **1. Setup and Initialization**

- **Task**: Launch Kali Linux in a virtual machine environment.
- **Result**: Kali Linux initialized successfully, ready for reconnaissance tasks.

---

#### **2. Scanning with Nmap**

##### **Basic Port Scanning**

- **Objective**: Identify open ports and associated services on the target system.
- **Command**: `nmap -sS hackthebox.com`
- **Findings**:
    - **Open Ports**:
        - 80/tcp (HTTP)
        - 443/tcp (HTTPS)
        - 8080/tcp (HTTP Proxy)
        - 8443/tcp (HTTPS-ALT)
    - **Services Detected**:
        - HTTP and HTTPS services over standard and alternative ports.
- **Screenshot**:
    ![[Pasted image 20240810235221.png]]

##### **Service Version Detection**

- **Objective**: Determine the specific versions of the services running on the open ports.
    
- **Command**: `nmap -sV hackthebox.com`
    
- **Findings**:
    
    - **Service Versions Identified**:
        - Cloudflare HTTP Proxy identified on all open ports.
        - This indicates the use of Cloudflare services for traffic management and security, which could mask the underlying infrastructure.
- **Screenshot**:
    ![[Pasted image 20240810235238.png]]

##### **Operating System Detection**

- **Objective**: Identify the operating system of the target server.
    
- **Command**: `nmap -O hackthebox.com`
    
- **Findings**:
    
    - **OS Detection**: Results were inconclusive due to insufficient open ports. The system may be using methods to obscure OS detection.
    - **Note**: Obfuscation techniques such as IP filtering or proxies (e.g., Cloudflare) could be in use, which complicates OS fingerprinting.
- **Screenshot**:
    ![[Pasted image 20240810235256.png]]

##### **Scripting with Nmap**

- **Objective**: Utilize Nmap's scripting engine for advanced reconnaissance.
    
- **Command**: `nmap --script=http-title hackthebox.com`
    
- **Findings**:
    
    - **Script Results**: HTTP titles could not be retrieved due to forced HTTPS redirections by the server.
    - **Implication**: The server enforces strong security policies, including automatic redirection to secure HTTPS channels.
- **Screenshot**:
    ![[Pasted image 20240810235313.png]]

---

#### **3. Ping**

- **Objective**: Verify the availability and measure the latency of the target server.
    
- **Command**: `ping hackthebox.com`
    
- **Findings**:
    
    - **RTT (Round-Trip Time)**: Average round-trip time was approximately 16 ms, with no packet loss.
    - **Implication**: The server is reachable and exhibits low latency, indicative of a well-optimized network path.
- **Screenshot**:
    ![[Pasted image 20240810225108.png]]

---

#### **4. WHOIS Lookup**

- **Objective**: Gather registration information about the target domain.
    
- **Command**: `whois hackthebox.com`
    
- **Findings**:
    
    - **Domain Information**:
        - **Registrar**: Amazon Registrar, Inc.
        - **Registration Date**: 2010-03-18
        - **Expiry Date**: 2025-03-18
        - **Name Servers**: cody.ns.cloudflare.com, jill.ns.cloudflare.com
    - **Implication**: The domain is managed by a reputable registrar and is secured with Cloudflare's DNS services, which enhances security against DDoS attacks and unauthorized DNS changes.
- **Screenshot**:
    ![[Pasted image 20240810225052.png]]

---

#### **5. DNS Enumeration with nslookup**

- **Objective**: Retrieve DNS records related to the target domain.
    
- **Command**: `nslookup -type=any hackthebox.com`
    
- **Findings**:
    
    - **MX Records**: The domain uses Google's mail servers, indicating a reliance on Google Workspace for email services.
    - **Name Servers**: Managed by Cloudflare, providing enhanced security features.
- **Screenshot**:
    ![[Pasted image 20240810225303.png]]
    

---

#### **6. IP Lookup**

- **Objective**: Determine the geographical location and ISP associated with the target IP address.
    
- **Tool**: `ipinfo.io`
    
- **Findings**:
    
    - **Location**: San Francisco, California, USA
    - **ISP**: Cloudflare, Inc.
    - **Implication**: The server is hosted and protected by Cloudflare, a leading content delivery network (CDN) and DDoS mitigation service.
- **Screenshot**:
    ![[Pasted image 20240810225727.png]]

---

#### **7. Traceroute**

- **Objective**: Trace the route packets take from the source to the target.
    
- **Command**: `traceroute hackthebox.com`
    
- **Findings**:
    
    - **Hops Identified**: Multiple hops were detected, including key nodes in Airtel's network in India and Cloudflare's network in the United States.
    - **Significant Points**: The presence of Cloudflare in the trace suggests the use of their services for routing and protection.
- **Screenshot**:
    ![[Pasted image 20240810232657.png]]


---

#### **8. Information Gathering with theHarvester**

- **Objective**: Collect emails and subdomains using OSINT tools.
    
- **Command**: `theHarvester -d hackthebox.com -b bing`
    
- **Findings**:
    
    - **Subdomains Identified**: 10 subdomains, including `academy.hackthebox.com` and `sso.hackthebox.com`.
    - **Emails Found**: No emails were detected, possibly due to effective obfuscation or security measures in place by the target.
- **Screenshot**:
    ![[Pasted image 20240810230524.png]]

---
#### **9. Subdomain Enumeration with Subfinder**

- **Objective**: Discover subdomains associated with the target domain.
    
- **Command**: `subfinder -d hackthebox.com`
    
- **Findings**:
    
    - **Subdomains Discovered**: 57 subdomains were found, including critical ones like `academy.hackthebox.com`, `enterprise.hackthebox.com`, and `ctf.hackthebox.com`.
    - **Implication**: The discovery of these subdomains provides insights into the structure and services offered by Hack The Box, which could be potential vectors for further investigation.
- **Screenshot**:
    ![[Pasted image 20240810231139.png]]
---

#### **10. Exploring Shodan**

- **Objective**: Utilize Shodan to uncover publicly available information about the target IP.
    
- **Command**: `shodan search hackthebox.com`
    
- **Findings**:
    
    - **IP Address**: 104.18.21.126
    - **SSL Certificates**: The target uses SSL certificates issued by Let's Encrypt, with support for TLSv1.2 and TLSv1.3.
    - **Implication**: The target employs strong encryption protocols, ensuring secure communication channels.
- **Screenshot**:
    ![[Pasted image 20240810230817.png]]

---

### **Data Analysis and Report**

#### **Documentation**

- **In-Depth Report**: This report compiles and analyzes the results of all reconnaissance tasks, providing detailed insights into the target's network structure and security measures.
- **Tools Used**: The use of advanced tools like Nmap, Subfinder, and Shodan provides a comprehensive view of the target's online presence.

#### **Analysis**

- **Security Risks**:
    
    - **Open Ports**: The presence of multiple open ports could be exploited if not properly secured.
    - **Subdomains**: The discovery of numerous subdomains could present additional attack surfaces if not adequately protected.
    - **Operating System Obfuscation**: The difficulty in determining the OS suggests the target uses advanced techniques to conceal its infrastructure.
- **Recommendations**:
    
    - **Firewall Configuration**: Implement strict firewall rules to limit exposure of unnecessary ports.
    - **Subdomain Management**: Regularly review and secure subdomains to prevent unauthorized access.
    - **Continuous Monitoring**: Employ continuous monitoring tools to detect and respond to potential threats in real-time.

#### **Team Contributions**

- **VISHWA J - 22BAD116**: Responsible for Nmap scanning, service detection, and operating system fingerprinting.
- **YOGESH C - 22BAD118**: Conducted DNS enumeration, IP lookup, and subdomain discovery.
- Handled Shodan exploration, WHOIS lookup, and analysis of results using Maltego.
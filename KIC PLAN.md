
### Networking Sessions (4)

| Session | Topics                                                                                | End Goals                                                                                 | Tasks                                                                                                                                                                                                                                                                                        | Person      |
| ------- | ------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| 1       | Network Types, VPNs, Topology (Cables), Devices (Switch, Hub), Wireless, Proxy, Socks | Understand various network types, topology, devices, wireless networks, and proxy servers | - Study different network types<br>- Explore VPN protocols and configurations<br>- Review different topologies and cable types<br>- Understand the functions and configurations of network devices<br>- Study wireless standards and configurations<br>- Learn about proxy and SOCKS servers | Shriram     |
| 2       | IP Class, Simple Network Design, OSI Recap                                            | Master IP classes, design a simple network, and recap the OSI model                       | - Recap the OSI model<br>- Classify IP addresses<br>- Design and configure a simple network with NAT                                                                                                                                                                                         | Manoj, Hari |
| 3       | Subnetting, VLANs                                                                     | Understand and implement subnetting and VLANs                                             | - Study subnetting concepts and practice<br>- Configure VLANs using David's labs                                                                                                                                                                                                             | Subash      |
| 4       |  Servers (Various Types)                                                              | Configure and manage different types of servers                                           | - Study and configure various server types (web, FTP, DHCP, SMB, SMTP, IMAP, POP3)                                                                                                                                                                                                           | Pradyun     |

### Network Engineering Session (1)

|Session|Topics|End Goals|Tasks|Person|
|---|---|---|---|---|
|1|OSI Recap, Simple Network Design, Server Configurations (Web, FTP, DHCP)|Recap OSI, design networks, and configure servers|- OSI recap<br>- Design network in Packet Tracer<br>- Configure web, FTP, and DHCP servers in Packet Tracer|Manoj|

###  Virtualization Session (1)

| Session | Topics         | End Goals                                           | Tasks                                                                                                                                                                               | Person  |
| ------- | -------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| 1       | Virtualization | Understand virtualization concepts and applications | - Study virtualization technologies (e.g., VMs, containers)<br>- Explore popular virtualization tools (e.g., VMware, VirtualBox, Docker)<br>- Implement basic virtualization setups | Shriram |
### Operating Systems Session (1)

|Session|Topics|End Goals|Tasks|Person|
|---|---|---|---|---|
|1|OS Structure, Virtualization|Understand OS structure and virtualization|- Study OS architecture<br>- Explore virtualization techniques and tools|Subash|

### Linux Fundamentals Session (1)

| Session | Topics                                                                   | End Goals                                     | Tasks                                                                                              | Person |
| ------- | ------------------------------------------------------------------------ | --------------------------------------------- | -------------------------------------------------------------------------------------------------- | ------ |
| 1       | User Management, Process, Permissions, File System, GRUB, Booting System | Master Linux basics and system administration | - Manage users and processes<br>- Set permissions<br>- Explore file system, GRUB, and boot process | Hari   |

### Windows Fundamentals Session (1)

| Session | Topics                | End Goals                                 | Tasks                                                          | Person |
| ------- | --------------------- | ----------------------------------------- | -------------------------------------------------------------- | ------ |
| 1       | Active Directory (AD) | Understand and configure Active Directory | - Study AD concepts<br>- Configure AD in a Windows environment | Hari   |

### Cybersecurity Domains Sessions (11)

| Session | Topics              | End Goals                          | Tasks                                                                                                        | Person       |
| ------- | ------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------ |
| 1       | Cryptography        | Understand cryptography basics     | - Study encryption and decryption methods<br>- Explore cryptographic protocols                               | Hari, Subash |
| 2       | Cryptography        | Advanced cryptographic techniques  | - Implement advanced cryptographic techniques<br>- Analyze cryptographic security                            | Subash, Hari |
| 3       | Reverse Engineering | Basics of reverse engineering      | - Study reverse engineering concepts<br>- Practice with simple binaries                                      | Kishore      |
| 4       | Reverse Engineering | Advanced reverse engineering       | - Analyze complex binaries<br>- Use advanced reverse engineering tools                                       | Kishore      |
| 5       | Web Security        | Understand web security principles | - Study common web vulnerabilities (e.g., SQL injection, XSS)<br>- Explore web security tools and techniques | Shriram      |
| 6       | Web Security        | Advanced web security              | - Perform web application penetration testing<br>- Mitigate web security threats                             | Pradyun      |
| 7       | Forensics           | Basics of digital forensics        | - Study forensic methodologies<br>- Practice with forensic tools and techniques                              | Vishl        |
| 8       | Forensics           | Advanced digital forensics         | - Analyze complex forensic cases<br>- Use advanced forensic tools                                            | Vishl        |
| 9       | Malware Analysis    | Basics of malware analysis         | - Study malware types and behaviors<br>- Analyze simple malware samples                                      | Shubash      |
| 10      | Malware Analysis    | Advanced malware analysis          | - Analyze complex malware<br>- Use advanced malware analysis tools and techniques                            | Shubash      |
| 11      | Blockchain          | Understand blockchain technology   | - Study blockchain concepts<br>- Explore blockchain applications and security                                | Manoj        |
# Script

I followed the same methodology that I typically use for HackTheBox machines, starting from recon


- **Port Scanning with Nmap:**  
    I started by scanning the target system using Nmap to identify open ports. This revealed four main open ports, including services like GraphQL and Apache, which are key entry points.
    
- **Directory Fuzzing with Dirsearch:**  
    Next, I used Dirsearch to brute-force directories . This allowed me to uncover interesting files and directories such as `/config.txt`, `/swagger.json`, `/phpmyadmin`, and others, which could contain sensitive information or misconfigurations.
    
- **Sitemap Building with Burp Suite:**  
    To maintain a comprehensive view of the web application, I manually explored the site using Burp Suite. This helped me populate a complete sitemap, making it easier to track discovered endpoints and resources.
    



Once reconnaissance was complete, I moved on to identifying vulnerabilities and extracting flags. Here’s how I approached each discovery:

- **SSL Certificate Flag:**  
    I noticed that the SSL certificate contained an encrypted flag and hinted as Zigzag encryption method. I decrypted it to reveal the flag
    
- **Shellshock Vulnerability:**  
    When I visited the Apache web service, I found the word `shocking`, which hinted at a possible Shellshock vulnerability. By examining the source code, I discovered a CGI endpoint. Using HackTricks documentation, I was able to retrieve the flag from the `/follow` directory.
    
- **Database Flag:**  
    The `/config.txt` file contained a reference to `./IMPORTANTDATABASEHERE`. Accessing this directory led me to another flag.
    
- **Directory Listing:**  
    Directory listing was enabled in the `/resource/img` directory. Within this, I discovered a `secret` directory that contained a `flag.html` file. The flag was easily extracted from the source code.
    
- **PhpMyAdmin Access:**  
    I attempted to log into PhpMyAdmin using default credentials and succeeded. Inside, I found a flag in the `users` table, which required exporting to view fully.
    
- **API Flag:**  
    The `/swagger.json` file provided valuable information about the available API endpoints. By calling the `fetch_all_user` API, I obtained another flag.
    
- **Insecure Deserialization:**  
    The `shutdown.php` endpoint set two cookies, one containing a file path. By modifying the other cookie, which is a serialized object, to point to `/etc/flag/1.txt` and adjusting the string length, I was able to capture the flag.
    
- **SQL Injection (SQLi):**  
    in the `/API/users/complaintupdate.php` endpoint, I discovered a SQL injection vulnerability. By exploiting it, I dumped the entire database, which revealed two flags (SQLi and SSTI flag), as well as encrypted passwords for several users, including admins and technician
    
- **JWT Flag:**  
    While monitoring the login process with Burp Suite, I intercepted and modified the request, specifically the encrypted password. This manipulation allowed me to obtain a JWT token for a technician, which I then used to access `/api/list_reading.php` and retrieve a flag.
    
- **Error Flag:**  
    Accessing a non-existent directory returned an error message containing a flag.
    
- **Sensitive Information Disclosure:**  
    The `/developer.json` file pointed me to the `/developer.php` endpoint, which was similar to `/index.php`. By comparing the source code using Burp Suite’s comparator, I found a `sensitive.txt` file with another flag.
    

## Reconnaissance

1. **Port Scanning with Nmap**:
    
    - Scanned the target system for open ports using the `-p` option in Nmap.
    - Discovered four main open ports, including:
        - **GraphQL**
        - **Apache**
2. **Directory Fuzzing with Dirsearch**:
    
    - Conducted directory brute-forcing on port 80 using Dirsearch.
    - Identified several interesting directories and files:
        - `/config.txt`
        - `/swagger.json`
        - `/resource/img`
        - `/phpmyadmin`
        - `/developer.json`
3. **Sitemap Building with Burp Suite**:
    
    - Used Burp Suite to manually explore the website and fill up the sitemap.
    - This helped in keeping track of all discovered endpoints and resources.

## Vulnerabilities and Flags

### 1. **SSL Certificate Flag**

- Discovered an encrypted flag within the SSL certificate.
- Decrypted using a Zigzag encryption method to retrieve the flag.

### 2. **Shellshock Vulnerability**

- Noticed the keyword `shocking` during service inspection, indicating a potential Shellshock vulnerability.
- Identified a CGI endpoint in the source code.
- Exploited using an exploit from Exploit-DB and found the flag in the `/follow` directory.

### 3. **Database Flag**

- Accessed the `/config.txt` file which revealed a path to `./IMPORTANTDATABASEHERE`.
- Navigated to this directory and retrieved the flag.

### 4. **Directory Listing**

- Discovered directory listing enabled in `/resource/img`.
- Found a `secret` directory containing `flag.html`.
- Retrieved the flag from the source code.

### 5. **PhpMyAdmin Access**

- Attempted login to PhpMyAdmin with default credentials.
- Successfully logged in and found a flag within the `users` table (export required to view the full flag).

### 6. **API Flag**

- Analyzed `/swagger.json` to obtain information about all API endpoints.
- Retrieved user info via the API, which contained a flag.

### 7. **Insecure Deserialization**

- Accessed `shutdown.php` which set two cookies, one containing a file path (`cat /etc/flag/13.txt`) and another with a PHP cookie.
- Modified the file path in the cookie and updated the string length to retrieve the flag.

### 8. **SQL Injection (SQLi)**

- Discovered SQLi in `/API/users/complaintUpdate.php`.
- Dumped the entire database, finding two flags (SQLi and SSTI flags), along with encrypted passwords of various users, including admin and technician.

### 9. **JWT Flag**

- Intercepted and modified the login request using Burp Suite.
- Changed the encrypted password during intercept and obtained a JWT token for a technician.
- Used the technician's JWT to access `/api/list_reading.php` and retrieved the flag.

### 10. **Error Flag**

- Navigated to a non-existing directory which revealed a flag in the error response.

### 11. **Sensitive Information Disclosure**

- The `/developer.json` file revealed an endpoint `/developer.php`, similar to `/index.php`.
- Used Burp Suite's comparator to analyze the differences in source code, leading to the discovery of `sensitive.txt` containing a flag.




# Script

I followed the same methodology that I typically use for HackTheBox machines, starting from recon.

### Port Scanning with Nmap

I started by scanning the target system using Nmap to identify open ports. This revealed four main open ports, including services like GraphQL and Apache, which are key entry points.

### Directory Fuzzing with Dirsearch

Next, I used Dirsearch to brute-force directories. This allowed me to uncover interesting files and directories such as `/config.txt`, `/swagger.json`, `/phpmyadmin`, and others, which could contain sensitive information or misconfigurations.

### Sitemap Building with Burp Suite

To maintain a comprehensive view of the web application, I manually explored the site using Burp Suite. This helped me populate a complete sitemap, making it easier to track discovered endpoints and resources.

---

Once reconnaissance was complete, I moved on to identifying vulnerabilities and extracting flags. Here’s how I approached each discovery:

### SSL Certificate Flag

I noticed that the SSL certificate contained an encrypted flag and hinted at a Zigzag encryption method. I decrypted it to reveal the flag.

### Shellshock Vulnerability

When I visited the Apache web service, I found the word `shocking`, which hinted at a possible Shellshock vulnerability. By examining the source code, I discovered a CGI endpoint. Using HackTricks documentation, I was able to retrieve the flag from the `/follow` directory.

### Database Flag

The `/config.txt` file contained a reference to `./IMPORTANTDATABASEHERE`. Accessing this directory led me to another flag.

### Directory Listing

Directory listing was enabled in the `/resource/img` directory. Within this, I discovered a `secret` directory that contained a `flag.html` file. The flag was easily extracted from the source code.

### PhpMyAdmin Access

I attempted to log into PhpMyAdmin using default credentials and succeeded. Inside, I found a flag in the `users` table, which required exporting to view fully.

### API Flag

The `/swagger.json` file provided valuable information about the available API endpoints. By calling the `fetch_all_user` API, I obtained another flag.

### Insecure Deserialization

The `shutdown.php` endpoint set two cookies, one containing a file path. By modifying the other cookie, which is a serialized object, to point to `/etc/flag/1.txt` and adjusting the string length, I was able to capture the flag.

### SQL Injection (SQLi)

In the `/API/users/complaintupdate.php` endpoint, I discovered a SQL injection vulnerability. By exploiting it, I dumped the entire database, which revealed two flags (SQLi and SSTI flag), as well as encrypted passwords for several users, including admins and technicians.

### JWT Flag

While monitoring the login process with Burp Suite, I intercepted and modified the request, specifically the encrypted password. This manipulation allowed me to obtain a JWT token for a technician, which I then used to access `/api/list_reading.php` and retrieve a flag.

### Error Flag

Accessing a non-existent directory returned an error message containing a flag.

### Sensitive Information Disclosure

The `/developer.json` file pointed me to the `/developer.php` endpoint, which was similar to `/index.php`. By comparing the source code using Burp Suite’s comparator, I found a `sensitive.txt` file with another flag.
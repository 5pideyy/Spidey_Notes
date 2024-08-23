
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





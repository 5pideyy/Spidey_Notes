
**For Recon**

┌─[mr_g0d@parrot]─[~/Desktop]
└──╼ $sudo nmap -p- -T4 -vvv 10.129.192.132
Starting Nmap 7.93 ( https://nmap.org ) at 2023-03-26 11:58 IST
Initiating Ping Scan at 11:58
Scanning 10.129.192.132 [4 ports]
Completed Ping Scan at 11:58, 0.29s elapsed (1 total hosts)
Initiating SYN Stealth Scan at 11:58
Scanning qreader.htb (10.129.192.132) [65535 ports]
Discovered open port 22/tcp on 10.129.192.132
Discovered open port 80/tcp on 10.129.192.132
SYN Stealth Scan Timing: About 20.09% done; ETC: 12:00 (0:02:03 remaining)
Discovered open port 5789/tcp on 10.129.192.132

─[✗]─[mr_g0d@parrot]─[~/Desktop]
└──╼ $sudo nmap -p 22,80,5789 -sCV -vvv 10.129.192.132
Starting Nmap 7.93 ( https://nmap.org ) at 2023-03-26 12:06 IST
PORT     STATE SERVICE REASON         VERSION
22/tcp   open  ssh     syn-ack ttl 63 OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 4fe3a667a227f9118dc30ed773a02c28 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIzAFurw3qLK4OEzrjFarOhWslRrQ3K/MDVL2opfXQLI+zYXSwqofxsf8v2MEZuIGj6540YrzldnPf8CTFSW2rk=
|   256 816e78766b8aea7d1babd436b7f8ecc4 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTtbUicaITwpKjAQWp8Dkq1glFodwroxhLwJo6hRBUK
80/tcp   open  http    syn-ack ttl 63 Apache httpd 2.4.52
|_http-title: Site doesn't have a title (text/html; charset=utf-8).
| http-methods: 
|_  Supported Methods: OPTIONS GET HEAD
| http-server-header: 
|   Apache/2.4.52 (Ubuntu)
|_  Werkzeug/2.1.2 Python/3.10.6
5789/tcp open  unknown syn-ack ttl 63
| fingerprint-strings: 
|   GenericLines: 
|     HTTP/1.1 400 Bad Request
|     Date: Sun, 26 Mar 2023 06:36:46 GMT
|     Server: Python/3.10 websockets/10.4
|     Content-Length: 77
|     Content-Type: text/plain
|     Connection: close
|     Failed to open a WebSocket connection: did not receive a valid HTTP request.

We have Websocket on port 5789

We run a tool for enumerating websockets in the background, while we continue with other enumeration.

[https://github.com/PalindromeLabs/STEWS](https://github.com/PalindromeLabs/STEWS)

┌─[✗]─[mr_g0d@parrot]─[~/GOD/HTB/MACHINES/socket/app]
└──╼ $python3 STEWS-vuln-detect.py -1 -n -u 10.129.192.132:5789
   Testing ws://10.129.192.132:5789
>>>Note: ws://10.129.192.132:5789 allowed http or https for origin
>>>Note: ws://10.129.192.132:5789 allowed null origin
>>>Note: ws://10.129.192.132:5789 allowed unusual char (possible parse error)
>>>VANILLA CSWSH DETECTED: ws://10.129.192.132:5789 likely vulnerable to vanilla CSWSH (any origin)
====Full list of vulnerable URLs===
['ws://10.129.192.132:5789']
['>>>VANILLA CSWSH DETECTED: ws://10.129.192.132:5789 likely vulnerable to vanilla CSWSH (any origin)']


When I check the browser ..I can able to download thier app for both linux and windows.

Its time to do reverse engineering ...!!

[https://github.com/zrax/pycdc](https://github.com/zrax/pycdc)



tkeller:denjanjade122566



tkeller@socket:/tmp$ sudo -l
Matching Defaults entries for tkeller on socket:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User tkeller may run the following commands on socket:
    (ALL : ALL) NOPASSWD: /usr/local/sbin/build-installer.sh

tkeller@socket:/tmp$ cat /usr/local/sbin/build-installer.sh
#!/bin/bash
if [ $# -ne 2 ] && [[ $1 != 'cleanup' ]]; then
  /usr/bin/echo "No enough arguments supplied"
  exit 1;
fi

action=$1
name=$2
ext=$(/usr/bin/echo $2 |/usr/bin/awk -F'.' '{ print $(NF) }')

if [[ -L $name ]];then
  /usr/bin/echo 'Symlinks are not allowed'
  exit 1;
fi

if [[ $action == 'build' ]]; then
  if [[ $ext == 'spec' ]] ; then
    /usr/bin/rm -r /opt/shared/build /opt/shared/dist 2>/dev/null
    /home/svc/.local/bin/pyinstaller $name
    /usr/bin/mv ./dist ./build /opt/shared
  else
    echo "Invalid file format"
    exit 1;
  fi
elif [[ $action == 'make' ]]; then
  if [[ $ext == 'py' ]] ; then
    /usr/bin/rm -r /opt/shared/build /opt/shared/dist 2>/dev/null
    /root/.local/bin/pyinstaller -F --name "qreader" $name --specpath /tmp
   /usr/bin/mv ./dist ./build /opt/shared
  else
    echo "Invalid file format"
    exit 1;
  fi
elif [[ $action == 'cleanup' ]]; then
  /usr/bin/rm -r ./build ./dist 2>/dev/null
  /usr/bin/rm -r /opt/shared/build /opt/shared/dist 2>/dev/null
  /usr/bin/rm /tmp/qreader* 2>/dev/null
else
  /usr/bin/echo 'Invalid action'
  exit 1;
fi









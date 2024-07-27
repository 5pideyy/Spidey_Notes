## Use Cases
- Audit the security aspects of networks
- Simulate penetration tests
- Check firewall and IDS settings and configurations
- Types of possible connections
- Network mapping
- Response analysis
- Identify open ports
- Vulnerability assessment as well.

## Nmap Architecture


- Host discovery
- Port scanning
- Service enumeration and detection
- OS detection
- Scriptable interaction with the target service (Nmap Scripting Engine)

## Syntax


```shell
nmap <scan types> <options> <target>
```




# Host Discovery


- actively ==discover== online systems in a network during pentest
- to determine whether our target is alive or not => **ICMP echo requests** (effective)


#### Scan Network Range

- host alive in a network

```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.0/24 -sn -oA tnet | grep for | cut -d" " -f5

10.129.2.4
10.129.2.10
10.129.2.11
10.129.2.18
10.129.2.19
10.129.2.20
10.129.2.28
```

- Now what is meant by "/24" [Click here](obsidian://open?vault=Spidey_Notes&file=NETWORKS%2FSUBNET)

|**Scanning Options**|**Description**|
|---|---|
|`10.129.2.0/24`|Target network range.|
|`-sn`|Disables port scanning.|
|`-oA tnet`|Stores the results in all formats starting with the name 'tnet'.|


- we Have bunch of ips we need to do port scan for all these hosts......How?

- save all these ip in a file 

```shell
pradyun2005@htb[/htb]$ cat hosts.lst

10.129.2.4
10.129.2.10
10.129.2.11
10.129.2.18
10.129.2.19
10.129.2.20
10.129.2.28
```


```shell
pradyun2005@htb[/htb]$ sudo nmap -sn -oA tnet -iL hosts.lst | grep for | cut -d" " -f5

10.129.2.18
10.129.2.19
10.129.2.20
```


|**Scanning Options**|**Description**|
|---|---|
|`-sn`|Disables port scanning.|
|`-oA tnet`|Stores the results in all formats starting with the name 'tnet'.|
|`-iL`|Performs defined scans against targets in provided 'hosts.lst' list.|


- may be because of firewall some packets are dropped


#### Scan Multiple Ip

- scans from `10.129.2.18` to `10.129.2.20`
```shell
nmap -sn -oA tnet 10.129.2.18-20| grep for | cut -d" " -f5
```



## Scan Single IP

- scan a single host for open ports and its services , first check host is alive or not


```shell-session
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.18 -sn -oA host 

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-14 23:59 CEST
Nmap scan report for 10.129.2.18
Host is up (0.087s latency).
MAC Address: DE:AD:00:00:BE:EF
Nmap done: 1 IP address (1 host up) scanned in 0.11 seconds
```

| **Scanning Options** | **Description**                                                  |
| -------------------- | ---------------------------------------------------------------- |
| `10.129.2.18`        | Performs defined scans against the target.                       |
| `-sn`                | Disables port scanning.                                          |
| `-oA host`           | Stores the results in all formats starting with the name 'host'. |

- Now `Ping` and `nmap -sn` do same???..
	- no,Ping only send and receive ICMP packets
	- `nmap -sn` sends ICMP packets,TCP-SYN flag,ARP ping etc..

- example ARP ping request
```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.18 -sn -oA host -PE --packet-trace 

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-15 00:08 CEST
SENT (0.0074s) ARP who-has 10.129.2.18 tell 10.10.14.2
RCVD (0.0309s) ARP reply 10.129.2.18 is-at DE:AD:00:00:BE:EF
Nmap scan report for 10.129.2.18
Host is up (0.023s latency).
MAC Address: DE:AD:00:00:BE:EF
Nmap done: 1 IP address (1 host up) scanned in 0.05 seconds
```

| **Scanning Options**           | **Description**                                                          |
| ------------------------------ | ------------------------------------------------------------------------ |
| `10.129.2.18`                  | Performs defined scans against the target.                               |
| `-sn`                          | Disables port scanning.                                                  |
| `-oA host`                     | Stores the results in all formats starting with the name 'host'.         |
| `-PE`                          | Performs the ping scan by using 'ICMP Echo requests' against the target. |
| `--packet-trace` or `--reason` | Shows all packets sent and received                                      |

- `--disable-arp-ping` to disable arp ping and use ICMP echo request (check with `--reason`)


# Host and Port Scanning

>**Use cases:**
   Open ports and its services
   Service versions
   Information that the services provided
   Operating system

## Discovering Open TCP Ports


-  specific port (`-p 22,25,80,139,445`), by range (`-p 22-445`)
- top ports (`--top-ports=10`)
- all ports (`-p-`)
- Top 100 ports (`-F`).

#### Nmap - Trace the Packets

```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -p 21 --packet-trace -Pn -n --disable-arp-ping

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-15 15:39 CEST
SENT (0.0429s) TCP 10.10.14.2:63090 > 10.129.2.28:21 S ttl=56 id=57322 iplen=44  seq=1699105818 win=1024 <mss 1460>
RCVD (0.0573s) TCP 10.129.2.28:21 > 10.10.14.2:63090 RA ttl=64 id=0 iplen=40  seq=0 win=0
Nmap scan report for 10.11.1.28
Host is up (0.014s latency).

PORT   STATE  SERVICE
21/tcp closed ftp
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 0.07 seconds
```


|**Scanning Options**|**Description**|
|---|---|
|`10.129.2.28`|Scans the specified target.|
|`-p 21`|Scans only the specified port.|
|`--packet-trace`|Shows all packets sent and received.|
|`-n`|Disables DNS resolution.|
|`--disable-arp-ping`|Disables ARP ping.|
#### Request

|**Message**|**Description**|
|---|---|
|`SENT (0.0429s)`|Indicates the SENT operation of Nmap, which sends a packet to the target.|
|`TCP`|Shows the protocol that is being used to interact with the target port.|
|`10.10.14.2:63090 >`|Represents our IPv4 address and the source port, which will be used by Nmap to send the packets.|
|`10.129.2.28:21`|Shows the target IPv4 address and the target port.|
|`S`|SYN flag of the sent TCP packet.|
|`ttl=56 id=57322 iplen=44 seq=1699105818 win=1024 mss 1460`|Additional TCP Header parameters.|

#### Response

|**Message**|**Description**|
|---|---|
|`RCVD (0.0573s)`|Indicates a received packet from the target.|
|`TCP`|Shows the protocol that is being used.|
|`10.129.2.28:21 >`|Represents targets IPv4 address and the source port, which will be used to reply.|
|`10.10.14.2:63090`|Shows our IPv4 address and the port that will be replied to.|
|`RA`|RST and ACK flags of the sent TCP packet.|
|`ttl=64 id=0 iplen=40 seq=0 win=0`|Additional TCP Header parameters.|

## Scan Techniques

### TCP-SYN scan (`-sS`)

- **SYN Flag**:
    - Contains randomly generated ISN.
    - Initiates TCP connection.

    - Sends one SYN packet.
    - Does not complete the three-way handshake.
    - **Responses**:
        - `SYN-ACK` => Port is **Open**.
        - `RST` => Port is **Closed**.
        - No response => Port is **Filtered** (possibly due to a firewall).
```shell
nmap -sS <target>
```


### TCP Connect Scan (`-sT`) 

1. **Three-Way Handshake**:
    
    - Uses TCP three-way handshake (SYN, SYN-ACK, ACK).
2. **Port States**:
    
    - **Open**: SYN-ACK response.
    - **Closed**: RST response.
3. **Accuracy**:
    
    - Most accurate for determining port state.
4. **Stealth**:
    
    - No unfinished connections or unsent packets.
    - Less likely to be detected by IDS/IPS.
5. **Polite**:
    
    - Minimal impact on target services.
    - Suitable for mapping networks without disruption.
6. **Firewall Bypass**:
    
    - Can bypass personal firewalls that drop incoming but allow outgoing packets.
7. **Speed**:
    
    - Slower due to waiting for responses.
    - May be affected by target's responsiveness.


```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -Pn -n --disable-arp-ping --packet-trace -p 445 --reason  -sV

Starting Nmap 7.80 ( https://nmap.org ) at 2022-11-04 11:10 GMT
SENT (0.3426s) TCP 10.10.14.2:44641 > 10.129.2.28:445 S ttl=55 id=43401 iplen=44  seq=3589068008 win=1024 <mss 1460>
RCVD (0.3556s) TCP 10.129.2.28:445 > 10.10.14.2:44641 SA ttl=63 id=0 iplen=44  seq=2881527699 win=29200 <mss 1337>
NSOCK INFO [0.4980s] nsock_iod_new2(): nsock_iod_new (IOD #1)
NSOCK INFO [0.4980s] nsock_connect_tcp(): TCP connection requested to 10.129.2.28:445 (IOD #1) EID 8
NSOCK INFO [0.5130s] nsock_trace_handler_callback(): Callback: CONNECT SUCCESS for EID 8 [10.129.2.28:445]
Service scan sending probe NULL to 10.129.2.28:445 (tcp)
NSOCK INFO [0.5130s] nsock_read(): Read request from IOD #1 [10.129.2.28:445] (timeout: 6000ms) EID 18
NSOCK INFO [6.5190s] nsock_trace_handler_callback(): Callback: READ TIMEOUT for EID 18 [10.129.2.28:445]
Service scan sending probe SMBProgNeg to 10.129.2.28:445 (tcp)
NSOCK INFO [6.5190s] nsock_write(): Write request for 168 bytes to IOD #1 EID 27 [10.129.2.28:445]
NSOCK INFO [6.5190s] nsock_read(): Read request from IOD #1 [10.129.2.28:445] (timeout: 5000ms) EID 34
NSOCK INFO [6.5190s] nsock_trace_handler_callback(): Callback: WRITE SUCCESS for EID 27 [10.129.2.28:445]
NSOCK INFO [6.5320s] nsock_trace_handler_callback(): Callback: READ SUCCESS for EID 34 [10.129.2.28:445] (135 bytes)
Service scan match (Probe SMBProgNeg matched with SMBProgNeg line 13836): 10.129.2.28:445 is netbios-ssn.  Version: |Samba smbd|3.X - 4.X|workgroup: WORKGROUP|
NSOCK INFO [6.5320s] nsock_iod_delete(): nsock_iod_delete (IOD #1)
Nmap scan report for 10.129.2.28
Host is up, received user-set (0.013s latency).

PORT    STATE SERVICE     REASON         VERSION
445/tcp open  netbios-ssn syn-ack ttl 63 Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
Service Info: Host: Ubuntu

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.55 seconds
```

| **Scanning Options** | **Description**                      |
| -------------------- | ------------------------------------ |
| `10.129.2.28`        | Scans the specified target.          |
| `-p 139`             | Scans only the specified port.       |
| `--packet-trace`     | Shows all packets sent and received. |
| `-n`                 | Disables DNS resolution.             |
| `--disable-arp-ping` | Disables ARP ping.                   |
| `-Pn`                | Disables ICMP Echo requests.         |
| `-sV`                | Performs a service scan.             |



## Nmap Aggressive Scan (-A)

#### Components 

1. **Service Version Detection (-sV):**
    
    - **Description:** Identifies the versions of services running on open ports.
    - **Usage:** Helps in finding vulnerabilities specific to certain versions.
    - **Example:** `nmap -sV <target>`
2. **OS Detection (-O):**
    
    - **Description:** Attempts to determine the operating system of the target machine.
    - **Usage:** Useful for understanding the target environment.
    - **Example:** `nmap -O <target>`
3. **Traceroute (--traceroute):**
    
    - **Description:** Maps the network path to the target.
    - **Usage:** Helps in identifying intermediate network devices and paths.
    - **Example:** `nmap --traceroute <target>`
4. **Default NSE Scripts (-sC):**
    
    - **Description:** Runs a set of default Nmap Scripting Engine (NSE) scripts.
    - **Usage:** Automates the detection of common vulnerabilities and gathers additional information.
    - **Example:** `nmap -sC <target>`




# Nmap Scripting Engine

- `nmap <target> --script <category>`

##### Category

|**Category**|**Description**|
|---|---|
|`auth`|Determination of authentication credentials.|
|`broadcast`|Scripts, which are used for host discovery by broadcasting and the discovered hosts, can be automatically added to the remaining scans.|
|`brute`|Executes scripts that try to log in to the respective service by brute-forcing with credentials.|
|`default`|Default scripts executed by using the `-sC` option.|
|`discovery`|Evaluation of accessible services.|
|`dos`|These scripts are used to check services for denial of service vulnerabilities and are used less as it harms the services.|
|`exploit`|This category of scripts tries to exploit known vulnerabilities for the scanned port.|
|`external`|Scripts that use external services for further processing.|
|`fuzzer`|This uses scripts to identify vulnerabilities and unexpected packet handling by sending different fields, which can take much time.|
|`intrusive`|Intrusive scripts that could negatively affect the target system.|
|`malware`|Checks if some malware infects the target system.|
|`safe`|Defensive scripts that do not perform intrusive and destructive access.|
|`version`|Extension for service detection.|
|`vuln`|Identification of specific vulnerabilities.|



# Firewall and IDS/IPS Evasion

### ==Decoy Scanning Method (`-D`)==

**Purpose:**  
Disguises the origin of the scan by inserting multiple fake IP addresses (decoys) into the IP header, making it difficult for the target to identify the true source of the scan.

#### Key Points:

- **Avoids Detection:**
    
    - Helps evade IDS/IPS and firewalls that block specific subnets or regions.
- **Generates Decoys:**
    
    - Creates multiple fake IP addresses to obscure the real source.

#### How It Works:

- **Random IP Addresses:**
    
    - Generates a specific number of random IP addresses.
    - The real IP address is mixed randomly among these decoys. 
- **Syntax:**
    
    - Use `-D RND:<number_of_decoys>` to generate random decoys.
    - Use `-D <decoy1>,<decoy2>,<decoy3>,<your_IP>` to specify exact decoys.
- **Example with Random Decoys:**
    
    - Generates 5 random decoys, with the real IP in the second position:
        

        
        `nmap -D RND:5 <target>`
        
- **Example with Specified Decoys:**
    
    - Uses specified decoys and places the real IP at a specific position:
        
        
        `nmap -D decoy1,decoy2,192.168.1.100,decoy3 <target>`
        

#### Critical Considerations:

- **Alive Decoys:**
    - Ensure decoy IP addresses are live (responsive) to avoid detection by SYN-flooding protections.
- **Position of Real IP:**
    - The real IP is randomly placed among the decoys, making tracking harder.

### Usage:

- **Purpose:**
    
    - To mask the origin of the scan.
    - Useful for bypassing regional or subnet-based access restrictions and evading security mechanisms.
```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -p 80 -sS -Pn -n --disable-arp-ping --packet-trace -D RND:5

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-21 16:14 CEST
SENT (0.0378s) TCP 102.52.161.59:59289 > 10.129.2.28:80 S ttl=42 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
SENT (0.0378s) TCP 10.10.14.2:59289 > 10.129.2.28:80 S ttl=59 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
SENT (0.0379s) TCP 210.120.38.29:59289 > 10.129.2.28:80 S ttl=37 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
SENT (0.0379s) TCP 191.6.64.171:59289 > 10.129.2.28:80 S ttl=38 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
SENT (0.0379s) TCP 184.178.194.209:59289 > 10.129.2.28:80 S ttl=39 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
SENT (0.0379s) TCP 43.21.121.33:59289 > 10.129.2.28:80 S ttl=55 id=29822 iplen=44  seq=3687542010 win=1024 <mss 1460>
RCVD (0.1370s) TCP 10.129.2.28:80 > 10.10.14.2:59289 SA ttl=64 id=0 iplen=44  seq=4056111701 win=64240 <mss 1460>
Nmap scan report for 10.129.2.28
Host is up (0.099s latency).

PORT   STATE SERVICE
80/tcp open  http
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 0.15 seconds
```

- in the above case `10.10.14.2` is our ip , it is mixed with decoy ip 



### ==Scan by Using Different Source IP==

```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -n -Pn -p 445 -O -S 10.129.2.200 -e tun0

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-22 01:16 CEST
Nmap scan report for 10.129.2.28
Host is up (0.010s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 3.2 - 4.9 (96%), Linux 2.6.32 - 3.10 (96%), Linux 3.4 - 3.10 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Synology DiskStation Manager 5.2-5644 (94%), Linux 2.6.32 - 2.6.35 (94%), Linux 2.6.32 - 3.5 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 4.11 seconds
```

- **Source IP Address (-S option):**
    
    - Specifies the source IP address for packets sent during the scan.
    - Does not assign an IP address to the specified interface.
- **Interface Selection (-e option):**
    
    - Specifies the network interface (`tun0`, `eth0`, etc.) for sending packets.
    - Requires the interface to be already configured with an IP address.
- **Example Command:**
    
    - `sudo nmap 10.129.2.28 -n -Pn -p 445 -O -S 10.129.2.200 -e tun0`
        - Uses `10.129.2.200` as the source IP address (`-S` option).
        - Specifies `tun0` as the network interface (`-e` option).
- **IP Address Assignment:**
    
    - `-S` option sets the source IP address for the scan.
    - `-e` option specifies the network interface for sending packets.
- **Effect on Scanning:**
    
    - Ensures packets are sent from the specified source IP (`-S`) through the specified interface (`-e`).
    - Does not configure or assign IP addresses to interfaces through Nmap itself.





### ==DNS Proxying with Nmap==

1. **Reverse DNS Resolution:**
    
    - Nmap defaults to performing reverse DNS resolution (`-n` to disable).
    - Helps identify hostnames associated with target IP addresses.
2. **DNS Queries and Ports:**
    
    - UDP Port 53: Used for standard DNS queries.
    - TCP Port 53: Traditionally for zone transfers, now more common due to IPv6 and DNSSEC.
3. **Specifying DNS Servers:**
    
    - `--dns-server <ns>,<ns>`: Specifies DNS servers for resolution.
    - Useful in DMZs for using trusted internal DNS servers (`--dns-server`).
4. **Use Cases:**
    
    - Secure Scans: Route queries through trusted DNS infrastructure.
    - Compliance: Ensure DNS requests align with internal security policies.
5. **Source Port Manipulation:**
    
    - `--source-port 53`: Sets TCP port 53 as the source port.
    - May bypass firewall rules that trust DNS traffic.
6. **Advantages:**
    
    - Trustworthiness: Internal DNS servers are more trusted than public ones.
    - Security: Helps in maintaining security posture during scans.



#### SYN-Scan of a Filtered Port
```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -p50000 -sS -Pn -n --disable-arp-ping --packet-trace

Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-21 22:50 CEST
SENT (0.0417s) TCP 10.10.14.2:33436 > 10.129.2.28:50000 S ttl=41 id=21939 iplen=44  seq=736533153 win=1024 <mss 1460>
SENT (1.0481s) TCP 10.10.14.2:33437 > 10.129.2.28:50000 S ttl=46 id=6446 iplen=44  seq=736598688 win=1024 <mss 1460>
Nmap scan report for 10.129.2.28
Host is up.

PORT      STATE    SERVICE
50000/tcp filtered ibm-db2

Nmap done: 1 IP address (1 host up) scanned in 2.06 seconds
```
#### SYN-Scan From DNS Port
```shell
pradyun2005@htb[/htb]$ sudo nmap 10.129.2.28 -p50000 -sS -Pn -n --disable-arp-ping --packet-trace --source-port 53

SENT (0.0482s) TCP 10.10.14.2:53 > 10.129.2.28:50000 S ttl=58 id=27470 iplen=44  seq=4003923435 win=1024 <mss 1460>
RCVD (0.0608s) TCP 10.129.2.28:50000 > 10.10.14.2:53 SA ttl=64 id=0 iplen=44  seq=540635485 win=64240 <mss 1460>
Nmap scan report for 10.129.2.28
Host is up (0.013s latency).

PORT      STATE SERVICE
50000/tcp open  ibm-db2
MAC Address: DE:AD:00:00:BE:EF (Intel Corporate)

Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds
```




# Firewall and IDS/IPS Evasion — Easy Lab

- OS (Operating System) identification can be done using SMB (Server Message Block) services
- use `--script smb-os-discovery`

```shell
nmap --script smb-os-discovery 10.129.2.80
```

# Firewall and IDS/IPS Evasion — Medium Lab

- to find out  target’s DNS server version
- port 53 is used for DNS services (`-sSU`) performs both TCP and UDP
- `--script dns-nsid` used for gather information from the DNS server.

```
sudo nmap -sSU -p53 10.129.249.220 --script dns-nsid

```

# Firewall and IDS/IPS Evasion - Hard Lab

- nmap shows 50000 port is open by specified 53 as source port
- we can grab the banner using nc to get more information from 53 (source port)

![[Pasted image 20240701191506.png]]

```shell
sudo nc -nv -p 53 10.129.2.47 50000  
```


# CHEETSHEETS

## Scanning Options

|**Nmap Option**|**Description**|
|---|---|
|`10.10.10.0/24`|Target network range.|
|`-sn`|Disables port scanning.|
|`-Pn`|Disables ICMP Echo Requests|
|`-n`|Disables DNS Resolution.|
|`-PE`|Performs the ping scan by using ICMP Echo Requests against the target.|
|`--packet-trace`|Shows all packets sent and received.|
|`--reason`|Displays the reason for a specific result.|
|`--disable-arp-ping`|Disables ARP Ping Requests.|
|`--top-ports=<num>`|Scans the specified top ports that have been defined as most frequent.|
|`-p-`|Scan all ports.|
|`-p22-110`|Scan all ports between 22 and 110.|
|`-p22,25`|Scans only the specified ports 22 and 25.|
|`-F`|Scans top 100 ports.|
|`-sS`|Performs an TCP SYN-Scan.|
|`-sA`|Performs an TCP ACK-Scan.|
|`-sU`|Performs an UDP Scan.|
|`-sV`|Scans the discovered services for their versions.|
|`-sC`|Perform a Script Scan with scripts that are categorized as "default".|
|`--script <script>`|Performs a Script Scan by using the specified scripts.|
|`-O`|Performs an OS Detection Scan to determine the OS of the target.|
|`-A`|Performs OS Detection, Service Detection, and traceroute scans.|
|`-D RND:5`|Sets the number of random Decoys that will be used to scan the target.|
|`-e`|Specifies the network interface that is used for the scan.|
|`-S 10.10.10.200`|Specifies the source IP address for the scan.|
|`-g`|Specifies the source port for the scan.|
|`--dns-server <ns>`|DNS resolution is performed by using a specified name server.|

## Output Options

|**Nmap Option**|**Description**|
|---|---|
|`-oA filename`|Stores the results in all available formats starting with the name of "filename".|
|`-oN filename`|Stores the results in normal format with the name "filename".|
|`-oG filename`|Stores the results in "grepable" format with the name of "filename".|
|`-oX filename`|Stores the results in XML format with the name of "filename".|

## Performance Options

| **Nmap Option**              | **Description**                                              |
| ---------------------------- | ------------------------------------------------------------ |
| `--max-retries <num>`        | Sets the number of retries for scans of specific ports.      |
| `--stats-every=5s`           | Displays scan's status every 5 seconds.                      |
| `-v/-vv`                     | Displays verbose output during the scan.                     |
| `--initial-rtt-timeout 50ms` | Sets the specified time value as initial RTT timeout.        |
| `--max-rtt-timeout 100ms`    | Sets the specified time value as maximum RTT timeout.        |
| `--min-rate 300`             | Sets the number of packets that will be sent simultaneously. |
| `-T <0-5>`                   | Specifies the specific timing template.                      |



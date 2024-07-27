- resolve domain name into ip
- FQDN : - `www.domain-A.com`
```HEIRARCHY
.
├── com.
│   ├── domain-A.
│   │   ├── blog.
│   │   ├── ns1.
│   │   └── www.
│   │ 
│   ├── domain-B.
│   │   └── ...
│   └── domain-C.
│       └── ...
│
└── net.
│   ├── domain-D.
│   │   └── ...
│   ├── domain-E.
│   │   └── ...
│   └── domain-F.
│       └── ...
└── ...
│   ├── ...
│   └── ...
```

![[Pasted image 20240609225001.png]]


- A FQDN conist of atleast two parts
	1) Top Level Domain (.com)
	2) Domain name (inlanefreight)
- In above Screenshot www,dev,mail are a single hosted subdomain or vHosts

# DNS Servers

- Recursive Resolvers (DNS Recursor)
- Root Name Server
- TLD Name Server
- Authoritative Name Servers

![[Pasted image 20240718191204.png]]


# DNS Resolution Process

```D
Client
  |
  | (1) Client Query: User types a domain name into their browser.
  v
Recursive Resolver
  |
  | (2) Cache Check: Checks if the requested IP address is in its cache.
  |
  +--- Cache Hit: IP address found in cache ------------------+
  |                                                           |
  |                                                           v
  |                                             Return IP Address to Client
  |
  +--- Cache Miss: IP address not found in cache
  |
  v
Root Name Server
  |
  | (3) Root Query: Queries one of the 13 root name servers.
  v
  | (4) Root Response: Responds with the address of the appropriate TLD name server.
  v
TLD Name Server
  |
  | (5) TLD Query: Queries the TLD name server for the domain.
  v
  | (6) TLD Response: Responds with the address of the authoritative name server.
  v
Authoritative Name Server
  |
  | (7) Authoritative Query: Queries the authoritative name server for the domain's IP address.
  v
  | (8) Authoritative Response: Responds with the requested IP address.
  v
Recursive Resolver
  |
  | (9) Cache Update: Updates its cache with the new IP address.
  v
Client
  |
  | (10) Client Response: Sends the IP address back to the client.
  v
Web Browser
```



```
                        +----------------+
                        | Root DNS       |
                        | Servers        |
                        +--------+-------+
                                 |
                                 | (1) Query for .in TLD NS records
                                 |
                        +--------v-------+
                        | .in TLD NS     |
                        | Servers        |
                        +--------+-------+
                                 |
                                 | (2) Query for kct.ac.in NS records
                                 |
                        +--------v-------+
                        | kct.ac.in      |
                        | Authoritative  |
                        | Name Servers   |
                        | - ns1.kct.ac.in|
                        | - ns2.kct.ac.in|
                        +--------+-------+
                           |       |
                           |       |
        +------------------|-------|------------------+
        |                  v       v                  |
+-------+--------------+ +-------+--------------+     |
| Primary NS (ns1)    | | Secondary NS (ns2) |     |
| at ns1.kct.ac.in    | | at ns2.kct.ac.in    |     |
| Zone File Example:  | | Zone File Example:  |     |
|                     | |                     |     |
| $ORIGIN kct.ac.in.  | | $ORIGIN kct.ac.in.  |     |
| @   IN  SOA  ns1.kct.ac.in. admin.kct.ac.in. (   |
|          2022071801 ; Serial                       |
|          3600       ; Refresh                      |
|          1800       ; Retry                        |
|          1209600    ; Expire                       |
|          86400 )    ; Minimum TTL                  |
|      IN  NS  ns1.kct.ac.in.                        |
|      IN  NS  ns2.kct.ac.in.                        |
|      IN  A   192.0.2.1 ; Example web server         |
|      IN  MX  10 mail.kct.ac.in.                    |
| www  IN  A   192.0.2.2 ; Example www server         |
| mail IN  A   192.0.2.3 ; Example mail server        |
+---------------------+ +---------------------+     |
                                                     |
                                                     |
                        +--------------------------+ |
                        | kct.ac.in DNS Records    | |
                        | (A, MX, etc.)            | |
                        +--------------------------+ |


```



# Zone Transfer
https://digi.ninja/projects/zonetransferme.php

#### Now what is meant by Zone files?

- stored information about domain Name server, SOA, DNS records
- zone files look like

```
$TTL 86400
@       IN      SOA     ns1.example.com. admin.example.com. (
                        2021071501 ; Serial
                        3600       ; Refresh
                        1800       ; Retry
                        1209600    ; Expire
                        86400 )    ; Minimum TTL

; Name servers for the domain
@       IN      NS      ns1.example.com.
@       IN      NS      ns2.example.com.

; IP address mappings
@       IN      A       192.0.2.1
@       IN      AAAA    2001:0db8:85a3:0000:0000:8a2e:0370:7334

; Mail server
@       IN      MX 10   mail.example.com.

; Aliases
www     IN      CNAME   example.com.

; Additional records
mail    IN      A       192.0.2.2
ftp     IN      A       192.0.2.3


```



- All name server contains Zone Files which do most of DNS process
### Purpose of Zone Transfer

- Ensures DNS information is synchronized across multiple servers to prevent failures.

### AXFR (Asynchronous Full Transfer Zone)

- Transfers DNS zone data between servers over TCP port 53.

### Primary and Secondary Servers

- **Primary Server:** Holds the original DNS records.
- **Secondary Server:** Holds a copy of the records for reliability and load distribution.

### Synchronization

- Changes on the primary server are copied to secondary servers to keep data consistent.

### Master and Slave Servers

- **Master Server:** Source of DNS data for synchronization.
- **Slave Server:** Fetches DNS data from the master.
- The primary server is always a master. A secondary can be both a slave (receiving data) and a master (providing data).

### How Synchronization Happens

- Slave fetches the SOA (Start of Authority) record from the master periodically.
- If the SOA serial number on the master is higher, the slave updates its data.
- to transfer the contents of zone files from primary NS secondary should Request AXFR request

### How Zone Transfer Works

![[Pasted image 20240718221422.png]]



```
dig axfr @nsztm1.digi.ninja zonetransfer.me
```

- asking zone transfer from the nameserver `nsztm1.digi.ninja` for the domain `zonetransfer.me`

```
       +-------------------+                +-------------------+
       |   Secondary       |                |                   |
       |     (my pc)       |                |   Primary         |
       |     Server        |                |     Server        |
       +-------------------+                +-------------------+
                   |                                |
                   |          AXFR Request          |  
                   |  (dig axfr @nsztm1.digi.ninja) |   
                   |-------------------------------->|
                   |                                |
                   |          SOA Record            | 
                   |  (zonetransfer.me zone data)   |
                   |<-------------------------------|
                   |                                |
                   |          DNS Records           |
                   |  (zonetransfer.me zone data)   |
                   |<-------------------------------|
                   |          (loop)                |
                   |-------------------------------->|
                   |                                |
                   |        End of Records          |
                   |<-------------------------------|
                   |                                |
                   |     Zone Transfer Complete     |
                   |-------------------------------->|
                   |                                |
                   |           ACK                  |
                   |<-------------------------------|
```


\


## Setting up in Linux


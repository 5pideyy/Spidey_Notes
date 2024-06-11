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



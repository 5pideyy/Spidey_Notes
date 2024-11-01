
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

- Each domain has a DNS nam
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







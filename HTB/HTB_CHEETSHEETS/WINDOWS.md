
## SMB
### smbclient
- Connecting to server and Listing shares
```shell-session
smbclient -N -L //10.129.14.128
```
- connect to a share
```shell-session
smbclient //10.129.14.128/notes
```
- Download Files
```shell-session
get prep-prod.txt 
```
- execute local system commands
```
!<cmd>
```

### smbmap

```
smbmap -H <IP> 
smbmap -H <IP> -u '' -p '' # Enumerate samba share drives across a domain 
smbmap -H <IP> -s <Share name>
```

### crackmapexec

```
crackmapexec smb <IP> -u '' -p '' --shares 
crackmapexec smb <IP> -u 'sa' -p '' --shares 
crackmapexec smb <IP> -u 'sa' -p 'sa' --shares 
crackmapexec smb <IP> -u '' -p '' --share <Share name>
```





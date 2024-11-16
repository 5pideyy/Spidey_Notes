

# **Checking File permissions** 

- in linux ls -lah is used to check file permissions , similarly in windows to specific permissions over a file or folder

```cmd-session
C:\htb> icacls c:\windows
c:\windows NT SERVICE\TrustedInstaller:(F)
           NT SERVICE\TrustedInstaller:(CI)(IO)(F)
           NT AUTHORITY\SYSTEM:(M)
           NT AUTHORITY\SYSTEM:(OI)(CI)(IO)(F)
           BUILTIN\Administrators:(M)
           BUILTIN\Administrators:(OI)(CI)(IO)(F)
           BUILTIN\Users:(RX)
           BUILTIN\Users:(OI)(CI)(IO)(GR,GE)
           CREATOR OWNER:(OI)(CI)(IO)(F)
           APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES:(RX)
           APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES:(OI)(CI)(IO)(GR,GE)
           APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES:(RX)
           APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES:(OI)(CI)(IO)(GR,GE)

Successfully processed 1 files; Failed processing 0 files
```

>- `F` : full access
>- `D` :  delete access
>- `N` :  no access
>- `M` :  modify access
>- `RX` :  read and execute access
>- `R` :  read-only access
>- `W` :  write-only access


- using iclas we can set and change permissions




#### Current Location

Linux : `pwd`
windows : `Get-Location`

#### List in dir

Linux : `ls`
Windows : `Get-ChildItem `

#### Move to a New Directory

Linux : `cd /home`
Windows : `Set-Location .\Documents\`

#### Display Contents of a File

Linux  : `cat README.md`
Windows : `Get-Content Readme.md  `

#### History

Linux : `history`
windows : `Get-History`




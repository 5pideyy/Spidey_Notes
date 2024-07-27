- Session -> keep track of user information
- http stateless communication protocol uses session

- attacker got session of victim then can use victim accounts
- ==how attacker get session of victim?==
	-  Captured through passive traffic/packet sniffing
	- Identified in logs
	- Predicted
	- Brute Forced


### session identifier's security

- `Validity Scope` ( valid for one session )
- `Randomness` ( robust random number/string)
- `Validity Time` (expire after a certain amount of time)

**location where it is stored**

- URL
- HTML
- sessionStorage
- localStorage

|Feature|sessionStorage|localStorage|
|---|---|---|
|Scope|Specific to the tab or window|Shared across all tabs and windows|
|Lifespan|Cleared when the tab or window is closed|Persists until explicitly deleted|
|Page Reloads|Data survives page reloads/restores|Data survives page reloads/restores|
|Use Case|Temporary data (per session)|Persistent data (across sessions)|
|Size Limit|Typically around 5-10 MB per origin|Typically around 5-10 MB per origin|



## Possible Attacks

- XSS
- Session Hijack(get victim session id and use to login)
- Session Fixation(**Attacker sets session ID `1234` → Victim logs in with session ID `1234` → Attacker uses session ID `1234` to access victim's account**)
- CSRF (Cross-Site Request Forgery)
- Open Redirects


### SESSION FIXATION

- **obtain a valid session_id**
	1) valid session assigned when browsing website ==NO AUTHN REQUIRED ==
	2) obtain session ==after authenticated==
- **fixate a valid session identifier**
	1) session identifier ==pre-login remains the same post-login==
	2) session identifier ==accepted via URL or POST data==
- **establishing a session & trick victim** 
	1) construct url with session and make login
	2) attacker login with Fixated session

- Vulnerable PHP code
```php
<?php
    if (!isset($_GET["token"])) {
        session_start();
        header("Location: /?redirect_uri=/complete.html&token=" . session_id());
    } else {
        setcookie("PHPSESSID", $_GET["token"]);
    }
?>
``` 


### SESSION OBTAIN WITHOUT USER INTERACTION


- attacker and victim in same network
- HTTP without encryption 


==SNIFF TRAFFIC USING WIRESHARK== => Obtain Session id


#### POST EXPLOITATION

```shell-session
locate php.ini
cat /etc/php/7.4/cli/php.ini | grep 'session.save_path'
cat /etc/php/7.4/apache2/php.ini | grep 'session.save_path'
```


- In PHP , Default `/var/lib/php/sessions`
- In JAVA , Default path specified in `SESSIONS.ser`
or
- In DB



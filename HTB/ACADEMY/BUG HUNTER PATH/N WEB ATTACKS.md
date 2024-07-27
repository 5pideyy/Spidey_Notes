

# HTTP Verb Tampering

-  HTTP methods as `verbs`

|Verb|Description|
|---|---|
|`HEAD`|Identical to a GET request, but its response only contains the `headers`, without the response body|
|`PUT`|Writes the request payload to the specified location|
|`DELETE`|Deletes the resource at the specified location|
|`OPTIONS`|Shows different options accepted by a web server, like accepted HTTP verbs|
|`PATCH`|Apply partial modifications to the resource at the specified location|
## Insecure Configurations


```xml
<Limit GET POST>
    Require valid-user
</Limit>
```

- requires authentication only for GET and POST
-  `HEAD` to bypass this authentication mechanism altogether





## Bypassing Basic Authentication

- **Check both GET and POST methods to ensure they are not bypassed.**
- **Use the OPTIONS method to see which request methods are accepted by the server.**
- **Use the HEAD method to potentially bypass authentication.**

### Example Scenario
![[Pasted image 20240615152237.png]]

1. **Authentication Required for Reset**
	![[Pasted image 20240615145048.png]]
    - URL: `http://94.237.51.149:34391/admin/reset.php` requires authentication.
        - 
2. **Authentication Implemented for GET and POST**
    
    - Both GET and POST requests require authentication.
        - ![[Pasted image 20240615145400.png]]
        - ![[Pasted image 20240615145433.png]]
3. **Using OPTIONS to Check Accepted Methods**
    
    - Check accepted request methods using OPTIONS.
        - ![[Pasted image 20240615150036.png]]
        - ![[Pasted image 20240615150643.png]]



## Bypassing Security Filters

-  caused by `Insecure Coding`

	 **Insecure Coding**
	
	```php
	$pattern = "/^[A-Za-z\s]+$/";
	
	if(preg_match($pattern, $_GET["code"])) {
	    $query = "Select * from ports where port_code like '%" . $_REQUEST["code"] . "%'";
	    ...SNIP...
	}
	```
	- The developer sanitizes the `code` parameter in GET requests to prevent SQL injection.
	- If the `code` parameter in the GET request does not contain harmful characters, the query is executed.
	- The query is executed using the `_REQUEST` method, which can handle both GET and POST requests.
	- Only the `code` parameter from GET requests is sanitized, leaving POST requests vulnerable to SQL injection.
	




### Example

1. **Initial POST Request**
    
    - Using the file name `test;` in a POST request to add files:
    - ![[Pasted image 20240615151203.png]]
    - The request is successful. (Malicious Request Denied)
2. **Changing to GET Request**
    
    - Change the request method to GET:
    - ![[Pasted image 20240615151348.png]]
    - ![[Pasted image 20240615151428.png]]
    - The request does not receive a `Malicious Request Denied!` response.
3. **Command Injection Attempt**
    
    - Attempt to inject a command: `file1; touch file2;`:
    - ![[Pasted image 20240615151515.png]]
    - Both files (`file1` and `file2`) are created:
    - ![[Pasted image 20240615151528.png]]

	- `test;cp /flag.txt ./ `
	- ![[Pasted image 20240615152734.png]]



## Verb Tampering Prevention


### Insecure Configuration

**Apache web server Configuration**

```xml
<Directory "/var/www/html/admin">
    AuthType Basic
    AuthName "Admin Panel"
    AuthUserFile /etc/apache2/.htpasswd
    <Limit GET>
        Require valid-user
    </Limit>
</Directory>
```

- **Configuration Issue**: `<Limit GET>` only restricts GET requests.
- **Vulnerability**: The page remains accessible via POST requests.
- **Partial Restriction**: Even if `<Limit GET POST>` is used, other methods (HEAD, OPTIONS) are not restricted.

**Tomcat web server configuration**

```xml
<security-constraint>
    <web-resource-collection>
        <url-pattern>/admin/*</url-pattern>
        <http-method>GET</http-method>
    </web-resource-collection>
    <auth-constraint>
        <role-name>admin</role-name>
    </auth-constraint>
</security-constraint>
```

- restricted only to the GET method using `<Limit GET>`.



### Insecure Coding


```php
	if (isset($_REQUEST['filename'])) {
    if (!preg_match('/[^A-Za-z0-9. _-]/', $_POST['filename'])) {
        system("touch " . $_REQUEST['filename']);
    } else {
        echo "Malicious Request Denied!";
    }
}
	```
- The developer sanitizes the `filename` parameter in POST requests to prevent command injection.
- If the `filename` parameter in the POST request does not contain harmful characters, the command is executed.
- The command is executed using the `_REQUEST` method, which can handle both GET and POST requests.
- Only the `filename` parameter from POST requests is sanitized, leaving GET requests vulnerable to command injection.
	
|Language|Function|
|---|---|
|PHP|`$_REQUEST['param']`|
|Java|`request.getParameter('param')`|
|C#|`Request['param']`|


## Insecure Direct Object References (IDOR)



### Insecure Parameters

```
http://SERVER_IP:PORT/documents.php?uid=1
```

- uid is vulnerable to idor

- this link let us to download employee documents


## Mass Enumeration


- enumerate and find out available datas using idor

### Example

This page allows us to fetch documents by using:





```
http://SERVER_IP:PORT/documents.php?uid=2
```

#### Sample HTML Response





```
<li class='pure-tree_link'><a href='/documents/Invoice_3_06_2020.pdf' target='_blank'>Invoice</a></li> <li class='pure-tree_link'><a href='/documents/Report_3_01_2020.pdf' target='_blank'>Report</a></li>
```

#### Extracting Document Links with cURL and grep





```
curl -s "http://SERVER_IP:PORT/documents.php?uid=3" | grep -oP "\/documents.*?.pdf"
```

#### Shell Script to Download All Documents




```
#!/bin/bash  url="http://SERVER_IP:PORT"  for i in {1..10}; do     for link in $(curl -s "$url/documents.php?uid=$i" | grep -oP "\/documents.*?.pdf"); do         wget -q $url/$link     done done
```








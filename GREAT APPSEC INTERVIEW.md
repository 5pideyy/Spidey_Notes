
AS LIKE HACKTHEBOX MACHINES , AT FIRST I STARTED RECON WITH PORT SCANNING USING NMAP `-p` , i found out 4 main open ports consist of graphql,apache runnig in it. 

fired up dirsearch  tool to fuzz for directories in port 80, found intersting directories and files 
- config.txt
- swagger.json
- resource/img
- phpmyadmin
- developer.json 

and then fired up burpsuite and walkthrough complete website to fill up the sitemap which can be easier to keep trackof
### SSL cert

encrypted flag in ssl cert with zigzag encryption

### SHELL SHOCK 
upon inspecting each services , got `shocking` keyword since it also apache that may be shell shock vulnerability (command injection), a cgi endpoint found in comment of soruce code using exploit db and found flag in /follow dir


### Flag what does the database do ?

- when visiting /config.txt 
- ./IMPORTANTDATABSEHERE found
- upon visiting this directory got the flag

### Directory listing

- resource/img got directory listing which reveals `secret` directory has flag.html 
- flag found in source code


### phpmyadmin

- trying default creds in login page 
- flag in users table (need to export to view full flag)



### API flag

- swagger.json gives information about all api endpoints
- retriving user info give the flag


### Insecure deserialization

- visiting shutdown.php 2 cookie is set one with file path cat /etc/flag/1.txt and php cookie(which has some file)
- upon changing file to /etc/flag/1.txt and string length updated i got flag


### SQLi

- found sqli in /API/users/complaintupdate.php
- when i dumped the complete db where i found two flags sqli , and ssti flag as well encrypted password of admin,technitian and other users too







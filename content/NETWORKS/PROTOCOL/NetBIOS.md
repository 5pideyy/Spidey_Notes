- Network Basic Input/Output System
	- **Name Service**: Registers and resolves NetBIOS names to IP addresses.
	- **Session Service**: Manages the establishment and termination of sessions for reliable communication.
	- **Datagram Service**: Supports connectionless communication for sending and receiving messages.


```
[SALES-PC] ---- "Who is HR-PC?" (Name Query, UDP port 137) ----> Broadcast
           <---- "I am HR-PC, IP: 192.168.1.2" <---- [HR-PC]

[SALES-PC] ---- "Let's start a session" (Session Request, TCP port 139) ----> [HR-PC]
           <---- "Session started" (Session Acknowledgment, TCP port 139) <---- [HR-PC]

[SALES-PC] ---- "Sending file..." (File Transfer, TCP port 139) ----> [HR-PC]
           <---- "File received" (TCP port 139) <---- [HR-PC]

[SALES-PC] ---- "Terminate session" (TCP port 139) ----> [HR-PC]
           <---- "Session terminated" (TCP port 139) <---- [HR-PC]

```



Now why to broadcast name query??? 

instead have a Nameserver thats called NetBIOS Name Server (**NBNS**) or Windows Internet Name Service (**WINS**)






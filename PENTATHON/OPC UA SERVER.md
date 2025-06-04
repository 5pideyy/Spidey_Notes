---
share_link: https://share.note.sx/5kk123c9#epTbnM7lzoy+jt5SQEh9fPRXrB25FwUHhB9diz8vewo
share_updated: 2025-05-06T18:57:28+05:30
---


```
┌──(pradyun㉿NOVA)-[~] └─$ sudo nmap -p 1-65535 192.168.112.97 [sudo] password for pradyun: Starting Nmap 7.95 ( https://nmap.org ) at 2025-05-03 08:57 IST Nmap scan report for 192.168.112.97 Host is up (0.012s latency). Not shown: 65529 closed tcp ports (reset) PORT STATE SERVICE 21/tcp open ftp 22/tcp open ssh 1881/tcp open ibm-mqseries2 4840/tcp open opcua-tcp 5000/tcp open upnp 6060/tcp open x11 MAC Address: 2C:CF:67:EE:EE:23 (Raspberry Pi (Trading)) Nmap done: 1 IP address (1 host up) scanned in 57.13 seconds
```


- as we know `4840/tcp open opcua-tcp` which is OPC UA service

>OPC UA : Centralized data hub, providing all the operational data from machines, sensors, and systems.

- here each node has a piece of data

- now lets , enumerate the nodes which are in OPC UA

- i have written a python script using `asyncua` module

```
import asyncio
from asyncua import Client

async def explore_children(node, indent=0):
    children = await node.get_children()
    for child in children:
        browse_name = await child.read_browse_name()
        print("  " * indent + f"- {browse_name.Name}")
        await explore_children(child, indent + 1)

async def main():
    url = "opc.tcp://192.168.112.97:4840/freeopcua/server/"
    async with Client(url=url) as client:
        print("[+] Connected to OPC UA Server")
        root = client.get_root_node()
        objects = await root.get_child(["0:Objects"])
        print("[*] Browsing OPC UA Object Tree:")
        await explore_children(objects)

if __name__ == "__main__":
    asyncio.run(main())

```

- and there is more nodes...
![[Pasted image 20250503120241.png]]

- here i can see , auditing details such as permissions , sensor datas , server configuration , server capabilities etc..

- no i have used UA Expert tool to analyse the nodes, after i connected with the server in plant node heirarchy i have found flag

![[Pasted image 20250503120713.png]]




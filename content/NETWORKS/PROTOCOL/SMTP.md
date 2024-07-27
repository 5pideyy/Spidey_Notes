**Simple Mail Transfer Protocol (SMTP)** is a protocol for sending emails across an IP network. It's used in two main scenarios:

1. Between an email client and an outgoing mail server.
2. Between two SMTP servers.


### Working

SMTP is a client-server protocol, where:

- The client sends an email to the server.
- The server processes and forwards the email to the recipient's mail server.


### RETRIEVING MAIL

- **IMAP** allows users to read emails from multiple devices, as it keeps emails on the server.
- **POP3** downloads emails to a local device and usually deletes them from the server.



```
  Alice's Email Client (SMTP Client)
          |
          v
   smtp.example.com (SMTP Server)
          |
          v
   smtp.anotherdomain.com (SMTP Server)
          |
          v
   imap.anotherdomain.com (IMAP Server) or pop3.anotherdomain.com (POP3 Server)
          |
          v
   Bob's Email Client (IMAP/POP3 Client)

```




```

1. Alice Sends an Email (SMTP Client to SMTP Server)
----------------------------------------------------

Alice's Email Client (SMTP Client)
+---------------------------+
| Compose Email to          |
| bob@anotherdomain.com     |
| ------------------------- |
| [ Send ]                  |
+---------------------------+
          |
          v
2. Email is Sent to Alice's Outgoing Mail Server (SMTP Server)
--------------------------------------------------------------
Alice's SMTP Server (smtp.example.com)
+---------------------------+
| smtp.example.com          |
| (SMTP Server)             |
|                           |
| +-----------------------+ |
| | Receive email from    | |
| | Alice's email client  | |
| +-----------------------+ |
|                           |
| 3. Server-to-Server       |
|    Communication          |
| +-----------------------+ |
| | Send email to         | |
| | smtp.anotherdomain.com| |
| +-----------------------+ |
+---------------------------+
          |
          v
3. SMTP Server-to-Server Communication
--------------------------------------
Bob's SMTP Server (smtp.anotherdomain.com)
+---------------------------+
| smtp.anotherdomain.com    |
| (SMTP Server)             |
|                           |
| +-----------------------+ |
| | Receive email from    | |
| | smtp.example.com      | |
| +-----------------------+ |
|                           |
| 4. Store email for        |
|    bob@anotherdomain.com  |
| +-----------------------+ |
| | Save email to         | |
| | inbox folder          | |
| +-----------------------+ |
+---------------------------+
          |
          v
4. Bob Retrieves the Email (IMAP/POP3 Server to Client)
-------------------------------------------------------
IMAP Server (imap.anotherdomain.com)
or
POP3 Server (pop3.anotherdomain.com)
+---------------------------+
| imap.anotherdomain.com    |
| (IMAP Server)             |
| - or -                    |
| pop3.anotherdomain.com    |
| (POP3 Server)             |
|                           |
| +-----------------------+ |
| | Store and manage      | |
| | emails                | |
| +-----------------------+ |
|                           |
| 5. Fetch email for Bob    |
| +-----------------------+ |
| | IMAP/POP3 Client      | |
| +-----------------------+ |
+---------------------------+
          |
          v
5. Bob's Email Client Retrieves Email
-------------------------------------
Bob's Email Client (IMAP/POP3 Client)
+---------------------------+
| Open Email Client         |
| ------------------------- |
| [ Fetch Emails ]          |
| +-----------------------+ |
| | Connect to IMAP/POP3  | |
| | Server and download   | |
| | emails                | |
| +-----------------------+ |
|                           |
| 6. Read Email from Alice  |
| +-----------------------+ |
| | Display email from    | |
| | alice@example.com     | |
| +-----------------------+ |
+---------------------------+


```


## EXAMPLE

pradyun@gmail.com to pradyun.22ec@kct.ac.in


```
1. Pradyun Sends Email
----------------------

Pradyun's Email Client (e.g., Gmail Web Interface)
+---------------------------+
| Compose and Send Email to |
| pradyun.22ec@kct.ac.in    |
|---------------------------|
|           |               |
|          SMTP             |
|           v               |
+---------------------------+

2. Email is Sent to Gmail's Outgoing Mail Server
------------------------------------------------
Gmail's SMTP Server (smtp.gmail.com)
+---------------------------+
| Receive email from        |
| Pradyun's email client    |
|---------------------------|
|           |               |
|          SMTP             |
|           v               |
+---------------------------+

3. Server-to-Server Communication
---------------------------------
KCT's SMTP Server (smtp.kct.ac.in)
+---------------------------+
| Receive email from Gmail's|
| SMTP server               |
|---------------------------|
|           |               |
|           v               |
+---------------------------+
| Store email for           |
| pradyun.22ec@kct.ac.in    |
+---------------------------+
          |
          v
4. Pradyun Retrieves the Email
------------------------------
KCT's IMAP/POP3 Server (imap.kct.ac.in or pop3.kct.ac.in)
+---------------------------+
| Retrieve email from KCT's |
| IMAP/POP3 server          |
|---------------------------|
|           |               |
|           v               |
+---------------------------+
| Pradyun reads email from  |
| pradyun@gmail.com         |
+---------------------------+

```



## HOW GMAIL WORKS 


1. **Login and Authentication**:
    
    - You enter your credentials on the Gmail login page.
    - Google’s authentication system checks your credentials and logs you into your account if they are correct.
2. **Accessing the Mailbox**:
    
    - Once logged in, you are presented with the Gmail web interface.
    - The web interface uses IMAP to access your mailbox, fetch emails, and display them.
3. **Sending an Email**:
    
    - When you compose and send an email through the web interface, Gmail uses SMTP to send the email.
    - The web client communicates with the SMTP server (`smtp.gmail.com`) to send the email to the recipient’s mail server.
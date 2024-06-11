HTTP FLOW
![[Pasted image 20240607122009.png]]
- first look up records in the local '`/etc/hosts`' file



HTTPS FLOW
![[Pasted image 20240607123210.png]]


HTTP REQUEST
![[Pasted image 20240607123016.png]]

HTTPS REQUEST
![[Pasted image 20240607123028.png]]


- the request may still reveal the visited URL if it contacted a clear-text DNS server
- it is recommended to utilize encrypted DNS servers (e.g. 8.8.8.8 or 1.1.1.1), or utilize a VPN service to ensure all traffic is properly encrypted.


- If we type http:// insted of https:// request sent to port 80(unencrypted HTTP protocol) =>server detects this and redirects the client to secure HTTPS port `443`

**Note:** Depending on the circumstances, an attacker may be able to perform an HTTP downgrade attack, which downgrades HTTPS communication to HTTP, making the data transferred in clear-text. This is done by setting up a Man-In-The-Middle (MITM) proxy to transfer all traffic through the attacker's host without the user's knowledge. However, most modern browsers, servers, and web applications protect against this attack.


- to get complete response use curl -vvv



### HTTP HEADERS

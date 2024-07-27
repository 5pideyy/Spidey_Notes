
- [SSRF in Exchange leads to ROOT access in all instances](https://hackerone.com/reports/341876)
- [Remote Code Execution in Slack desktop apps + bonus](https://hackerone.com/reports/783877)
- [Full name of other accounts exposed through NR API Explorer (another workaround of #476958)](https://hackerone.com/reports/520518)
- [A staff member with no permissions can edit Store Customer Email](https://hackerone.com/reports/980511)
- [XSS while logging in using Google](https://hackerone.com/reports/691611)
- [Cross-site Scripting (XSS) on HackerOne careers page](https://hackerone.com/reports/474656)








# Reporting Stored XSS


`Title`: Stored Cross-Site Scripting (XSS) in X Admin Panel

`CWE`: [CWE-79: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')](https://cwe.mitre.org/data/definitions/79.html)

`CVSS 3.1 Score`: 5.5 (Medium)

`Description`: During our testing activities, we identified that the "X for administrators" web application is vulnerable to stored cross-site scripting (XSS) attacks due to inadequate sanitization of user-supplied data. Specifically, the file uploading mechanism at "Admin Info" -> "Secure Data Transfer" -> "Load of Data" utilizes a value obtained from user input, specifically the uploaded file's filename, which is not only directly reflected back to the user’s browser but is also stored into the web application’s database. However, this value does not appear to be adequately sanitized. It, therefore, results in the application being vulnerable to reflected and stored cross-site scripting (XSS) attacks since JavaScript code can be entered in the filename field.

`Impact`: Cross-Site Scripting issues occur when an application uses untrusted data supplied by offensive users in a web browser without sufficient prior validation or escaping. A potential attacker can embed untrusted code within a client-side script to be executed by the browser while interpreting the page. Attackers utilize XSS vulnerabilities to execute scripts in a legitimate user's browser leading to user credentials theft, session hijacking, website defacement, or redirection to malicious sites. Anyone that can send data to the system, including administrators, are possible candidates for performing XSS attacks against the vulnerable application. This issue introduces a significant risk since the vulnerability resides in the "X for administrators” web application, and the uploaded files are visible and accessible by every administrator. Consequently, any administrator can be a possible target of a Cross-Site Scripting attack.

`POC`:

Step 1: A malicious administrator could leverage the fact that the filename value is reflected back to the browser and stored in the web application’s database to perform cross-site scripting attacks against other administrators by uploading a file containing malicious JavaScript code into its filename. The attack is feasible because administrators can view all uploaded files regardless of the uploader. Specifically, we named the file, as follows, using a Linux machine.

Code: javascript

```javascript
"><svg onload = alert(document.cookie)>.docx
```

![image](https://academy.hackthebox.com/storage/modules/161/2.png)

Step 2: When another administrator clicks the view button to open the abovementioned file, the malicious JavaScript code in the file’s filename will be executed on the browser.

![image](https://academy.hackthebox.com/storage/modules/161/3.png) ![image](https://academy.hackthebox.com/storage/modules/161/4.png)

---

## CVSS Score Breakdown


  

||
|---|
|`Attack Vector:`|Network - The attack can be mounted over the internet.|
|`Attack Complexity:`|Low - All the attacker (malicious admin) has to do is specify the XSS payload eventually stored in the database.|
|`Privileges Required:`|High - Only someone with admin-level privileges can access the admin panel.|
|`User Interaction:`|None - Other admins will be affected simply by browsing a specific (but regularly visited) page within the admin panel.|
|`Scope:`|Changed - Since the vulnerable component is the webserver and the impacted component is the browser|
|`Confidentiality:`|Low - Access to DOM was possible|
|`Integrity:`|Low - Through XSS, we can slightly affect the integrity of an application|
|`Availability:`|None - We cannot deny the service through XSS|



# Reporting CSRF

---

`Title`: Cross-Site Request Forgery (CSRF) in Consumer Registration

`CWE`: [CWE-352: Cross-Site Request Forgery (CSRF)](https://cwe.mitre.org/data/definitions/352.html)

`CVSS 3.1 Score`: 5.4 (Medium)

`Description`: During our testing activities, we identified that the web page responsible for consumer registration is vulnerable to Cross-Site Request Forgery (CSRF) attacks. Cross-Site Request Forgery (CSRF) is an attack where an attacker tricks the victim into loading a page that contains a malicious request. It is malicious in the sense that it inherits the identity and privileges of the victim to perform an undesired function on the victim's behalf, like change the victim's e-mail address, home address, or password, or purchase something. CSRF attacks generally target functions that cause a state change on the server but can also be used to access sensitive data.

`Impact`: The impact of a CSRF flaw varies depending on the nature of the vulnerable functionality. An attacker could effectively perform any operations as the victim. Because the attacker has the victim's identity, the scope of CSRF is limited only by the victim's privileges. Specifically, an attacker can register a fintech application and create an API key as the victim in this case.

`POC`:

Step 1: Using an intercepting proxy, we looked into the request to create a new fintech application. We noticed no anti-CSRF protections being in place.

![image](https://academy.hackthebox.com/storage/modules/161/5.png) ![image](https://academy.hackthebox.com/storage/modules/161/6.png)

Step 2: We used the abovementioned request to craft a malicious HTML page that, if visited by a victim with an active session, a cross-site request will be performed, resulting in the advertent creation of an attacker-specific fintech application.

![image](https://academy.hackthebox.com/storage/modules/161/7.png)

Step 3: To complete the attack, we would have to send our malicious web page to a victim having an open session. The following image displays the actual cross-site request that would be issued if the victim visited our malicious web page.

![image](https://academy.hackthebox.com/storage/modules/161/8.png)

Step 4: The result would be the inadvertent creation of a new fintech application by the victim. It should be noted that this attack could have taken place in the background if combined with finding 6.1.1. <-- 6.1.1 was an XSS vulnerability.

![image](https://academy.hackthebox.com/storage/modules/161/9.png)

---

## CVSS Score Breakdown

|||
|---|---|
|`Attack Vector:`|Network - The attack can be mounted over the internet.|
|`Attack Complexity:`|Low - All the attacker has to do is trick a user that has an open session into visiting a malicious website.|
|`Privileges Required:`|None - The attacker needs no privileges to mount the attack.|
|`User Interaction:`|Required - The victim must click a crafted link provided by the attacker.|
|`Scope:`|Unchanged - Since the vulnerable component is the webserver and the impacted component is again the webserver.|
|`Confidentiality:`|Low - The attacker can create a fintech application and obtain limited information.|
|`Integrity:`|Low - The attacker can modify data (create an application) but limitedly and without seriously affecting the vulnerable component's integrity.|
|`Availability:`|None - The attacker cannot perform a denial-of-service through this CSRF attack.|


# Reporting RCE

---

`Title`: IBM WebSphere Java Object Deserialization RCE

`CWE`: [CWE-502: Deserialization of Untrusted Data](https://cwe.mitre.org/data/definitions/502.html)

`CVSS 3.1 Score`: 9.8 (Critical)

`Description`: During our testing activities, we identified that the remote WebSphere application server is affected by a vulnerability related to insecure Java object deserialization allowing remote attackers to execute arbitrary commands. By issuing a request to the remote WebSphere application server over HTTPS on port 8880, we identified the existence of raw, serialized Java objects that were base64-encoded. It is possible to identify base64 encoded serialized Java objects by the "rO0" header. We were able to craft a SOAP request containing a serialized Java object that can exploit the aforementioned vulnerability in the Apache Commons Collections (ACC) library used by the WebSphere application server. The crafted Java object contained a `ping` command to be executed by the affected system.

`Impact`: Command injection vulnerabilities typically occur when data enters the application from an untrusted source, such as a terminal or a network socket, without authenticating the source, or the data is part of a string that is executed as a command by the application, again without validating the input against a predefined list of allowed commands, such as a whitelist. The application executes the provided command under the current user's security context. If the application is executed as a privileged user, administrative or driver interface, such as the SYSTEM account, it can potentially allow the complete takeover of the affected system.

`POC`:

Step 1: We identified that the application uses serialized data objects by capturing and decoding a request to port 8880 of the server. The following images display the original request and the remote server's response, along with its decoded content.

![image](https://academy.hackthebox.com/storage/modules/161/10.png)

Step 2: We crafted a SOAP request containing a command to be executed by the remote server. The command would send `ping` messages from the affected server to our host. The image below displays the crafted request and its decoded payload.

![image](https://academy.hackthebox.com/storage/modules/161/11.png)

Step 3: The following image displays the crafted SOAP request allowing to remotely execute a `ping` command from the affected system. Capturing traffic via Wireshark, we observed the `ping` request from the Websphere application server to our machine.

![image](https://academy.hackthebox.com/storage/modules/161/12.png)

---

## CVSS Score Breakdown

---

|||
|---|---|
|`Attack Vector:`|Network - The attack can be mounted over the internet.|
|`Attack Complexity:`|Low - All the attacker has to do is send a crafted request against the vulnerable application.|
|`Privileges Required:`|None - The attacker can be mounted from an unauthenticated perspective.|
|`User Interaction:`|None - No user interaction is required to exploit this vulnerability successfully.|
|`Scope:`|Unchanged - Since the vulnerable component is the webserver and the impacted component is again the webserver.|
|`Confidentiality:`|High - Successful exploitation of the vulnerability results in remote code execution, and attackers have total control over what information is obtained.|
|`Integrity:`|High - Successful exploitation of the vulnerability results in remote code execution. Attackers can modify all or critical data on the vulnerable component.|
|`Availability:`|High - Successful exploitation of the vulnerability results in remote code execution. Attackers can deny the service to users by powering the webserver off.|



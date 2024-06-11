converting complex data structures into a "flatter" format

`$user->name = "carlos"; $user->isLoggedIn = true;`

`O:4:"User":2:{s:4:"name":s:6:"carlos"; s:10:"isLoggedIn":b:1;}`

# **Java serialization format**

encoded as `ac ed` in hexadecimal

`rO0` in Base64.

# **Modifying object attributes**

```
O:4:"User":2:{s:8:"username";s:6:"carlos";s:7:"isAdmin";b:0;}
```

tampering data `isAdmin` attribute 1 re-encode the object, and overwrite their current cookie



```
class person{
public $name;
public $age=19;
public $sex;
}

Serialization by serialize( ) function:

O:6:"person":3:{s:4:"name";N;s:3:"age";i:19;s:3:"sex";N;}
```

# **Modifying data types**

**PHP-based logic** loose comparison operator (`==`)

convert the string to an integer, meaning that `5 == "5"` evaluates to `true`

`5 == "5 of something”` as `5 == 5`.

`0 == "Example string"`

```jsx
$login = unserialize($_COOKIE)
if ($login['password'] == $password) {
// log in successfully
}
```

Set cookie as 0 (int) then, at backend `“Somepassword” == 0` is true and login

# **Using application functionality**

“Delete user"functionality the `user account` is deleted and `user's profile picture` is deleted by accessing the file path in the `$user->image_location` attribute

if the image location is set to `arbitrary path` it deletes user account and `arbitrary path`

# **Magic methods**

Methods to look for :

```php
__wakeup() called when an object is unserialized.(establishes lost db connection)
__destruct() called when an object is deleted.(when an object is about to be destroyed ,clean up.)
__toString() called when an object is converted to a string.
__sleep: Invoked when an object is being serialized
for more magic methods [Magic methods](<https://www.php.net/manual/en/language.oop5.magic.php>)
```

These Magic Methods allow you to `pass data` from a serialized object `into the website's code` before the object is fully deserialized

# **Injecting arbitrary objects** [PHP OBJECT INJECTION](https://www.tarlogic.com/blog/how-php-object-injection-works/?source=post_page-----dfe173d9f446--------------------------------)

methods available to an `object` are `determined` by its `class`

if attacker `manipulate` the the `class` then he can decide `next` which `method` to be `run`

mostly possible in `white box testing`

# Gadget Chains [Refer this](https://medium.com/@dub-flow/deserialization-what-the-heck-actually-is-a-gadget-chain-1ea35e32df69)

[For Finding Gadgets via CodeQL in CodeBase](https://www.synacktiv.com/en/publications/finding-gadgets-like-its-2022)

[yes it is Framework (CVE-2020-15148)](https://blog.redteam-pentesting.de/2021/deserialization-gadget-chain/)

[References](https://i.blackhat.com/us-18/Thu-August-9/us-18-Haken-Automated-Discovery-of-Deserialization-Gadget-Chains-wp.pdf)

gadget - a `snippet` of code

attacker goal - invoke method to `pass input` into `another gadget` final aim into a `dangerous "sink gadget”` such as contains eval()

done `using` `magic` `method` during serialization and deserialization

> _A gadget chain is a `chain` of function calls from a `source` method, generally `readObject`, to a `sink` method which will perform dangerous actions like calling the `exec` method of the Java runtime._

## Google Dorks to Find out Yii Framework:

inurl:"index.php?r=site/login

inurl:"index.php?r=site/error

inurl:"index.php?r=site/contact

inurl:"index.php?r=site/contact

inurl:"index.php?r=site/page

inurl:"index.php?r=site/view

inurl:"index.php?r=site/index

inurl:"index.php?r=site/signup

inurl:"index.php?r=site/login

inurl:"index.php?r=site/logout

# CTF Writeups

[https://hg8.sh/posts/misc-ctf/insecure-deserialization/](https://hg8.sh/posts/misc-ctf/insecure-deserialization/)

[CTF With VIM SWP](https://trevorsaudi.medium.com/cybertalents-weekend-ctf-gu55y-writeup-php-object-injection-dfe173d9f446)

# References

[https://macrosec.tech/index.php/2021/06/22/exploiting-insecure-deserialization-vulnerabilities-found-in-the-wild/](https://macrosec.tech/index.php/2021/06/22/exploiting-insecure-deserialization-vulnerabilities-found-in-the-wild/)

[https://scholarworks.sjsu.edu/cgi/viewcontent.cgi?article=2270&context=etd_projects](https://scholarworks.sjsu.edu/cgi/viewcontent.cgi?article=2270&context=etd_projects)

[](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure%20Deserialization/PHP.md)[https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure) Deserialization/PHP.md

[https://blog.hacktivesecurity.com/index.php/2019/10/03/rusty-joomla-rce/](https://blog.hacktivesecurity.com/index.php/2019/10/03/rusty-joomla-rce/)
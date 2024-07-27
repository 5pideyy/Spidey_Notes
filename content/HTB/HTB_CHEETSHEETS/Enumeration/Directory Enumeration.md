# WFUZZ



FOR DIRECTORY

~~~
wfuzz -c --hc=404 -t 200 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt https://10.13.37.12/Home/FUZZ
~~~

FOR SUBDOMAIN

~~~
wfuzz -c -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --hc 400,404,403,301,302 -H "Host: FUZZ.target.htb" -u http://target.htb/ -t 100
~~~

NMAP:
```
nmap -p- --min-rate 10000 
```

```
nmap -p .. -sCV ..
```



To find SUID Binaries :
```
find / -perm /4000 2>/dev/null

```





PROTECT KING FILE

```
while [ 1 ]; do chattr -ia /root/king.txt 2>/dev/null; echo -n Pradyun >| /root/king.txt 2>/dev/null; chattr +ia /root/king.txt 2>/dev/null; done &
```
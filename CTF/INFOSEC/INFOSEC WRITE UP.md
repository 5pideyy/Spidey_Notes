# Reverse Engineering

## 1. Rewind(100 points)

#### Attachments:

* chal
* Readme.txt
	* It's all a matter of seconds.

#### Solution:

* **chal** is elf file which requires **flag.txt**(fake one) to work with. 
* Used **ghidra** to analyze the **chal**. All the code does is bitwise/arthmetic operations. 
* The below C code is part of the main function.
```c
local_10 = *(long *)(in_FS_OFFSET + 0x28);
local_e8[0] = FUN_00101349;
local_e8[1] = FUN_0010136a;
local_e8[2] = FUN_0010137f;
local_e8[3] = FUN_001013a0;
local_c8 = FUN_001013c1;
local_c0 = FUN_001013d7;
local_b8 = FUN_001013f8;
local_b0 = FUN_00101419;
local_a8 = FUN_0010142f;
__stream = fopen("flag.txt","r");
if (__stream == (FILE *)0x0) {
perror("Error opening file");
uVar3 = 1;
}
else {
__n = fread(local_98,1,0x22,__stream);
local_98[__n] = 0;
fclose(__stream);
memcpy(local_68,local_98,__n);
tVar4 = time((time_t *)0x0);
srand((uint)tVar4);
for (local_108 = 0; local_108 < __n; local_108 = local_108 + 1) {
  iVar2 = rand();
  snprintf(local_38,4,"%d",(ulong)(uint)(iVar2 % 9));
  iVar2 = FUN_00101448(local_38);
  bVar1 = (*local_e8[iVar2])(local_68[local_108]);
  local_68[local_108] = bVar1;
}
for (local_100 = 0; local_100 < __n; local_100 = local_100 + 1) {
  printf("%02X ",(ulong)local_68[local_100]);
}
```
* `local_e8` is pointing to the functions that does the operations. 
* The order of operations performed in the flag is randomized using **rand()** with a **seed**. 
* Seed value is nothing but timestamp (`tVar4`) which is then scaled down between `[0-8]`. 
* This seed value is then passed to function `FUN_00101448` which does some operation and return a value in `[0-8]`. 
* After the operations are performed and encrypted flag is printed out as hex.

* To solve this problem we need to find the **seed** which is nothing but timestamp. With the same Seed value you can regenerate the same random values.
* The below C code will get the timestamp.

```c
#include <stdio.h>
#include <time.h>

int main(){
	int tt = time(NULL);
	printf("%d",tt);
	return 0;
}
```
* The below C code will generate the random generated values based on timestamp. This code will give randint array for 15 timestamp. One of them will be as same as the **chal**.
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int seed = 1736595259; // Your known seed value
    for (int i=0;i<15;i++){
        srand(seed+i);
        printf("[");
        for (int j=0;j<31;j++){
            int random_number = rand();
            printf("%d, ",random_number % 9);
        }
        printf("]\n");
    }

    return 0;
}
```
* The below python3 code will do the randomization and perform operation in the characters until it receives the correct encrypted flag character(each one). 
```python
#!/usr/bin/env python3
import string

s = string.printable
rand = []

obflag = ""
obflag = [int(x, 16) for x in obflag.split()]

def encode(val,c):
	if val == 0:
		return (c >> 4 | c << 4) & 0xff
	elif val == 1:
		return ~c & 0xff
	elif val == 2:
		return (c << 5 | c >> 3) & 0xff
	elif val == 3:
		return (c >> 2 | c << 6) & 0xff
	elif val == 4:
		return (c ^ 0xaa)
	elif val == 5:
		return (c + ord('\a')) & 0xff
	elif val == 6:
		return (c << 6 | c >> 2) & 0xff
	elif val == 7:
		return (c + 0x55) & 0xff
	elif val == 8:
		return (c * 2 + c) & 0xff

def randomize(input_str):
    local_10 = 1
    local_c = 0
    for char in input_str:
        local_10 = (local_10 + ord(char)) % 0xFFF1
        local_c = (local_10 + local_c) % 0xFFF1
    return ((local_c << 16 | local_10) % 9)

def running(rand)
	for i in range(len(obflag)):
		value = obflag[i]
		for j in range(len(s)):
			if encode(randomize(str(rand[i])),ord(s[j])) == value:
				print(s[j],end="")
				break
	print()

for i in range(len(rand)):
	running(rand[i])
```
* Stored the encrypted flag from the chal in `obflag` and rand lists in `rand`.
* Run timestamp C code first. Note the timstamp and then execute the **chal**. Store the timestamp value in `seed` variable in the next C code to calculate the rand. 
* This will spit the **flag**


---


## 2. More than meets the eye (300 points )

#### Attachments:

* Chall
* Readme.txt
	* It's time to show that we are 'more than meets the eye'. 

#### Solution:

* **Chall** program's main function just perform xor operation on input string with `0x20` and compares with xored string stored in the program. 
* Once we get pass that part, we have to go through another function that does a lot of if else condition checking on the input and if the string passes all the condition, only then we get the flag.
* To reverse this condition checking, I've used `z3 solver` in python3.

```python
#!/usr/bin/env python3 

from z3 import *

encrypted = [0x54, 0x4F, 0x7F, 0x42, 0x45, 0x7F, 0x4F, 0x52,
 0x7F, 0x4E, 0x4F, 0x54, 0x7F, 0x54, 0x4F, 0x7F,
 0x42, 0x45]

original = ''.join(chr(b ^ 0x20) for b in encrypted)
print("Password 1:",original)


length = 41

f = [BitVec(f'flag_{i}', 32) for i in range(length)]

sol = Solver()

sol.add(f[1] + f[0] == 0x9b)
sol.add(f[0] - f[1] == 0xb)

sol.add(f[3] + f[2] == 0x60)
sol.add(f[2] == f[3])

sol.add(f[5]+f[4] == 0xca)
sol.add(f[4] - f[5] == 0xc)

sol.add(f[7] + f[6] == 0x9f)
sol.add(f[6] - f[7] == -0x31)

sol.add(f[9] + f[8] == 0xa8)
sol.add(f[8] - f[9] == -0x40)

sol.add(f[11]+f[10] == 0xb2)
sol.add(f[10] - f[11] == 0xc)

sol.add(f[13] + f[12] == 0xd8)
sol.add(f[12] - f[13] == 8)

sol.add(f[15] + f[14] == 0xa5)
sol.add(f[14] - f[15] == -0x3f)


sol.add(f[17] + f[16] == 0xc4)
sol.add(f[16] - f[17] == 6)

sol.add(f[19] + f[18] == 0xbf)
sol.add(f[18] - f[19] == -0x11)

sol.add(f[21] + f[20] == 0xdd)
sol.add(f[20] - f[21] == -0xb)

sol.add(f[23] + f[22] == 0x93)
sol.add(f[22] - f[23] == 0x2b)

sol.add(f[25] + f[24] == 0xd8)
sol.add(f[24] == f[25])

sol.add(f[27] + f[26] == 0xc3)
sol.add(f[26] - f[27] == -5)

sol.add(f[29] + f[28] == 0x6b)
sol.add(f[28] - f[29] == -3)

sol.add(f[31] + f[30] == 0xcb)
sol.add(f[30] - f[31] == -0xd)

sol.add(f[33] + f[32] == 0xdd)
sol.add(f[32] - f[33] == -0xb)

sol.add(f[35] + f[34] == 0xd7)
sol.add(f[34] - f[35] == -0xd)

sol.add(f[37] + f[36] == 0xd5)
sol.add(f[36] - f[37] == -0x13)

sol.add(f[39] + f[38] == 0xe7)
sol.add(f[38] - f[39] == 3)

sol.add(f[40] == ord('e'))



if sol.check()==sat:
    m = sol.model()

    flag = [chr(int(str(m[f[i]]))) for i in range(41)]

    print("Password 2:",''.join(flag))
else:
    print('unsat')
```
* **Script output**:
	`Password 1: to_be_or_not_to_be
	Password 2: SH00k_7h4t_Sph3re_Whit_4ll_d47_literature`

---

## 3. Blindness (500 points)

#### Attachments:

* Readme.txt
	* Do you think you know reversing because you can analyse the files? Well, let's see how good you are when there are no files! 

#### Solution:

* We don't get the `elf` file for this. We'll have to connect the netcat server straight away. 
* The challenges gives you a `base64-encoded` string of `gzip` file. We have to decode and store it as `.gz` file and unzip the file.
* The `gzip` file gives us a **elf file** which has the **password** in it. We have to extract the password and give it back to the challenge server. 
* We have to do this for 60 files in 60 seconds. And there are **special elf** files between in which the password is **xored** with a key. 
* Wrote a python3 script that remotely connects the chall server using `pwntool` and does all the work.

```python
#!/usr/bin/env python3

from pwn import *
import base64
import subprocess

conn = remote('13.234.240.113',31813)

conn.recvline()
conn.recvline()
conn.recvline()
conn.recvline()

for i in range(0,59):
	output = conn.recvline().decode()

	encoded = output[15:-2]
	decoded = base64.b64decode(encoded)

	f = open('file_'+str(i)+'.gz','wb')
	f.write(decoded)
	f.close()

	subprocess.run(['gzip', '-d', 'file_'+str(i)+'.gz'])

	elf = ELF('file_'+str(i),checksec=False)
	data_section = elf.get_section_by_name('.data')

	if data_section:
		data = data_section.data()
		if len(data.hex()) == 42:
			password = data[:-1]
		elif len(data.hex()) == 44:
			password = b""
			key = data[-1:][0]
			for j in range(len(data[:-2])):
				password += chr(data[j] ^ key).encode()

	# result = subprocess.run(['strings', 'file_'+str(i)], capture_output=True, text=True)

	# output = result.stdout
	# password = output.split('\n')[0]

	conn.recvuntil(b"what's the password: ")
	conn.sendline(password)
	conn.recvline()
	print("Cracking...",i+1)

print(conn.recvline().decode())
```

---

# MOBILE

## SECURE BANK (300 points)




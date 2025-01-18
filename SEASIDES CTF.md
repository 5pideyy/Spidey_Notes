


---
**Name**: Pradyun R  
**Discord**: 5pideyy  
**Platform Name**: Spideyy  
**Mobile**: +91 99446 84665

---

# BRUTEONE

- we got a file which contains hashes
- now i moved to crackstation https://crackstation.net/ to crack the hashes

![[Pasted image 20250118203008.png]]

- and yeah we are getting flag , so i cracked all the hashes

- flag : `HACK_QUEST{lets_go_character_by_character}`

# SHADOWS INSIGHT

- we are given an E-Commerce application 
- i configured burpsuite for the request pass through it
- while login in , ad admin user i got flag via an end point 

![[Pasted image 20250118203530.png]]

- we also got some hints that it uses Nosql data base since it thows a key word `collection`

# HIDDEN VEINS

- i have spidered the web completely to fill up my `sitemap` in burpsuite
- i have encountered  `get user address` via an api endpoint , and yeah we already found that it uses nosql right ! let me try to inject nosql payload 
- got the flag

> [!NOTE] 
> Payload : 
{"userId":{"$ne": null}}

![[Pasted image 20250118204240.png]]

# WHOS SHADOW

- I am given an user id , `67896ab1c3d94b4e97baf28c` , and said `Did you hear what the user said` this gave us hint that i need to see review of this userid
- initially i mapped the user id to username using `/api/user/update-profile` endpoint and found out the username 
![[Pasted image 20250118205023.png]]

- Now its time to read all the reviews through username 
- initially when i login i found that an api request goes to `/api/products/best-sellers`
- searching the username got the flag 
![[Pasted image 20250118205538.png]]

# NOT THAT EASY
- we are given `IMG_CRAC.JPG` and `IMG2.jpg`
- using exiftool i have got an base64 content in comments

![[Pasted image 20250118205931.png]]
- on decoding we get a password for stegextract , using the password run stegextract to get the flag

![[Pasted image 20250118210019.png]]

- while renaming the anthoer file to `.zip` and after extracting got the flag

![[Pasted image 20250118210116.png]]

- flag : `Flag{Ways_of_doing_steganography}`


# STRING CIPHER

- i have got an elf file `rev`
- i have used dogbolt to decompile https://dogbolt.org/

![[Pasted image 20250118210643.png]]

- analysed how it works
- i have written python script to decode the flags 

```python
def reverse_xor_transformation():
    """
    Reverses the XOR transformation applied to the original string.
    The transformation XORed each character with its index.
    """
    # Original transformed string from var_70
    transformed = "XYZ[\\]^_`abcdefghijklmn"
    
    # Reverse the XOR transformation to retrieve the original string
    original = ""
    for index, char in enumerate(transformed):
        # XOR the character's ASCII value with its index to retrieve the original character
        original += chr(ord(char) ^ index)
    
    return original

def extract_flag():
    """
    Extracts and reconstructs the flag-like data stored in a null-separated ASCII format.
    """
    # Hardcoded flag-like data from var_d8 (null-separated ASCII values)
    flag_data = ("\x37\x32\x00\x36\x35\x00\x36\x37\x00\x37\x35\x00\x39\x35\x00\x38\x31\x00"
                 "\x38\x35\x00\x36\x39\x00\x38\x33\x00\x38\x34\x00\x31\x32\x33\x38\x33\x00"
                 "\x36\x39\x00\x36\x35\x00\x38\x33\x00\x37\x33\x00\x36\x38\x00\x36\x39\x00"
                 "\x38\x33\x00\x39\x35\x00\x38\x32\x00\x36\x39\x00\x38\x36\x00\x36\x39\x00"
                 "\x38\x32\x00\x38\x33\x00\x36\x39\x00\x39\x35\x00\x38\x37\x00\x36\x35\x00"
                 "\x38\x36\x00\x36\x39\x00\x31\x32\x35\x00\x00\x00")
    
    # Split the flag data by null character and join the parts to form the flag
    flag_parts = flag_data.split("\x00")
    flag = "".join(flag_parts)
    
    return flag

if __name__ == "__main__":
    # Reverse the XOR transformation to get the original string
    original_string = reverse_xor_transformation()
    print(f"Original string from XOR transformation: {original_string}")
    
    # Extract and reconstruct the flag
    flag = extract_flag()
    print(f"Extracted flag: {flag}")

```

# DOCKED AND DANGEROUS

- i have given a docker file and and ip to connect
- password to connect via ssh found in docker file

![[Pasted image 20250118211340.png]]

- using this i have connect to the server and got flag in the directory specified in docker file
![[Pasted image 20250118211436.png]]

# FOLLOW THE TRACES

- i am given a log file wrtten in xlsx file
- have found base64 encoded values in log file
![[Pasted image 20250118211648.png]]

- decode  to get the  flag

![[Pasted image 20250118211807.png]]

# PRETTY PE

- an easy challenge , got flag using strings , unfortunatly this is an copied challed of `HACKEXPO` ctf

![[Pasted image 20250118211930.png]]

# NESTED SECRETS

- we are given an github repo , after getting through the repositoried made my crac learing , some suspicious repo in stars
![[Pasted image 20250118212214.png]]

- named defhawk 
![[Pasted image 20250118212243.png]]

got flag as username 


- flag : `HACK_QUEST{d3fhawk}`

# VAULT HEIST

- AFTER LOGGING IN IF WE DONE KYC WE GET RUPESS 100
- CAPTURED REQUEST AND GAVE MULTIPLE TIME USING REPEATER IN BURP 

![[Pasted image 20250118212432.png]]

- AFTER INCREASING MY WALLET AMOUNT , VISITIED THE URL AND GOT THE FLAG `ctf/validateChall2`


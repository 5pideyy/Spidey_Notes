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

SecureBank Pvt Ltd is releasing their beta version of the banking application for bug bounty hunters. The test credentials for test account are as follows:

* Account Number: `667614145`
* PIN: `1260585352`  

We’ve got an APK and a server instance to mess with. Let’s get cracking — literally!

---

## Static Analysis

Decompiled the APK using `jadx-gui` and an online [APK decompiler](https://www.decompiler.com/). My first stop? `AndroidManifest.xml` — the cheat sheet of app permissions and activities. Found 7 activities. Let’s snoop around.

---

### Activity Gossip

#### **1. Messages Activity**

```java
public class Messages extends AppCompatActivity {  
    TextView msg;  

    protected void onCreate(Bundle bundle) {  
        super.onCreate(bundle);  
        setContentView(R.layout.activity_messages);  
        TextView textView = (TextView) findViewById(R.id.messageText);  
        this.msg = textView;  
        textView.setText("Stay tuned for upcoming features!!");  
    }  
}
```

_Spoiler alert_: Nothing juicy here. Just a motivational message: "Stay tuned for upcoming features!!". Thanks, devs. 🙄

---

#### **2. ViewProfile Activity**

```java
public class ViewProfile extends AppCompatActivity {  
    TextView accNo;  
    TextView name;  

    protected void onCreate(Bundle bundle) {  
        super.onCreate(bundle);  
        setContentView(R.layout.activity_view_profile);  
        this.name = (TextView) findViewById(R.id.name);  
        this.accNo = (TextView) findViewById(R.id.accNo);  
        Volley.newRequestQueue(this).add(new StringRequest(0, getIntent().getStringExtra("depl_URL") + "/user/" + getIntent().getStringExtra("id") + "?secret=" + getIntent().getStringExtra("pin"), new Response.Listener() { 
            public final void onResponse(Object obj) {  
                ViewProfile.this.m6lambda$onCreate$0$comsecurebankingViewProfile((String) obj);  
            }  
        }, new Response.ErrorListener() { 
            public void onErrorResponse(VolleyError volleyError) {  
                Toast.makeText(ViewProfile.this.getApplicationContext(), volleyError.toString(), 0).show();  
                Log.d("Error is: ", volleyError.toString());  
            }  
        }));  
    }  
    /* synthetic */ void m6lambda$onCreate$0$comsecurebankingViewProfile(String str) {  
        try {  
            JSONObject jSONObject = new JSONObject(str);  
            this.name.setText(jSONObject.getString("username"));  
            this.accNo.setText(jSONObject.getString("accountNumber"));  
        } catch (JSONException e) {  
            throw new RuntimeException(e);  
        }  
    }  
}
```

The app sends a GET request to fetch user details with `id` and `pin` using volley. Response displays your username and account number. Nothing screams "security!" here 😂.

---

#### **3. Customer Login Page Activity**

This is where things get spicy! The login logic:

1. **UI Setup**: Initializes fields for account number, PIN, deployment URL.
2. **Validation Checks**: Fields can’t be empty, and URL must be valid.
3. **Authentication**:
    - Calls `dBHelper.authenticateUser()` with account number and hashed PIN.
    - The "hashing"? Wait for it..

Here’s the PIN hashing magic:

```java
public static Long hash(Long l) {  
    Long valueOf = Long.valueOf(((l.longValue() & 2863311530L) >>> 1) | ((l.longValue() & 1431655765) << 1));  
    Long valueOf2 = Long.valueOf(((valueOf.longValue() & 3435973836L) >>> 2) | ((valueOf.longValue() & 858993459) << 2));  
    Long valueOf3 = Long.valueOf(((valueOf2.longValue() & 4042322160L) >>> 4) | ((valueOf2.longValue() & 252645135) << 4));  
    Long valueOf4 = Long.valueOf(((valueOf3.longValue() & 4278255360L) >>> 8) | ((valueOf3.longValue() & 16711935) << 8));  
    return Long.valueOf((valueOf4.longValue() >>> 16) | (valueOf4.longValue() << 16));  
}
```

This obfuscates the PIN using bitwise operations:

1. Swaps even and odd bits.
2. Swaps adjacent pairs, groups of 4, and groups of 8 bits.
3. Finally, swaps 16-bit halves.

TL;DR: This swaps bits around like a Rubik's cube. Obfuscation? Sure. Real security? Not really.

---

#### **4. DBHelper**

```java
public class DBHelper extends SQLiteOpenHelper {  
    private static String name = "bankDB.db";  
    private final Context context;  
    private String path;  

    public DBHelper(Context context) {  
        super(context, name, (SQLiteDatabase.CursorFactory) null, 1);  
        this.context = context;  
        this.path = context.getDatabasePath(name).getPath();  
    }  

    private boolean checkDB() {  
        return new File(this.path).exists();  
    }
}
```

Spotted! A local SQLite database named `bankDB.db`. Let’s grab it 👀.

---

### Database Extraction

Exported the database. Here’s what we found:

```bash
sqlite> .tables
android_metadata  customerDetails 

sqlite> SELECT * FROM customerDetails;
uid | username | acct_number | hashed_PIN      | balance 
1   | user1    | 667614145   | 216406515827922 | 1000.0
0   | admin    | 000000000   | 43431626549120  | 2000.0
3   | user3    | 407142357   | 13348376939555  | 3000.0
2   | user2    | 111111111   | 240658437888736 | 5000.0
```

---

## Reverse the Hashed PIN

Let’s undo their "fancy" hashing:

```java
import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the hashed PIN to decrypt:");
        Long hashedPin = scanner.nextLong();
        Long valueOf4 = Long.valueOf((hashedPin << 16) | (hashedPin >>> 16));
        Long valueOf3 = Long.valueOf(((valueOf4 & 16711935L) << 8) | ((valueOf4 & 4278255360L) >>> 8));
        Long valueOf2 = Long.valueOf(((valueOf3 & 252645135L) << 4) | ((valueOf3 & 4042322160L) >>> 4));
        Long valueOf = Long.valueOf(((valueOf2 & 858993459L) << 2) | ((valueOf2 & 3435973836L) >>> 2));
        Long originalPin = Long.valueOf(((valueOf & 1431655765L) << 1) | ((valueOf & 2863311530L) >>> 1));
        System.out.println("Hashed PIN: " + hashedPin + " => Original PIN: " + originalPin);
        scanner.close();
    }
}
```

Boom! PIN reversed. Let’s take these for a spin.

---

## Dynamic Analysis 

### ADB Logging

Installed the APK, connected via `adb`, and logged requests:

```bash
adb logcat | grep eng.run
https://ch2016112962.challenges.eng.run/user/0?secret=31733100
```

Logged in with the provided creds. Observed API interactions. Tried swapping user IDs and PINs.

### Admin Privileges

Used the admin credentials from the database.And voilà! The system handed me the flag . **Secure Bank**? More like "Surrender Bank."


**Pro Tip :** If this bank actually launched, I’d keep my money in a mattress instead. At least my mattress won’t leak my account details. 🤣

---


# WEB

## SNAP FROM URL (100 points)

- we are given a flask server main.py and admin.py that is running locally

- main.py file has only two routes simple right ! that to one for index !!! the simplest .
#### Image Processing Route

```python
@app.route('/images', methods=['POST'])
def images():
    try:
        url = request.form.get('url')

        if not url:
            return render_template("error.html", error="Missing url :("), 400

        if blacklisted(url):
            return render_template("error.html", error="URL is blacklisted (unsafe or restricted)"), 403

        ip = socket.gethostbyname(urlparse(url).hostname)
        print(ip)
        if ip in ["localhost", "0.0.0.0"]:
            return render_template("error.html", error="Blocked !! "), 403
        
        response = requests.get(url, allow_redirects=False)
        res_text = response.text
    
        img_urls = image_parser(res_text, url)
        if not img_urls:
            return render_template("error.html", error="No images found on the page :("), 404

        return render_template('images.html', url=url, images=img_urls)

    except Exception:
        error = "An error occurred while fetching the URL. Please try again later."
        return render_template("error.html", error=error), 500

```


- extracts the `url` from the POST request , if no url or blacklisted url is specified error.html is rendered
- resolves the ip from host name , huhhh why not 127.0.0.1,127.0.0.0 is blocked!! thats our path wayyy but aww snappp it is blocked using blacklist function and yeah we have to figure out the payload that resolved to 127.0.0.1,127.0.0.0
- it make get request to the url given as input and parses image using `image_parser`

#### Image parsing
```python
def image_parser(res_text, url):
    soup = BeautifulSoup(res_text, 'html.parser')

    images = soup.find_all('img')

    img_data = [
        {
            'src': urljoin(url, img['src']),
            'alt': img.get('alt', '(No alt text)')
        }
        for img in images if 'src' in img.attrs
    ]

    print("img_data", img_data)

    if not img_data:
        return None

    return img_data

```



#### ### **Blacklist and URL Validation**

```python
blacklist = [
    "localhost",
    "127.0.0.1",
    "0.0.0.0",
    "169.254.169.254",
    ""  
]

def blacklisted(url):
    try:
        parsed_url = urlparse(url)
        if parsed_url.scheme not in ["http", "https"]:
            return render_template("error.html", error="Invalid URL scheme"), 400

        host = parsed_url.hostname
        print("host", host)

    except:
        return True
    if host in blacklist:
        return True
        
    private_ip_patterns = [
        r"^127\..*",           
        r"\b(0|o|0o|q)177\b",  
        r"^2130*",      
        r"^10\..*",           
        r"^172\.(1[6-9]|2[0-9]|3[0-1])\..*", 
        r"^192\.168\..*",  
        r"^169\.254\..*",
    ]
    
    for pattern in private_ip_patterns:
        if re.match(pattern, host):
            print("blocked")
            return True
    
    return False


```

- 




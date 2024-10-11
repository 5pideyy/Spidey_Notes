### Problem Summary:

You have a ZIP file (`website.zip`) that is encrypted using **ZipCrypto** encryption. The password is unknown, and the friend who created the ZIP is a fan of **Emmet**, a toolkit used by web developers for writing HTML/CSS code quickly.

### Insight:

Your friend is likely using a strong, non-guessable password. However, since the ZIP contains an `index.html` file, we can make use of a **known-plaintext attack** (KPA) because we know how HTML files typically start. Specifically, we know some of the first few lines of `index.html` based on the HTML standard.

To perform a known-plaintext attack, we can use a tool called **bkcrack**. This tool can recover the ZIP file's encryption keys if we have at least 12 bytes of plaintext that match the encrypted content.

### Step-by-Step Breakdown:

#### Step 1: Analyze the ZIP File

We first analyze the structure of the `website.zip` file using the `bkcrack` tool to understand the encryption and compression used.



```
./bkcrack -L website.zip
```

This command lists the details of the `website.zip` file. The output shows that the file uses **ZipCrypto** encryption and **Store** compression.



```
Archive: website.zip 
Index Encryption Compression CRC32    Uncompressed  Packed size Name 
----- ---------- ----------- -------- ------------ ------------ ----------------     0 ZipCrypto  Store       7a0a2e19          274          286 index.html

```

#### Step 2: Gather Known Plaintext

To launch the known-plaintext attack, we need to supply a part of the file that we know is the same in both the plaintext and the encrypted file. Since the file is an HTML file, we can guess the beginning of the content based on standard HTML structure.



```
`<!DOCTYPE html> 
<html lang="en"> 
<head>     
<meta charset="UTF-8">`
```

This is the plaintext we will use, which provides more than the required 12 bytes.

#### Step 3: Create a Matching ZIP File

Now, we need to recreate a ZIP file with an `index.html` file containing the same plaintext, using the same compression and encryption settings (i.e., **ZipCrypto** encryption and **Store** compression). To do this, run the following command:



```
zip -r -e -P "1" -0 index.zip index.html
```

This command creates a ZIP file (`index.zip`) that stores the file `index.html` uncompressed (`Store` compression) and encrypts it with **ZipCrypto**.

#### Step 4: Ensure Correct Line Endings (CRLF)

In text files, different systems (Windows vs. Linux) may use different line endings. If the line endings of the plaintext we guessed do not match those in the encrypted file, the attack will fail. The file may use **CRLF** (Carriage Return + Line Feed) line endings, which is common in Windows environments.

We check the file using the `xxd` command:



```
xxd index.html
```

If you see `\n` (Line Feed) characters, convert them to `\r\n` (Carriage Return + Line Feed) to match the original encrypted file.

#### Step 5: Launch the Known-Plaintext Attack

With our prepared ZIP file (`index.zip`) and the original `website.zip`, we now run the attack using `bkcrack`:



```
./bkcrack -C website.zip -c index.html -p index.html -U decrypt.zip 1
```

Explanation of the command:

- `-C website.zip` specifies the encrypted ZIP file.
- `-c index.html` specifies the file inside the ZIP that we want to decrypt.
- `-p index.html` provides the known plaintext.
- `-U decrypt.zip 1` creates a decrypted ZIP file (`decrypt.zip`) using the recovered keys, with password "1."

#### Step 6: Success and Extract the Flag

The attack works by reducing the encryption keys based on the known plaintext. After a successful attack, we get the following result:



`Keys: a18ba181 a00857dd d953d80f Wrote unlocked archive.`

Now, you can open the decrypted ZIP file (`decrypt.zip`) and view the contents of `index.html`:



`cat index.html`

You will find the flag hidden inside the HTML code:


`<!DOCTYPE html> <html lang="en"> <head>     <meta charset="UTF-8">     <meta name="viewport" content="width=device-width, initial-scale=1.0">     <title>Flag</title> </head> <body>     ironCTF{Wh0_us35_Z1pCrypt0_wh3n_kn0wn_PlA1nt3xt_a7t4cks_ex1s7?} </body> </html>`

### Final Flag:

The flag is:



`ironCTF{Wh0_us35_Z1pCrypt0_wh3n_kn0wn_PlA1nt3xt_a7t4cks_ex1s7?}`
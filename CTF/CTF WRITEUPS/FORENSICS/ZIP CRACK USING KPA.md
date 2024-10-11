
### **Uncrackable Zip**

I forgot to ask my friend for the password to access the secret webpage, and now he's unavailable. I've tried guessing the password, but it's been unsuccessful. My friend is very security-conscious, so he wouldn't use an easy-to-guess password. He's also an Emmet enthusiast who relies heavily on code generation shortcuts. Can you help me figure out how to access the secret webpage?

**Author**: `AbdulHaq`

Given: `website.zip`

Initially, you try to bruteforce the zip with all kinds of wordlists, to which the zip file doesn’t even budge. Then we read the description carefully, we see that the friend like `emmet`, which is a **toolkit for web-developers, that allow you to store and re-use commonly used code chunks.**

Reading the documentation and all that, even before that, we know that the HTML files start with the OG syntax, and since we know some starting bytes of the plaintext, we can implement a known-plaintext attack on the zip file. For this we can bring out a legendary tool called `bkcrack`.

https://github.com/kimci86/bkcrack

```bash
└─$ ./bkcrack -L website.zip
bkcrack 1.7.0 - 2024-05-26
Archive: website.zip
Index Encryption Compression CRC32    Uncompressed  Packed size Name
----- ---------- ----------- -------- ------------ ------------ ----------------
    0 ZipCrypto  Store       7a0a2e19          274          286 index.html
```

We see that it uses the `ZipCrypto` encryption and the `Store` compressions. Important things to note.

<aside>
💡

To run the attack, we must guess at least 12 bytes of plaintext. On average, the more plaintext we guess, the faster the attack will be.

</aside>

Now, we can create a duplicate `index.html` with about 12 bytes or more of a known plaintext, which we know from the hints in the description. 

[Cheat Sheet](https://docs.emmet.io/cheat-sheet/)

We use the following known plaintext.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
```

Also, here’s a guide on this that we can refer to.

https://github.com/kimci86/bkcrack/blob/master/example/tutorial.md

Now, we can zip this index.html file with the appropriate encryption and compression techniques, essentially, matching the one in the encrypted zip file.

```bash
zip -r -e -P "1" -0 index.zip index.html
```

This command creates a ZIP file (`index.zip`) containing the file `index.html`. The contents of `index.html` are not compressed [`Store`] (because of the `-0` flag) and are encrypted with the password `"1"` using **ZipCrypto**.

Had some issues in cracking the zip with the same procedure. Was stuck here for a while. Then while looking at the hex bytes of the plaintext `index.html`.

```html
└─$ xxd index.html
00000000: 3c21 444f 4354 5950 4520 6874 6d6c 3e0a  <!DOCTYPE html>.
00000010: 3c68 746d 6c20 6c61 6e67 3d22 656e 223e  <html lang="en">
00000020: 0a3c 6865 6164 3e0a 2020 2020 3c6d 6574  .<head>.    <met
00000030: 6120 6368 6172 7365 743d 2255 5446 2d38  a charset="UTF-8
00000040: 223e 0a
```

We can see that it uses the `LF` terminator. Now time for some googling.

<aside>
💡

**Known-plaintext attacks** (like the one used by `bkcrack`) rely on an exact match between the plaintext (known content) and the corresponding encrypted data in the ZIP file. If the line endings of your plaintext don't match those of the file stored in the ZIP archive, the attack will fail because the data won’t align byte-for-byte. When the file was originally created or zipped, it might have been generated on a Windows system or with tools that use **CRLF** for line terminators, meaning each line ends with `\r\n` rather than just `\n`. The ZIP file stores these line terminators as part of the file’s content, so your plaintext must have **CRLF** line endings to match what is in the encrypted ZIP file.

</aside>

Changing `LF` into `CRLF` [**Carriage Return and Line Feed**, which are special characters used to indicate the end of a line in text files and other software code] 

- **LF (`\n`, 0x0A)**: The Unix/Linux standard for line endings.
- **CRLF (`\r\n`, 0x0D 0x0A)**: The Windows standard for line endings.

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/38074e07-2f32-41cb-90d7-6738bdbb2393/3560d775-a6f3-44ec-bc53-aba66bfe7e5b/image.png)

```bash
└─$ ./bkcrack -L index.zip
bkcrack 1.7.0 - 2024-05-26
Archive: index.zip
Index Encryption Compression CRC32    Uncompressed  Packed size Name
----- ---------- ----------- -------- ------------ ------------ ----------------
    0 ZipCrypto  Store       97eb7647           67           79 index.html
```

Making sure, it’s all good in the encryption [`ZipCrypto`] and the compression [`Store`] parts. Now, we run again.

```html
└─$ ./bkcrack -C website.zip -c index.html -p index.html -U decrypt.zip 1
bkcrack 1.7.0 - 2024-05-26
[21:39:28] Z reduction using 64 bytes of known plaintext
100.0 % (64 / 64)
[21:39:28] Attack on 125771 Z values at index 6
Keys: a18ba181 a00857dd d953d80f
78.2 % (98325 / 125771)
Found a solution. Stopping.
You may resume the attack with the option: --continue-attack 98325
[21:45:11] Keys
a18ba181 a00857dd d953d80f
[21:45:11] Writing unlocked archive decrypt.zip with password "1"
100.0 % (1 / 1)
Wrote unlocked archive.
```

Yessir. Shout-out to `@Zukane` for helping me out on this.

```html
└─$ cat index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flag</title>
</head>
<body>
    ironCTF{Wh0_us35_Z1pCrypt0_wh3n_kn0wn_PlA1nt3xt_a7t4cks_ex1s7?}
</body>
</html>
```

Flag: `ironCTF{Wh0_us35_Z1pCrypt0_wh3n_kn0wn_PlA1nt3xt_a7t4cks_ex1s7?}`
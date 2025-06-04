- WASM is  provide native performance on the web with  retaining compability with the surrounding ecosystems and c
- _WASM is not a assembly language ,it is for browser_
- ![[Pasted image 20250409221402.png]]


# WASM CREATION FLOW
![[Pasted image 20250410190548.png]]

![[Pasted image 20250410190556.png]]


```
C / C++ / Rust / Go
        ↓
     LLVM IR
        ↓
   ↓↓ Compiled ↓↓
     .wasm file   (binary, fast, compact)
        ↓
   ↓ Optionally ↓
     .wat file    (text, human-readable — for debugging or writing by hand)


```


### CTF prespective

```
.wasm file (from the web or challenge)
        ↓
  wasm2wat
        ↓
.wat file (human-readable)
        ↓
Analyze for:
- Flag check logic
- Comparisons / hashes
- Memory patterns
- Obfuscation

```

```
.wat (patched or edited)
    ↓
wat2wasm
    ↓
New .wasm (run or test patched logic)

```


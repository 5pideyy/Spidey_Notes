### Prereqisite

check security measures

```
pwn checksec <file>
```

to run a file using gdb


```
gdb ./filename
```


to dessemble a function

```
disass <function name>
```

![[Pasted image 20240424213638.png]]

to beautify

```
set disassembly-flavor intel
```


to set breakpoint

```
break <functionname>
```


eg to set break point in main

```
break main
```
or

to set break point inside main function

```
 b *main+25
```

or 

```
b *0x08048414
```

to run 
```
run
```
or
```
r
```

to get info abt breakpoints

```
info breakpoints
```

delete breakpoints

```
delete <brk sno num>
```


To view current stack frame (can find out the address of rip and rbp)

```
info frame
```

to find out in which address out input is stored
- give random input 
- and use search pattern command
- ![[Pasted image 20240501122758.png]]

```
search-pattern 15935728
```

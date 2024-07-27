[Basics](https://tryhackme.com/r/room/x8664arch)




Different form of Assembly language

→ Intel → ARM → MIPS

We have different architectures. → Intel-32 Bit → Intel-64 Bit



### Register

small fast storage area in CPU ,hold data that are processed or executed by CPU

You're given 8-32 global variables of fixed size to work with, called 
"registers"

32 insense 4 char

![[Pasted image 20240423210819.png]]



##### what are global register?and what are other ones?

**General-Purpose Registers**-storage locations in cpu and used to process 

**Fixed Size**-size of the register is fixed 

**Global Variables**-can be accessed any part of the program

**Usage**-CPU to store data temporarily during program execution

**special registers**-"Program Counter" tells cpu which instruction to be executed next incresed frequently


![[Pasted image 20240423210535.png]]

Mnemonic-type of instruction
Source-where our data is originating from
Destination- where our result will be stored
```
AL-low-order byte of the AX register
AH-high-order byte of the AX register
```

```
rbp: Base Pointer, points to the bottom of the current stack frame
rsp: Stack Pointer, points to the top of the current stack frame
rip: Instruction Pointer, points to the instruction to be executed

General Purpose Registers
These can be used for a variety of different things
rax:
rbx:
rcx:
rdx:
rsi:
rdi:
r8:
r9:
r10:
r11:
r12:
r13:
r14:
r15:
```

to view i n assembly
```
objdump <elf_file>
```
### Register Breakdown


E and R used in Registers are the mode of architecture E-->32 bit , R --> 64 bit and without these both 16 bit







```
mov EAX, 0x12345678
```


this moves the32 bit value into EAX

![[Pasted image 20240423211626.png]]

to retrive 0x5678 AX ,like wise...

```
**mov eax , 0x12345678** put value 0x12345678 in eax

**mov eax , [0x12345678]** put the value stored in this address 0x12345678

When we put square brackets — [ ] it represent pointer

```


### Arithmetic Operations
![[Pasted image 20240423212704.png]]

#### FLAGS
- Conditions stored in flag variable
- updated by comparison,arithmetic 



![[Pasted image 20240425211942.png]]







### Control flow

```
Flags - a way of storing the result from an action

Helps to store result when compare two variables

Flags stored in EFLAGS Register store on/off
```


Depends on Flag we can jump to differnt parts using 

![[Pasted image 20240423213552.png]]
![[Pasted image 20240425182558.png]]


### Example
try 
![[Pasted image 20240423213804.png]]
```
"loop" label

Labels to give us reference points, which we can then easily jump to
```

###  Endianness

use checksec command to veiw what type of endianness is used
```
checksec <filename> or
rabin2 -I <filename> | grep endian
```

Endianness-way of  sequence of bytes are stored in memory based on significance.

for 0x12345678 the byte 0x12 has the most significance

![[Pasted image 20240423214310.png]]

### Function

```
call -Similar to jump command, but once finished, returns to the next specified instruction(PUSHES rip )

ret — Tells the program to resume execution from after the last call instruction.(POPS rip)
```

after function execution where to start executing???

call remembers address to return ...when ret is encountered

now where this address is stored????

this to be stored in less likely overwritten so we use ==**the stack**!==


#### So what is a stack?
buffer....LIFO buffer
![[Pasted image 20240423220401.png]]


```
EBP - ' **base pointer**' point at the base (start) address of the stack
helps to know not to go out of bound 
ESP - ' **stack pointer**'  point the top of the stack ,points most recently added element in the stack
EIP - "Instruction Pointer", points to the instruction to be executed
```



#### System Calls

- Trigger by the value in RAX
- arguments in rdi,rsi,rdx,r10,r8,r9
- return value stored in RAX (-1 reprst error)
**Example**: To execute read function 
![[Pasted image 20240425213423.png]]
first argument into rdi and so on






## Base Pointer & Instruction Pointer

 - Base Pointer points at the value at top of the stack 
 
 - instruction pointer stores the value of the next instruction to be executed
 
==These both address are stored in stack==
 ```
 in x64 the saved base pointer is stored at `rbp+0x0` and the saved instruction pointer is stored at `rbp+0x8`.
```


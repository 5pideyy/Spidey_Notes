---
share_link: https://share.note.sx/1mjkdugm#//NHitAeZp7j5R2/2GWDh1s3vSMjSm5IATTdPl1ajF0
share_updated: 2024-11-26T15:26:04+05:30
---


![[Pasted image 20241126113706.png]]


![[Pasted image 20241126113822.png]]
![[Pasted image 20241126114200.png]]

![[Pasted image 20241126113850.png]]



---

### **==Types of Addressing Modes==**

Below are the most common addressing modes with explanations and examples:


### **1. Immediate Addressing Mode**

In **immediate addressing**, the operand is specified directly in the instruction. This is used when the operand is a constant value. The value is encoded as part of the instruction itself.

### **Example in ARM Assembly:**

```
MOV R0, #5  ; Move the immediate value 5 into register R0
```

Here, `#5` is the **immediate value**, meaning that the value `5` is directly embedded into the instruction.

- **Usage**: Often used for small, constant values.
- **Pros**: Simple and fast, no memory lookup required.
- **Cons**: Limited to small data sizes that can be encoded within the instruction.

---

### **2. Register Addressing Mode**

In **register addressing**, the operand is located in a register. The instruction directly specifies the register that holds the data.

### **Example:**

```
MOV R0, R1  ; Move the value from register R1 into register R0
```

In this case, the contents of register `R1` are copied to register `R0`. Both operands are stored in registers, making this mode very fast.

- **Usage**: Often used for temporary data storage or operations involving arithmetic and logical operations.
- **Pros**: Fast, as registers are accessed quickly compared to memory.
- **Cons**: Limited by the number of registers available.

---

### **3. Direct (Absolute) Addressing Mode**

In **direct addressing**, the memory address of the operand is provided in the instruction. The operand is stored at the given address, and the processor fetches the operand from that memory location.

### **Example:**

```
LDR R0, [0x1000]  ; Load the value from memory address 0x1000 into register R0
```

Here, the value is loaded from the **memory address** `0x1000` into register `R0`.

- **Usage**: Accesses specific memory locations directly.
- **Pros**: Simple to use when working with known memory addresses.
- **Cons**: Slower than register addressing since accessing memory takes more time.

---

### **4. Register Indirect Addressing Mode**

In **register indirect addressing**, the memory address of the operand is stored in a register. The instruction specifies the register that holds the memory address, and the processor fetches the operand from that memory location.

### **Example:**

```
LDR R0, [R1]  ; Load the value from the memory address stored in R1 into register R0
```

In this example, the memory address is stored in `R1`. The processor loads the value from that address into `R0`.

- **Usage**: Used for pointers or indirect memory access.
- **Pros**: Flexible for accessing variable memory locations.
- **Cons**: Requires an additional register to hold the address.

---

### **4. Indexed (Offset) Addressing Mode**

**Indexed addressing** is similar to register indirect addressing but with an additional offset (or index). The effective address is calculated by adding an offset to the value in the base register.

There are three types of indexed addressing in ARM:

- **Pre-indexed** addressing
- **Post-indexed** addressing
- **Offset** addressing

### a. **Pre-indexed Addressing**

The offset is added to the base register before the memory access takes place. The result is used as the effective address.

```
LDR R0, [R1, #4]  ; Load value from address (R1 + 4) into R0
```

Here, the processor fetches the value from the memory location `R1 + 4`.

### b. **Post-indexed Addressing**

The memory address in the base register is used first, and then the offset is added afterward to update the base register.

```
LDR R0, [R1], #4  ; Load value from address in R1 into R0, then add 4 to R1
```

Here, the processor loads the value from the address in `R1`, then adds `4` to `R1`.

### c. **Offset Addressing**

The base register and offset are added together, but the result does not affect the base register.

```
LDR R0, [R1, R2]  ; Load value from address (R1 + R2) into R0
```

In this case, the value in `R2` is added to `R1`, but `R1` is not updated.

- **Usage**: Commonly used for accessing elements in arrays or structs.
- **Pros**: Flexible for accessing data structures where the offset varies.
- **Cons**: Requires additional computation to calculate the effective address.



---

### ==What is Endianness?==

**Endianness** refers to the order in which bytes are arranged to represent larger data types (such as integers or floating-point numbers) in computer memory. Specifically, it defines how the **byte sequence** of multi-byte data (like 16-bit, 32-bit, or 64-bit numbers) is stored in **memory** or transmitted over a network.

### Two Types of Endianness:

1. **Big-Endian**
2. **Little-Endian**

These terms describe the **byte order** in which multi-byte data is stored in memory.

### 1. **Big-Endian**

In **Big-Endian** format, the **most significant byte (MSB)** (the "big end") is stored **at the smallest memory address**. The **least significant byte (LSB)** is stored at the highest memory address.

- The **most significant byte** is the byte that represents the largest part of the number.
- The **least significant byte** represents the smallest part of the number.

#### Example of Big-Endian Representation

Consider a 32-bit integer `0x12345678` (in hexadecimal notation), which is stored in memory as:



```
Memory Address   | 0x00   | 0x01   | 0x02   | 0x03 ----------------------------- Data             | 0x78   | 0x56   | 0x34   | 0x12
```

Here, `0x12` (the most significant byte) is stored at the lowest address (`0x00`), followed by `0x34`, `0x56`, and `0x78` (the least significant byte) at the highest address (`0x03`).

### 2. **Little-Endian**

In **Little-Endian** format, the **least significant byte (LSB)** is stored **at the smallest memory address**, while the **most significant byte (MSB)** is stored at the highest memory address.

#### Example of Little-Endian Representation

For the same 32-bit integer `0x12345678`, the byte order in **Little-Endian** format would look like this:



```
Memory Address   | 0x00   | 0x01   | 0x02   | 0x03 ----------------------------- Data             | 0x78   | 0x56   | 0x34   | 0x12
```

Here, `0x78` (the least significant byte) is stored at the lowest address (`0x00`), followed by `0x56`, `0x34`, and `0x12` (the most significant byte) at the highest address (`0x03`).





### **==Types of Instructions in Computer Architecture==**

#### **1. Data Processing (Arithmetic and Logical) Instructions**

These instructions perform **arithmetic** (addition, subtraction, multiplication, etc.) and **logical** (AND, OR, NOT, etc.) operations on the data in the registers. These operations do not typically involve memory and operate directly on registers.

##### **Examples in ARM Assembly:**

- **Addition/Subtraction**:
- **Multiplication/Division**:
- **Logical Operations** (AND, OR, XOR):
- **Comparison** (CMP):

**Purpose**: To perform mathematical or logical manipulations on data.

```
CMP R1, R2      ; Compare R1 and R2 (sets condition flags)
```

```
AND R1, R2, R3  ; R1 = R2 AND R3ORR R4, R1, R2  ; R4 = R1 OR R2EOR R5, R4, R3  ; R5 = R4 XOR R3
```

```
MUL R1, R2, R3  ; R1 = R2 * R3
```

```
ADD R0, R1, R2  ; R0 = R1 + R2SUB R3, R0, #5  ; R3 = R0 - 5 (Immediate subtraction) 
```

#### **2 . Data Transfer Instructions**

These instructions are used to transfer data between **memory** and **registers** or between **registers** themselves. They typically involve loading data from memory into a register or storing the contents of a register into memory.

##### **Examples in ARM Assembly:**

- **Load** (from memory to register):
- **Store** (from register to memory):
- **Move** (register to register or immediate to register):

**Purpose**: To move data between registers and memory or between registers themselves.

```
MOV R4, #10     ; Move the immediate value 10 into R4MOV R5, R4      ; Move the contents of R4 into R5
```

```
STR R2, [R3]    ; Store the value in R2 to the memory address stored in R3
```

```
LDR R0, [R1]    ; Load the value from the memory address stored in R1 into R0 
```


#### **3. Branch and Control Flow Instructions**

Branch and control flow instructions manage the flow of execution in a program by allowing the processor to jump to different parts of code based on certain conditions. These instructions help implement **loops**, **function calls**, **conditional statements**, and **interrupts**.

##### **Examples in ARM Assembly:**

- **Branch (unconditional)**:
- **Branch with Link (for function calls)**:
- **Conditional Branch**:
- **Return from Function**:

**Purpose**: To change the sequence of execution, either conditionally or unconditionally. They allow the implementation of loops, conditional operations, and function calls.

```
MOV PC, LR      ; Return from subroutine by moving LR to PC
```

```
BEQ label       ; Branch to label if the previous result was equal (zero flag set)BNE label       ; Branch to label if the previous result was not equal (zero flag clear)
```

```
BL subroutine   ; Branch to subroutine and store return address in LR (Link Register)
```

```
B label         ; Branch to the memory address labeled as 'label'
```


#### **4. Shift and Rotate Instructions**

Shift and rotate instructions manipulate the bits of a register by shifting or rotating them left or right. These operations are useful for performing arithmetic operations (like multiplying or dividing by powers of 2) and for bit manipulations.

##### **Examples in ARM Assembly:**

- **Shift Left**:
- **Shift Right**:
- **Rotate Right**:

**Purpose**: These instructions are used for bit-level manipulations, such as multiplying, dividing, and bitwise rotations.

```
ROR R4, R5, #3  ; Rotate Right (R4 = R5 rotated right by 3 bits)
```

```
LSR R2, R3, #1  ; Logical Shift Right (R2 = R3 shifted right by 1 bit)
```

```
LSL R0, R1, #2  ; Logical Shift Left (R0 = R1 shifted left by 2 bits)
```



---

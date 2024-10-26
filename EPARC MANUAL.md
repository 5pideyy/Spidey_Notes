**Embedded Processor Architecture - EPARC Manual**

**Name:** [Your Name]  
**Roll No:** [Your Roll No]  
**Course Code:** U18EC15206  
**Date:** [Your Date]

---

|S. No|Experiment Name|Page No.|
|---|---|---|
|1|Basic Arithmetic Operations|1|
|2|Shift Operations|3|
|3|Factorial Calculation|5|
|4|Maximum of Two Numbers|7|
|5|Calculating the Square of a Number|9|
|6|Counting Zeros and Ones in a 32-bit Value|11|
|7|Converting BCD to Binary|13|
|8|Bubble Sort Implementation|15|

---

### Experiment 1: Basic Arithmetic Operations

**Objective:**  
To create an ARM Assembly Language Program (ALP) that performs addition, subtraction, and multiplication on two 64-bit numbers.

**Program:**

```
AREA ARITH_OPS, CODE, READONLY
LDR R0, =0x64      
LDR R1, =0x32      
ADD R2, R0, R1     
SUB R3, R0, R1     
MUL R4, R0, R1     
END
```


**Expected Output:**  
The registers hold the outcomes of addition, subtraction, and multiplication.

**Result:**  
This experiment successfully demonstrates how to perform basic arithmetic operations using ARM instructions for two 64-bit values.

---

### Experiment 2: Shift Operations

**Objective:**  
To apply logical shift left (LSL) and logical shift right (LSR) on a 64-bit number in ARM Assembly Language.

**Program:**

```
AREA SHIFTS, CODE, READONLY
LDR R0, =0x20      
LSL R1, R0, #2     
LSR R2, R0, #2     
END
```


**Expected Output:**  
Registers R1 and R2 contain the results of the left and right shifts, respectively.

**Result:**  
This program demonstrates how to perform bitwise shift operations, allowing for manipulation of data at the binary level.

---

### Experiment 3: Factorial Calculation

**Objective:**  
To implement an ARM Assembly Language Program (ALP) that calculates the factorial of an 8-bit number by using iterative multiplication.

**Program:**

```assembly
AREA FACTORIAL, CODE, READONLY
MOV R0, #5         
MOV R1, #1         
FACTORIAL_LOOP
MUL R1, R1, R0     
SUB R0, R0, #1     
CMP R0, #1
BGT FACTORIAL_LOOP
END
```




**Expected Output:**  
R1 contains the calculated factorial.

**Result:**  
The program effectively calculates the factorial of a small integer, using looping and multiplication instructions to demonstrate ARM’s arithmetic capabilities.

---

### Experiment 4: Maximum of Two Numbers

**Objective:**  
To use ARM Assembly Language to compare two 32-bit numbers and store the largest value.

**Program:**

```
AREA COMPARE, CODE, READONLY
LDR R0, =0x32      
LDR R1, =0x28      
CMP R0, R1
MOVGT R2, R0       
MOVLE R2, R1       
END
```


**Expected Output:**  
Register R2 will hold the larger of the two values.

**Result:**  
This ALP demonstrates comparison and conditional instructions, enabling selection of the maximum of two values.

---

### Experiment 5: Calculating the Square of a Number

**Objective:**  
To develop an ALP that squares a given number and stores the result in a specific register.

**Program:**

```
AREA SQUARE_CALC, CODE, READONLY
LDR R0, =5         
MUL R1, R0, R0     
END
```


**Expected Output:**  
The squared result is saved in register R1.

**Result:**  
This program illustrates squaring a value using ARM’s multiplication instructions, highlighting ARM’s ability to perform arithmetic operations.

---

### Experiment 6: Counting Zeros and Ones in a 32-bit Value

**Objective:**  
To count and separate the number of zeros and ones in a 32-bit binary number.

**Program:**

```
AREA BIT_COUNT, CODE, READONLY
LDR R0, =0xA3C2F1E0  
MOV R1, #0            
MOV R2, #0            
BIT_LOOP
TST R0, #1            
ADDNE R1, R1, #1      
ADDEQ R2, R2, #1      
LSR R0, R0, #1        
CMP R0, #0
BNE BIT_LOOP
END
```


**Expected Output:**  
R1 contains the count of ones, and R2 contains the count of zeros.

**Result:**  
The program accurately counts bits in a binary value, showcasing ARM’s ability for bitwise data manipulation.

---

### Experiment 7: Converting BCD to Binary

**Objective:**  
To create an ALP that converts a Binary-Coded Decimal (BCD) into its binary equivalent.

**Program:**

```
AREA BCD_TO_BIN, CODE, READONLY
LDR R0, =0x25       
MOV R1, #0          
MOV R2, #0          
CONVERSION_LOOP
AND R3, R0, #0xF    
ADD R1, R1, R3, LSL R2 
LSR R0, R0, #4      
ADD R2, R2, #4      
CMP R0, #0
BNE CONVERSION_LOOP
END
```


**Expected Output:**  
The converted binary value is stored in R1.

**Result:**  
This experiment effectively transforms a BCD number into binary format, illustrating data conversion techniques in ARM assembly.

---

### Experiment 8: Bubble Sort Implementation

**Objective:**  
To use the bubble sort algorithm in ARM Assembly Language to arrange an array in ascending order.

**Program:**

```
AREA SORT_ALG, CODE, READONLY
LDR R0, =ARRAY_START 
MOV R1, #5           
SORT_OUTER_LOOP
MOV R2, R0           
MOV R3, #0           
SORT_INNER_LOOP
LDR R4, [R2]         
LDR R5, [R2, #4]     
CMP R4, R5
BLE NO_SWAP          
STR R5, [R2]         
STR R4, [R2, #4]
MOV R3, #1           
NO_SWAP
ADD R2, R2, #4       
SUB R1, R1, #1       
CMP R1, #0
BGT SORT_OUTER_LOOP
END
```


**Expected Output:**  
The array is sorted in ascending order.

**Result:**  
This program demonstrates the bubble sort technique in ARM Assembly Language, showing ARM’s capacity to handle array-based sorting through iterative operations.
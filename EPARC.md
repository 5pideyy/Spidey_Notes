---
share_link: https://share.note.sx/z3jvw8q4#ulhUF3PoWGDuyHz2L0C2feaSVDZCDozwYkTT9eoHWvE
share_updated: 2024-11-26T10:54:11+05:30
---

# UNIT 3

![[Pasted image 20241126113706.png]]


![[Pasted image 20241126113822.png]]
![[Pasted image 20241126114200.png]]

![[Pasted image 20241126113850.png]]



# UNIT 4

### **Types of Memory:**

Memory in a computer system can be classified into different types based on its purpose, speed, and volatility. Here’s an overview of the different types:

1. **Primary Memory (Main Memory)**:
    - **RAM (Random Access Memory)**: Volatile memory that temporarily stores data and programs the CPU is currently using.
    - **ROM (Read-Only Memory)**: Non-volatile memory used to store critical programs (like the BIOS) that do not change and are needed to boot up the system.
2. **Secondary Memory (Storage)**:
    - **Hard Drives (HDD) and Solid-State Drives (SSD)**: Non-volatile memory that provides long-term data storage. It is slower but provides much larger capacity than primary memory.
3. **Cache Memory**:
    - A small, fast type of memory located close to the CPU, used to store frequently accessed data to speed up processes.
4. **Virtual Memory**:
    - A memory management technique that gives the illusion of more RAM by using a portion of the hard drive as if it were RAM.

---

### **Memory Hierarchy:**

The **memory hierarchy** organizes memory types by speed, size, and proximity to the CPU. From top to bottom, the hierarchy represents a trade-off between speed and capacity:

1. **Registers**:
    - Located inside the CPU, they provide the fastest access to data but are very small in size.
2. **Cache Memory**:
    - Directly connected to the CPU, it is faster than RAM but smaller in size. It stores frequently accessed data to reduce the time to fetch it from main memory.
3. **Main Memory (RAM)**:
    - Slower than cache but larger. It is where active programs and data are stored.
4. **Secondary Storage (HDD/SSD)**:
    - Much slower but has high capacity. It's used for long-term data storage.
5. **Virtual Memory**:
    - An extension of RAM, implemented using a portion of secondary storage (like the hard disk), used to run larger programs than the physical RAM can handle.

---

### **ROM (Read-Only Memory)**:

**ROM** is non-volatile memory, meaning it retains its data even when the system is powered off. It is used to store firmware or other essential programs that do not need to change.

### **Types of ROM**:

1. **Mask ROM**:
    - The data is permanently written during the manufacturing process. It cannot be changed or reprogrammed.
2. **PROM (Programmable ROM)**:
    - Can be programmed once after manufacturing. After writing the data, it becomes permanent.
3. **EPROM (Erasable Programmable ROM)**:
    - Can be erased using ultraviolet light and reprogrammed multiple times.
4. **EEPROM (Electrically Erasable Programmable ROM)**:
    - Can be erased and reprogrammed electronically without removing the chip. It is used in BIOS and other firmware storage.
5. **Flash Memory**:
    - A type of EEPROM that can be erased and reprogrammed in blocks. Used in USB drives, SSDs, and SD cards.

---

### **Cache Memories**:

**Cache memory** is a small, high-speed memory located close to or inside the CPU. It stores frequently used data and instructions, allowing the CPU to access this information quickly.

### **Levels of Cache**:

1. **L1 Cache**:
    - The smallest and fastest cache, located inside the CPU. It is divided into instruction cache and data cache.
2. **L2 Cache**:
    - Larger than L1 but slower, it may be located inside or outside the CPU.
3. **L3 Cache**:
    - Larger and slower than L2, L3 is shared among cores in multi-core processors.

### **Performance Considerations**:

- Cache improves the system's overall performance by reducing the time the CPU needs to fetch data from main memory.
- **Cache Miss**: Occurs when the required data is not found in the cache, leading to slower memory access.
- **Cache Hit**: Occurs when the required data is found in the cache, speeding up data retrieval.

---

### **Virtual Memory**:

**Virtual memory** is a memory management technique that allows the system to use more memory than physically available by extending RAM using the hard drive. It creates a "virtual" address space.

### Key Concepts:

- **Paging**: Virtual memory is divided into pages (fixed-size blocks), which can be moved between physical memory and disk storage.
- **Swapping**: When physical RAM is full, pages that aren't immediately needed are swapped out to the disk to free up space.
- **Page Fault**: When a program tries to access a page that is not currently in RAM, a page fault occurs, causing the system to load the page from disk to memory.

### Advantages of Virtual Memory:

- Allows larger programs to run on a system with limited RAM.
- Isolates memory for different processes, increasing security.

### Disadvantages:

- Slower than using physical memory due to the slower access speed of secondary storage (disk).

---

### **MMU (Memory Management Unit) & MPU (Memory Protection Unit)**:

### **Memory Management Unit (MMU)**:

- The **MMU** is a hardware component responsible for translating virtual addresses (used by programs) into physical addresses (used by hardware).
- It handles memory protection, ensuring that one process does not access memory allocated to another process.
- The MMU also manages page tables, which map virtual pages to physical frames in memory.

### **Memory Protection Unit (MPU)**:

- The **MPU** is a simpler version of the MMU, often found in embedded systems.
- It ensures that programs cannot access restricted areas of memory, providing basic memory protection.
- Unlike the MMU, the MPU does not perform address translation, making it simpler and faster but less flexible.

---

### **Secondary Storage**:

Secondary storage refers to non-volatile storage devices used to store data and programs that are not in active use. It is slower but has much larger capacity than primary memory (RAM).

### **Types of Secondary Storage**:

1. **Hard Disk Drive (HDD)**:
    - A mechanical device that uses spinning disks to read/write data. It has large capacity but slower access times compared to newer storage technologies.
2. **Solid-State Drive (SSD)**:
    - A faster storage medium that uses flash memory to store data. It has no moving parts, which makes it more reliable and much faster than HDDs.
3. **Optical Storage (CDs, DVDs)**:
    - Uses lasers to read/write data on disks. Optical media are slower and less commonly used today.
4. **Magnetic Storage (Tapes, Floppy Disks)**:
    - Used in older systems and for archival purposes, where large amounts of data are stored for long periods.

### **Performance Considerations**:

- **Speed**: SSDs are significantly faster than HDDs due to their lack of mechanical parts.
- **Reliability**: SSDs are more reliable since they are less prone to physical damage compared to HDDs, which have moving parts.
- **Capacity**: HDDs generally offer higher capacities at a lower cost per GB compared to SSDs.

---

### **Performance Considerations in Memory Systems**:

- **Latency**: The delay before data can be accessed. Lower latency means faster performance.
- **Bandwidth**: The amount of data that can be transferred per second. Higher bandwidth leads to better performance.
- **Memory Access Patterns**: Programs that frequently access the same data benefit more from cache memory.
- **Cache Efficiency**: Cache misses reduce performance since the CPU must wait for data from slower main memory or secondary storage.
- **Virtual Memory Overhead**: Excessive use of virtual memory (page faults) can degrade performance as data is swapped in and out of disk storage.

---




# UNIT 5
---
### What is JTAG?

JTAG (Joint Test Action Group) is a standard interface used primarily for testing, debugging, and programming electronic devices, especially integrated circuits (ICs). It was originally developed as a way to facilitate the testing of printed circuit boards (PCBs), but over time, it has evolved into a more general tool for debugging and programming hardware.

JTAG allows engineers to access and control the internals of a device through a special test interface, without needing to physically probe the individual pins of the device. This is particularly useful for diagnosing faults, testing connections, and ensuring that components work as expected.

### Key Components of JTAG

1. **Boundary Scan Cells**
    
    - These are small circuits placed at the input/output (I/O) pins of a device. They are part of the boundary scan architecture and help monitor, capture, and control the data passing through the I/O pins.
    - The boundary scan cells allow data to be tested or manipulated without having direct physical access to the pins, making the process faster and less intrusive.
2. **Test Access Port (TAP)**
    
    - The TAP is the interface used to communicate with the JTAG system. It's the entry point for controlling the device during testing, debugging, and programming.
    - The TAP consists of 5 pins that provide access to the device:
        1. **TDI (Test Data Input):** The input pin where test data is sent into the device.
        2. **TDO (Test Data Output):** The output pin where the test data is received from the device.
        3. **TCK (Test Clock):** The clock signal that synchronizes the operation of the TAP.
        4. **TMS (Test Mode Select):** This pin controls the state of the test process and selects which action is taken (Capture, Shift, or Update).
        5. **TRST (Test Reset):** This pin is used to reset the TAP controller, allowing the JTAG interface to be re-initialized.

### JTAG Modes

JTAG operates in several modes that control the behavior of the boundary scan cells:

1. **Capture Mode:**
    
    - In this mode, the device captures the current state of its input and output pins (e.g., whether the pin is high or low). This is the initial step in testing, as it records the current state of the device.
2. **Shift Mode:**
    
    - In the shift mode, the captured data is "shifted out" (to be read) while new test data is shifted in. This allows for the device to undergo further tests or for additional control data to be sent.
3. **Update Mode:**
    
    - In this mode, the test data that was shifted in is applied to the pins of the device, effectively changing their state (e.g., setting a pin high or low). This is when the actual "testing" happens, as the device is tested with new data or instructions.

### How JTAG is Used

JTAG is a versatile tool that can be used in a variety of scenarios:

- **Debugging:** Engineers use JTAG to interact with a device's internal state, helping identify issues such as faulty circuits or incorrect logic states.
- **Programming:** JTAG can be used to program devices, such as Flash memory or FPGAs, by directly writing data to them through the boundary scan interface.
- **Testing:** It allows for quick and automated testing of PCBs, ensuring that the connections between various components are functioning properly without the need for external test equipment.

---

### **Basics of AMBA**

1. **Definition**:
    - AMBA is a bus architecture designed for System-on-Chip (SoC) communication in microcontroller-based systems.
    - It defines the interconnection of various components within a chip, such as address, data, and control buses.
2. **Purpose**:
    - To minimize the silicon area and infrastructure.
    - To support modular system design.
    - To make the system technology-independent and enhance scalability.
3. **Functional Role**:
    - Provides an interface to functional blocks of microcontrollers, enabling efficient communication.


![[Pasted image 20241126105157.png]]
### **Possible Functional Blocks on Board**

These blocks can interact within the AMBA framework:

- **Microcontroller/Microprocessor**: Main computational unit.
- **Memory**: Includes SRAM, DRAM, EPROM, or Flash memory.
- **DSP (Digital Signal Processor)**: For signal processing tasks.
- **DMA (Direct Memory Access)**: Enables direct transfer of data between memory and peripherals.
- **Peripherals**: Such as USB, SPI, I2C, IO Ports, ADC/DAC, Timers, etc.


### **AMBA Standards**

AMBA defines several bus protocols to suit different system needs:

1. **AHB (Advanced High-Performance Bus)**:
    - High-bandwidth, high-speed interface.
    - Supports components like DMA, DSP, memory controllers, and CPUs.
    - Features master-slave communication and supports multiple masters/slaves.
    - **Supports Burst Transfers**: For efficient data handling.
    - Used for high-speed data transfers between performance-critical components.
2. **APB (Advanced Peripheral Bus)**:
    - Designed for low-bandwidth peripherals like UART, timers, and GPIO.
    - Simpler protocols without pipeline support (low power and simpler to implement).
    - **Master-Slave Configuration**: The bridge acts as the master, while peripherals act as slaves.
    - **No Burst Transfers**: Transfers are simpler, focusing on low-speed data.
3. **ASB (Advanced System Bus)**:
    - An older AMBA standard, often replaced by AHB in modern designs.
4. **ATB (Advanced Trace Bus)**:
    - Used for debug and trace operations within the system.
5. **AXI (AMBA Extensible Interface)**:
    - Advanced interface designed for high-speed systems and modern SoCs.
    - **Supports Burst Transfers, Out-of-Order Execution, and Multiple Channels**: Ensures efficient high-bandwidth communication.


### **AMBA Architecture Overview**

- **High-Performance Components**: Use AHB/AXI for fast communication (e.g., ARM CPU to memory).
- **Low-Speed Peripherals**: Use APB for simple control and data communication (e.g., UART, Timers).
- **Bridges**: Link high-speed and low-speed buses for seamless integration.



### **Key Features**

- Modular design supporting **scalability** and reuse.
- Efficient interconnect for diverse functional blocks (e.g., CPU, memory, peripherals).
- Technology-agnostic, allowing integration across various process technologies.

---

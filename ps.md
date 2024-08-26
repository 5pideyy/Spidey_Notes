--
## *Collaborative Assignment Report*

*Course:* ETHICAL HACKING AND NETWORK DEFENCE  
*Date:* 26-08-2024 
*Team Members:*  
- Member 1: Vishwa J (22BAD116)  
- Member 2: Yogesh C (22BAD118)  
- Member 3: Charaneesh A P (22BAD119)

---

### *Table of Contents*

1. [Introduction](#introduction)  
2. [Creation and Deployment](#creation-and-deployment)  
3. [Analyzing the Trojan Behavior](#analyzing-the-trojan-behavior)  
4. [Detecting and Mitigating the Trojan](#detecting-and-mitigating-the-trojan)  
5. [Conclusion](#conclusion)  
6. [Collaborative Contribution](#collaborative-contribution)  
7. [References](#references)

---

### *Introduction*

Trojans are a type of malicious software designed to deceive users by appearing as legitimate applications while secretly performing harmful actions. This report details the creation, analysis, detection, and mitigation of a simple Trojan as part of a collaborative assignment. The objective is to understand the behavior of Trojans, how they can be detected, and the steps required to mitigate their impact.

---

### *Creation and Deployment*

#### *1.1. Creation of the Trojan*

The Trojan was developed using Python. It was designed to create a backdoor on the target machine, allowing an attacker to execute arbitrary commands remotely. Below is the code used to create the Trojan:

python
```
import socket

def create_backdoor():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('0.0.0.0', 8080))
    s.listen(1)
    conn, addr = s.accept()
    print(f"Connection established with {addr}")
    
    while True:
        command = conn.recv(1024).decode()
        if command.lower() == 'exit':
            break
        else:
            conn.send('Command executed'.encode())
    
    conn.close()

create_backdoor()
```

*Explanation*:  
The Trojan opens a listening socket on port 8080. When a connection is established, it allows the attacker to send commands to the infected machine. The backdoor runs indefinitely until the attacker sends an 'exit' command.

#### *1.2. Deployment of the Trojan*

The Trojan was deployed on a controlled virtual machine environment to prevent any unintentional damage. The machine was configured to simulate a typical user environment, making it an ideal target for the Trojan.

---

### *Analyzing the Trojan Behavior*

#### *2.1. Network Traffic Analysis*

*Tools Used*: Wireshark, netstat

During the operation of the Trojan, network traffic was captured using Wireshark. The traffic analysis revealed the following:

- *Connection Establishment*: A TCP connection was established between the attacker's machine and the victim's machine on port 8080.
- *Data Transfer*: Commands sent by the attacker were visible as unencrypted text, making the nature of the communication clear.

*Wireshark Analysis*:  
The following screenshot shows the traffic captured by Wireshark, highlighting the TCP connection and data packets exchanged between the attacker and the victim.

[Insert Wireshark Screenshot Here]

#### *2.2. System Behavior Analysis*

*Tools Used*: Process Monitor, Task Manager

System behavior was monitored to detect any anomalies caused by the Trojan:

- *Process Creation*: The Trojan created a new process on the victim's machine, which was visible in the Task Manager as a Python process.
- *File and Registry Changes*: No significant file or registry changes were observed, as the Trojan primarily operated in memory.

*Process Monitor Analysis*:  
The following screenshot shows the process created by the Trojan, which was identified and isolated for further investigation.

[Insert Process Monitor Screenshot Here]

---

### *Detecting and Mitigating the Trojan*

#### *3.1. Detection Techniques*

*Tools Used*: Antivirus Software, Manual Analysis

Detection was attempted using standard antivirus software, which successfully identified the Trojan as a potentially harmful program. Additionally, manual detection methods included using netstat to identify unusual network connections and tasklist to identify suspicious processes.

*Antivirus Detection*:  
The antivirus software flagged the Trojan and quarantined it. The detection was based on the behavior patterns of the Trojan, particularly the network activity.

*Manual Detection*:  
By running the command netstat -an, we were able to identify the open connection on port 8080, which was not consistent with normal system operations.

#### *3.2. Mitigation Strategies*

Mitigation involved several steps:

- *Terminating the Process*: The Trojan's process was terminated using the taskkill command.
- *Closing the Backdoor*: The listening socket was closed by shutting down the associated process.
- *System Scanning*: A full system scan was performed to ensure no remnants of the Trojan were left behind.

*Example Commands*:
bash
taskkill /F /PID [Process ID]
netstat -an | find "8080"


*Mitigation Outcome*:  
The mitigation was successful, and no further unauthorized access was observed. The system was restored to its normal state, and additional security measures were implemented to prevent similar attacks in the future.

---

### *Conclusion*

This exercise provided valuable insights into the creation, deployment, and detection of Trojans. By simulating a real-world attack scenario, we gained hands-on experience in identifying and mitigating threats. The techniques learned during this process are essential for enhancing system security and protecting against malicious software.

---

### *Collaborative Contribution*

- **Member 1 (Vishwa J) : Responsible for the creation and coding of the Trojan.
- **Member 2 (Yogesh C): Conducted network traffic analysis using Wireshark and Process Monitor.
- *Member 3 (Charaneesh A P)*: Focused on detection and mitigation strategies, including antivirus testing and manual analysis.
- *All Members*: Contributed to the final report, including documentation and analysis.

---

### *References*

1. [Python Documentation](https://docs.python.org/3/)
2. [Wireshark User Guide](https://www.wireshark.org/docs/)
3. [(PDF) The World of Malware: An Overview (researchgate.net)](https://www.researchgate.net/publication/327665678_The_World_of_Malware_An_Overview)

---
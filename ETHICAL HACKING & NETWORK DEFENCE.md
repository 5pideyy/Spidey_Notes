Name : Vishwa J
Roll No: 22BAD116
### Denial of Service (DoS) and Session Hijacking Simulation

#### Lab Objective:
The purpose of this lab is to simulate **Denial of Service (DoS)** and **Session Hijacking** attacks using various tools such as **Teardrop** and **DDoS** methods, and to analyze their effects on network integrity and session security.

---

## Part 1: Denial of Service Attack Using Teardrop

### Step 1: Lab Setup
- **Attacker**: Kali Linux (IP: 10.1.75.54)
- **Victim**: Ubuntu or Windows (IP: 10.1.75.59)
- Both machines should be in the same network. For VirtualBox or VMware, ensure the machines are on the same internal network.
  
### Step 2: Understanding the Teardrop Attack
The **Teardrop attack** exploits the way IP packet fragments are reassembled, causing the victim machine to crash or slow down. Fragmentation offsets in IP headers are manipulated to overlap and confuse the reassembly process, creating memory overload and possible system crashes.

### Step 3: Simulating the Teardrop Attack

#### Code for the Attacker (Kali Linux):
```bash
# Sending fragmented packets to the victim machine using hping3
sudo hping3 -c 10000 -d 120 -S -w 64 --frag --fragoff 64 --flood --rand-source 10.1.75.59
```


![[Pasted image 20240930164546.png]]
### Step 4: Analyzing the Traffic with Wireshark
1. On the **victim machine**, open **Wireshark**.
2. Apply the following filter to capture incoming fragmented packets:
   ```bash
   ip.frag_offset > 0
   ```
3. Run the attack from the **attacker machine** and observe the incoming traffic in **Wireshark**.
4. Monitor the victim machine's CPU and memory usage using the following command:
   ```bash
   top
   ```

![[Pasted image 20240930164615.png]]

---

## Part 2: Distributed Denial of Service (DDoS) Attack Simulation

### Step 1: Setting up DDoS Attack Tools
- **Attacker VMs**: Multiple Kali Linux VMs (e.g., 10.1.75.54, 10.1.75.55, etc.)
- **Victim machine**: Ubuntu running a web server (Apache or Nginx)
- Install **LOIC (Low Orbit Ion Cannon)** or **HOIC (High Orbit Ion Cannon)** on each attacker VM.

#### Code to Install LOIC (Attacker):
```bash
sudo apt-get install loic
```

### Step 2: Simulating the DDoS Attack
1. Open **LOIC** on the attacker machine.
2. Set the **victim’s IP address** (e.g., 10.1.75.59) and select attack parameters:
   - **Attack Type**: TCP, UDP, or HTTP
   - **Threads**: Simulate multiple users by increasing the number of threads.
3. Start the attack by clicking the "IMMA CHARGIN' MAH LAZER" button.

### Step 3: Monitoring the Victim Server
1. **Ping the victim machine** from another machine to check if it becomes unresponsive:
   ```bash
   ping 10.1.75.59
   ```
![[Pasted image 20240930164704.png]]
2. On the victim machine, monitor **CPU and memory usage**:
   ```bash
   top
   ```
![[Pasted image 20240930164733.png]]
3. Open the server logs on the victim machine to analyze the traffic impact:
   ```bash
   tail -f /var/log/apache2/access.log
   ```
![[Pasted image 20240930164755.png]]
### Step 4: Traffic Analysis with Wireshark
1. Open **Wireshark** on the victim machine and apply the following filter to identify fragmented packets:
   ```bash
   ip.frag_offset > 0
   ```
2. Capture traffic patterns to monitor the attack’s effect on the victim machine.
![[Pasted image 20240930164924.png]]
---

## Part 3: Session Hijacking Using MITM (Man-in-the-Middle)

### Step 1: Setting up the Attack Environment
- **Attacker**: Kali Linux (10.1.75.54)
- **Victim**: Ubuntu or Windows machine logged into a vulnerable web session.
- **Web Server**: A vulnerable web application (e.g., DVWA or custom).

### Step 2: Performing the MITM Attack
1. Install **Ettercap** on the attacker machine:
   ```bash
   sudo apt-get install ettercap-graphical
   ```
2. Start **Ettercap** in graphical mode:
   ```bash
   sudo ettercap -G
   ```
3. Set up **Unified Sniffing** and select the network interface (e.g., eth0).
4. Start **ARP spoofing**:
   - Go to **Mitm > ARP poisoning**.
   - Enable **Sniff remote connections**.
   - Add the **victim** as **Target 1** and the **web server** as **Target 2**.

### Step 3: Hijacking the Session
1. Use **Wireshark** to capture HTTP traffic between the victim and the web server.
2. Search for **session cookies** in the HTTP traffic.
3. Use the captured cookies to log into the web session from the attacker’s browser, bypassing authentication.

![[Pasted image 20240930164857.png]]![[Pasted image 20240930164922.png]]

---

## Conclusion

This lab demonstrates the severity of various network attacks, such as **Teardrop DoS**, **DDoS**, and **Session Hijacking via MITM**, by highlighting how vulnerable systems can be overwhelmed by traffic manipulation or session interception. The results gathered from traffic analysis and resource usage underscore the need for robust security measures, including improved packet reassembly protocols and session encryption, to protect against these kinds of threats.
### Key Questions
### Teardrop Attack:

1. How did the victim machine handle the influx of fragmented packets—was there a noticeable delay in reassembly, and what impact did it have on overall system performance?
2. What countermeasures could prevent the system from crashing due to fragmented packet attacks, and how effective are they in modern operating systems?

### DDoS Attack:

3. Was there a threshold where the victim server became unresponsive or crashed? How did the attack affect the throughput and latency of the network?
4. What would be the best strategy to mitigate DDoS attacks on a large-scale network, and how does traffic filtering or rate limiting work in these scenarios?

### Session Hijacking:

5. What specific vulnerabilities in the network setup allowed for successful session hijacking, and how can those vulnerabilities be patched or mitigated in future setups?
6. Could encryption (e.g., HTTPS) or stronger authentication protocols prevent the session hijacking attack? How would these methods improve security in similar environments?

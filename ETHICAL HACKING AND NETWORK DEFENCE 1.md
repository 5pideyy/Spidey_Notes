
---

# Lab Exercise: Network Traffic Analysis with Wireshark

Vishwa J 22BAD116
Yogesh C 22BAD118
Charaneesh A P 22BAD119

---

## Exercise: Network Traffic Analysis and Reporting

### Objective:
To perform various network traffic analysis tasks using Wireshark and other network utilities.

### Tasks:

### Task 1: Extract Telnet Password from Network Traffic
**Steps:**
1. Open Wireshark and start capturing traffic.
2. Filter the traffic using the Telnet protocol.
3. Locate the Telnet session and follow the TCP stream to view the plaintext password.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 2: Extract an Image from Network Traffic
**Steps:**
1. Start Wireshark and capture network traffic.
2. Filter the traffic by "HTTP" or "TCP" depending on the protocol used to transfer the image.
3. Identify the packet containing the image data, right-click and select "Follow TCP Stream".
4. Save the data as an image file.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 3: Extract Packets Sent Between a Time Period
**Steps:**
1. Open the capture file in Wireshark.
2. Use the display filter to specify the time range, e.g., `frame.time >= "start_time" && frame.time <= "end_time"`.
3. Save the filtered packets.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 4: Extract Packets Sent from a Server
**Steps:**
1. Identify the server's IP address.
2. Apply a filter using the server's IP address, e.g., `ip.src == server_ip`.
3. Analyze and save the filtered packets.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 5: Extract Packets Sent from a Specific Source to Destination
**Steps:**
1. Use a filter combining both the source and destination IP addresses, e.g., `ip.src == source_ip && ip.dst == destination_ip`.
2. Save the filtered results.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 6: Filter TCP Protocol Packets
**Steps:**
1. Apply the filter `tcp` to capture only TCP traffic.
2. Observe and analyze the filtered traffic.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 7: Filter UDP Protocol Packets
**Steps:**
1. Apply the filter `udp` to capture only UDP traffic.
2. Analyze the filtered packets.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 8: Filter HTTP Protocol Packets
**Steps:**
1. Use the filter `http` to isolate HTTP traffic.
2. Review the captured HTTP packets.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 9: Filter ARP Protocol Packets
**Steps:**
1. Apply the filter `arp` to view ARP traffic only.
2. Analyze the ARP requests and replies.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 10: Compute Minimum, Maximum, and Average Round Trip Time
**Steps:**
1. Use tools like `ping` or `traceroute` to measure RTT.
2. Extract the minimum, maximum, and average values from the output.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 11: Send ICMP Echo Request and Report Statistics
**Steps:**
1. Use the `ping` command to send ICMP requests to a domain.
2. Note the number of packets sent, received, and the round-trip times.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 12: Report the Path Taken by a Packet to a Server
**Steps:**
1. Use the `traceroute` command to track the path to a server.
2. Document each hop and its associated IP address.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 13: Report Configured Network Interfaces and IP Addresses
**Steps:**
1. Use the `ifconfig` or `ip a` command to list all network interfaces.
2. Identify the IP addresses associated with each interface.

**Screenshot:**
[Insert Screenshot Here]

---

### Task 14: Report Network Statistics of All Connections
**Steps:**
1. Use the `netstat` command to display active connections.
2. Note the protocol, local address, foreign address, and connection state.

**Screenshot:**
[Insert Screenshot Here]

---

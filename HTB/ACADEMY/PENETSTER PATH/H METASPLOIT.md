
The MSF engagement structure can be divided into five main categories.

- Enumeration
- Preparation
- Exploitation
- Privilege Escalation
- Post-Exploitation

![[Pasted image 20240728222055.png]]


### Msf Structure

| **Type**        | **Description**                                                                                 |
| --------------- | ----------------------------------------------------------------------------------------------- |
| ==`Auxiliary`== | Scanning, fuzzing, sniffing, and admin capabilities. Offer extra assistance and functionality.  |
| ==`Encoders`==  | Ensure that payloads are intact to their destination.                                           |
| ==`Exploits`==  | Defined as modules that exploit a vulnerability that will allow for the payload delivery.       |
| ==`NOPs`==      | (No Operation code) Keep the payload sizes consistent across exploit attempts.                  |
| ==`Payloads`==  | Code runs remotely and calls back to the attacker machine to establish a connection (or shell). |
| ==`Plugins`==   | Additional scripts can be integrated within an assessment with `msfconsole` and coexist.        |
| ==`Post`==      | Wide array of modules to gather information, pivot deeper, etc.                                 |

# Modules





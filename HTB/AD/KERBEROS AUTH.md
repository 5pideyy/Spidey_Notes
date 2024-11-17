


# Working 

![[Kerberos.png]]

#### **Step 1: Login and Initial Authentication**

1. **Alice logs into the Workstation (WS):**
    
    - Alice enters her username and password on the WS.
2. **WS sends a request to the Authentication Service (AS) on the Domain Controller (DC):**
    
    - The WS sends Alice’s **username** (but not the password) to the AS to initiate the authentication process.
3. **Behind the scenes at the DC:**
    
    - The AS retrieves Alice’s **hashed password** from the DC’s **NTDS.dit** database.
    - It generates a **Ticket Granting Ticket (TGT)**, which contains information like:
        - Alice’s identity.
        - Validity period of the TGT.
        - A session key for future communication.
    - The TGT is then **encrypted using Alice’s password hash**.
4. **Response to the WS:**
    
    - The DC sends the encrypted **TGT** and a **session key** back to the WS.
    - The WS **cannot read the TGT** but stores it for future use.
    - The WS uses the session key to securely communicate with the DC.

---

#### **Step 2: Requesting Access to a Resource**

1. **Alice wants to access a shared folder on a File Server:**
    
    - The WS uses the previously obtained **TGT** to request a **Service Ticket** from the Ticket Granting Service (TGS) on the DC.
2. **What happens:**
    
    - The WS sends:
        - The TGT.
        - A request specifying the resource (e.g., the File Server) to the TGS.
    - The TGS:
        - Decrypts the TGT using its own key.
        - Verifies Alice’s identity and checks the TGT's validity.
        - Generates a **Service Ticket** for the requested File Server.
3. **Response to the WS:**
    
    - The TGS sends the **Service Ticket** back to the WS.
    - The WS stores this Service Ticket to use it when contacting the File Server.

---

#### **Step 3: Accessing the File Server**

1. **WS sends the Service Ticket to the File Server:**
    
    - The WS uses the **Service Ticket** to prove Alice’s identity to the File Server.
2. **What happens on the File Server:**
    
    - The File Server verifies the Service Ticket using a **key it shares with the DC**.
    - If the ticket is valid:
        - The File Server grants Alice access to the shared folder.

---






















### 1
![[Pasted image 20241112173306.png]]
 - request encrypted with users NTLM hash(`user secret key -> NTLM HASH OF KRBTGT ACCT) 
 - this is why place to grab krbtgt account hash grabbing from DC to generate golden ticket

### 2
![[Pasted image 20241112173450.png]]

- 1) TGT name ,session key encypted with user NTLM hash
- 2)TGT ticket encrypted with KRBTGT SECRT KEY

### 3
![[Pasted image 20241112173554.png]]

### 4
![[Pasted image 20241112173811.png]]

### 5
![[Pasted image 20241112173823.png]]

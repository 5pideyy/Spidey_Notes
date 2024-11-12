
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

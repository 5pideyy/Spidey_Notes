
```
+------------------+            +-------------------------+
|  User's Machine  |            |      Remote Server      |
+------------------+            +-------------------------+
       |                                 |
       | ssh-keygen                      |
       | Generates key pair              |
       | (id_rsa, id_rsa.pub)            |
       |                                 |
       | ssh-copy-id                     |
       | Copies id_rsa.pub to            |
       | ~/.ssh/authorized_keys          |
       |                                 |
       |-------------------------------->| 
       |         SSH Connection Request  | 
       |                                 | 
       |          +----------------+     |
       |          | authorized_keys|     |
       |          +----------------+     |
       |                                 |
       |<--------------------------------|
       |        Server sends challenge   |
       |       (random number)           |
       |                                 |
       | Signs challenge with private key|
       | using id_rsa and sends response |
       |-------------------------------->|
       |                                 |
       |  Verifies response using        |
       |  public key from authorized_keys|
       |                                 |
       |<--------------------------------|
       |        Access Granted           |
       |  (if verification is successful)|
       |                                 |
+------------------+            +-------------------------+
|  User's Machine  |            |      Remote Server      |
+------------------+            +-------------------------+

```

![[Pasted image 20240808183347.png]]

![[Pasted image 20240808225438.png]]

![[Pasted image 20240808225959.png]]
![[Pasted image 20240808230022.png]]


![[Pasted image 20240808210710.png]]

![[Pasted image 20240808185007.png]]

![[Pasted image 20240808185755.png]]
![[Pasted image 20240808205332.png]]

![[Pasted image 20240808205429.png]]
![[Pasted image 20240808205444.png]]

![[Pasted image 20240808210209.png]]

![[Pasted image 20240808211156.png]]
no 2222 port running, no signserv in /var/www/
![[Pasted image 20240808213219.png]]

![[Pasted image 20240808213522.png]]

![[Pasted image 20240808192425.png]]


got ca private and public key
we generate rsa private and public key
sign public key using cs private
ssh using rsa private key


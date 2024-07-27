
![[image-removebg-preview.png]]

**find out network address/Subnet**
- `Fill the host portion of an address with binary 0's`

**find Broadcast address**

- `Fill host portion using binary 1's`

 **Find First host**

- `Fill host portion with bianry 0's and last bit as 1`

 **Find Last host**
- `Fill host portion with bianry 1's and last bit as 0`


### Example

1) IP - 192.168.1.18/24

![[Pasted image 20240721002247.png]]

2)  IP - 172.16.35.123/20 => 172.16.0010 0011.01111011 /20

![[Pasted image 20240721002921.png]]







![[Pasted image 20240721004431.png]]



==Broadcast Address = Next Network -1==

==First Host = Subnet + 1==

==Last Host = Broadcast Address -1    ==



### SUBNET

- divide a network when given
	1) specific number of host
	2) specific number of subnet

#### WHY SUBNETTING

![[Pasted image 20240721112030.png]]

- if Single Connected Wire 16,777,214 host are connected, During Broadcast of hosts network go down, collition of data happens
- so divide into subnet containing 254 host maximum per subnet




taking bits away from the host portion of address and then allocating those

stolen bits to the network portion of a new address


### RULES FOR SUBNETTING

Divide a network ==**When asked for the number of hosts:** ==

$$
Hosts = 2^n -2
$$
- Why (-2)
	- Subnet address
	- Broadcast address
- **Note:** Count host bits from right to left.

Divide a Network ==**When asked for the number of networks:**==

$$
Network = 2^n
$$

- **Note:** Count network bits from left to right.



### Example

- No of Host given 14

![[Pasted image 20240721120435.png]]


- FInd n using  $$ Hosts = 2^n -2 $$ you know Host

![[Pasted image 20240721120632.png]]


![[Pasted image 20240721120657.png]]


![[Pasted image 20240721120733.png]]


![[Pasted image 20240721120913.png]]


![[Pasted image 20240721120930.png]]



### Example

- No of Network Given

![[Pasted image 20240721121407.png]]

![[Pasted image 20240721121527.png]]

![[Pasted image 20240721121546.png]]

![[Pasted image 20240721121916.png]]

![[Pasted image 20240721121945.png]]



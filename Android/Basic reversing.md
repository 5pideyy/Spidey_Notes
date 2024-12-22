
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

```
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/.android/debug.keystore -storepass android ~/application/dist/application.apk androiddebugkey
```



# CHECK LOGS OF A ANDROID 

```bash
adb logcat --pid=`adb shell pidof -s com.cymetrics.demo`
```


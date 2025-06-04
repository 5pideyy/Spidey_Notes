

# FRIDA
- in my pc ,

```
pip install frida-tools
```

- Download the Matching `frida-server` 

```
- Go to [https://github.com/frida/frida/releases](https://github.com/frida/frida/releases)
    
- Find the version that matches your installed Frida (e.g., `frida --version`)
    adb shell getprop ro.product.cpu.abi
- Download the correct `frida-server` for your Android device's **architecture**:
    
    - `arm`, `arm64`, `x86`, or `x86_64`
        
- Extract it and rename it to just `frida-server`.
```

- Push `frida-server` to Your Android Device

```
adb push frida-server /data/local/tmp/
adb shell "chmod 755 /data/local/tmp/frida-server"
```

- Run Frida

```
adb shell
su  # if your device is rooted
/data/local/tmp/frida-server &
```


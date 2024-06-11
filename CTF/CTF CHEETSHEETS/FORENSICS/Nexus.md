Reference URL : https://www.garykessler.net/library/file_sigs.html

  

```

file <filename>

```

  

```

strings <filename>

```

  

```

strings <file_name> | grep -i <string_to_be_searched>

```

  

Dont forgot to check metadata ,

  

```

exiftool <filename>

```

  

To extract some hidden files,

  

```

binwalk -e <filename>

```

  

```

foremost -i <filename>

```

  

## Data / Broken FIles

  

```

xxd -l8 <filename>

```



IF PHARAPHRASE FOUND CHECK


```
steghide extract -sf chall.jpg
```


IMAGE HEIGHT INCREASE
https://cyberhacktics.com/hiding-information-by-changing-an-images-height/


```
modsize.py --height 6000 "examples/celeb.png" out.png
```


CHECK FOR LSB HIDDEN DATA IN WAV
```
stegolsb wavsteg -r -i challenge.wav -o output.txt -n 2 -b 10000
```

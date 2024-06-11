#### OBFUSCATION
- difficult to read by humans
- allows it to function the same from a technical point
- performance may be slower
- [Obfucticator](http://beautifytools.com/javascript-obfuscator.php)
##### Minified JS 

- ususally this minified js are saved with .min.js

![[Pasted image 20240608115047.png]]

- [MINIFIER](https://www.toptal.com/developers/javascript-minifier)
##### PACKING JS CODE
- [Obfucticator](http://beautifytools.com/javascript-obfuscator.php)
- ![[Pasted image 20240608115830.png]]

- the above format is "packing", which is usually recognizable from the six function arguments used in the initial function "function(p,a,c,k,e,d)".

- convert all words and symbols to list or dictionary

- but still we see in clear text `javascript'Module|Deobfuscation|JavaScript|HTB|log|console`

##### Advanced Obfuscation
- the above obfuscation show the strings in clear text .. that would expose infos
- to obfuscate completely wit out any meaningful strings advace method used
- [ADVANCED](https://obfuscator.io/)
-  [JSF](http://www.jsfuck.com/)
- [JJ Encode](https://utf-8.jp/public/jjencode.html) or [AA Encode](https://utf-8.jp/public/aaencode.html)
- 
#### DEOBFUSCATION
- js code in single line => minified code, use browser dev tool to prettify or  [Prettier](https://prettier.io/playground/) or [Beautifier](https://beautifier.io/)
- ![[Pasted image 20240608122100.png]] check the bottom =={}==

- js code started with `function (p, a, c, k, e, d)`  then Packed deobfuscation used =>[UnPacker](https://matthewfl.com/unPacker.html) . No empty lines left before the script (affect deobfuscation)
- ![[Pasted image 20240608122531.png]]
- another way replace ==eval => console.log==
- ![[Pasted image 20240608122809.png]]
#### Code Analysis
```javascript
'use strict';
function generateSerial() {
  ...SNIP...
  var xhr = new XMLHttpRequest;
  var url = "/serial.php";
  xhr.open("POST", url, true);
  xhr.send(null);
};
```

- generateSerial is a function
- XMLHttpRequest =>JavaScript function that handles web requests.
- `/serial.php` path where POST request is sent 
- null data is sent to `/serial.php`

##### Try POST request with data
![[Pasted image 20240608124824.png]]



# SUMMARY

- First, we uncovered the `HTML` source code of the webpage and located the JavaScript code.
- Then, we learned about various ways to obfuscate JavaScript code.
- After that, we learned how to beautify and deobfuscate minified and obfuscated JavaScript code.
- Next, we went through the deobfuscated code and analyzed its main function
- We then learned about HTTP requests and were able to replicate the main function of the obfuscated JavaScript code.
- Finally, we learned about various methods to encode and decode strings

# CHEETSHEET
# Commands

|**Command**|**Description**|
|---|---|
|`curl http:/SERVER_IP:PORT/`|cURL GET request|
|`curl -s http:/SERVER_IP:PORT/ -X POST`|cURL POST request|
|`curl -s http:/SERVER_IP:PORT/ -X POST -d "param1=sample"`|cURL POST request with data|
|`echo hackthebox \| base64`|base64 encode|
|`echo ENCODED_B64 \| base64 -d`|base64 decode|
|`echo hackthebox \| xxd -p`|hex encode|
|`echo ENCODED_HEX \| xxd -p -r`|hex decode|
|`echo hackthebox \| tr 'A-Za-z' 'N-ZA-Mn-za-m'`|rot13 encode|
|`echo ENCODED_ROT13 \| tr 'A-Za-z' 'N-ZA-Mn-za-m'`|rot13 decode|

# Deobfuscation Websites

|**Website**|
|---|
|[JS Console](https://jsconsole.com/)|
|[Prettier](https://prettier.io/playground/)|
|[Beautifier](https://beautifier.io/)|
|[JSNice](http://www.jsnice.org/)|

# Misc

|**Command**|**Description**|
|---|---|
|`ctrl+u`|Show HTML source code in Firefox|

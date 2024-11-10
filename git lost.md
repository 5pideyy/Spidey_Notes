![[Pasted image 20241110194126.png]]

got up the repo link https://github.com/crux-bphc/ctf-git-lost

looking at the main branch doesnt make sence . branch commint message says `Empty start, but secrets lie beneath.` 
digging deep got up a finding at the activity 

![[Pasted image 20241110194321.png]]


seems like `lost-and-found` branch has been created and deleted . looking at the changes got up a encrypted text 

![[Pasted image 20241110194510.png]]

changing commit to tree in the url take up to the dangling repo files

![[Pasted image 20241110194614.png]]

decrypting all the contents of the file using the commit message as hint 


.env => vcc3q_zl_  ->rot13 => ipp3d_my_
archive.tmp =>BCY^\x1aXSuFEFW  -> fired up my gpt and got the flag [https://chatgpt.com/share/6730c0f8-e7b8-800a-b529-235854c4c763](see chat here) => hist0ry_lol}

note1.txt=> Y3J1WGlwaGVye3kwdV8K -> just base64 things got left most part

temp_config.txt 










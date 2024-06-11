
![[Pasted image 20231219155720.png]]

![[Pasted image 20231220195720.png]]


### Steps to conduct BOF

*Spiking -  To find a vulnerable part of a program !

*Fuzzing - Sending a bunch of characters to check , can we break it ?

*Finding the offset - finding at which point it breaks ?*

*Overwriting the EIP - we will rewrite the EIP using the found offset*

*Finding the bad characters *

*Finding the right module *

*Generating Shell code*

*Root*

- **Buffer Overflow Practice**: I started the material with ZERO knowledge of Buffer Overflow and I crushed it on the exam. For anyone struggling with BoF, HIGHLY recommend taking the following route:
    
  1. Read the INE Material (with a grain of salt, it's overly complicated) 
        
    2. Watch the TCM Buffer Overflo  w Video
        
    3. Do the Tiberius Buffer Overflow Prep Room on THM (this solidified it)
        
    4. Do Brainstorm on THM
        
    5. Do Gatekeeper on THM  
        
    6. Do Brainpan on THM
        
- **Buffer Overflow**: in terms of methodology and exploit development, I used the following:
    
    1. [https://github.com/Tib3rius/Pentest-Cheatsheets/blob/master/exploits/buffer-overflows.rst](https://github.com/Tib3rius/Pentest-Cheatsheets/blob/master/exploits/buffer-overflows.rst)
        
    2. [https://github.com/gh0x0st/Buffer_Overflow](https://github.com/gh0x0st/Buffer_Overflow)
        
    3. [https://boschko.ca/braindead-buffer-overflow-guide-to-pass-the-oscp-blindfolded/](https://boschko.ca/braindead-buffer-overflow-guide-to-pass-the-oscp-blindfolded/)


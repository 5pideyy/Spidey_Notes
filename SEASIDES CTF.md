
# BRUTEONE

- we got a file which contains hashes
- now i moved to crackstation https://crackstation.net/ to crack the hashes

![[Pasted image 20250118203008.png]]

- and yeah we are getting flag , so i cracked all the hashes

- flag : `HACK_QUEST{lets_go_character_by_character}`

# SHADOWS INSIGHT

- we are given an E-Commerce application 
- i configured burpsuite for the request pass through it
- while login in , ad admin user i got flag via an end point 

![[Pasted image 20250118203530.png]]

- we also got some hints that it uses Nosql data base since it thows a key word `collection`

# HIDDEN VEINS

- i have spidered the web completely to fill up my `sitemap` in burpsuite
- i have encountered  `get user address` via an api endpoint , and yeah we already found that it uses nosql right ! let me try to inject nosql payload 
- got the flag

> [!NOTE] 
> Payload : 
{"userId":{"$ne": null}}

![[Pasted image 20250118204240.png]]

# WHOS SHADOW

- I am given an user id , `67896ab1c3d94b4e97baf28c` , and said `Did you hear what the user said` this gave us hint that i need to see review of this userid
- initially i mapped the user id to username using `/api/user/update-profile` endpoint and found out the username 
![[Pasted image 20250118205023.png]]

- Now its time to read all the reviews through username 
- initially when i login i found that an api request goes to `/api/products/best-sellers`
- searching the username got the flag 
![[Pasted image 20250118205538.png]]

# NOT THAT EASY
- we are given `IMG_CRAC.JPG` and `IMG2.jpg`
- using exiftool i have got an base64 content in comments

![[Pasted image 20250118205931.png]]
- on decoding we get a password for stegextract



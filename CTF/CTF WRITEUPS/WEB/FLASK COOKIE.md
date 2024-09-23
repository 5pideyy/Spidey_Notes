
`<base64 encoded Payload>.<timestamp when cookie created>.Signature`


Patriot CTF : [WRITEUP](https://github.com/phulelouch/CTF-WriteUp/tree/main/PatriotCTF/PatriotCTF2024/web/Impersonate)

- here secret key is defined 

```
server_start_time = datetime.now()
server_start_str = server_start_time.strftime('%Y%m%d%H%M%S')
secure_key = hashlib.sha256(f'secret_key_{server_start_str}'.encode()).hexdigest()
app.secret_key = secure_key
```


- current time of server is found at  /status
- secret key can be found which is depends on server `(server time - uptime)` secret generated when run (python3 app.py)
- we can sign cookie ourself using `flask-unsign`

- admin account takeover easy
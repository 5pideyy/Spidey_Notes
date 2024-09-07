### What is `window.postMessage()`?

- used to send data **safely** between different `Window` objects
	- A webpage and a pop-up it opened
	- A webpage and an embedded iframe.
- allow cross-origin communication 
#### Use Two Method to Communicate

- [window.addeventListener](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)
- [postMessage()](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)

#### Why is this important?
- browsers block communication between different origins for security reasons
- some cases, you need to communicate postMessage do it securly

### Syntax
`targetWindow.postMessage(message, targetOrigin);`

targetWindow - window you want to send the message Eg. pop up,iframe
targetOrgin -  origin (domain) where the message should be sent

### Example
##### Sender Parent Window
```js
// Send a message to an iframe from the parent window
iframeWindow.postMessage('Hello from parent!', 'https://example.com');
```


parent window sends the message **only** if iframe is on https://example.com

##### Reciever window

```js
window.addEventListener('message', function(event) {
  // Security check: Ensure the message is from a trusted origin
  if (event.origin === 'https://example.com') {
    console.log('Message received:', event.data);
  }
});
```

event.origin : origin that sends data
event.data : data that is send by postmessage



## Security Risk

- in reciever side if event is listening for message `window.addEventListener('message', function(e)`  without any verification of the Origin host  we can exploit XSS 
- [postMessage-tracker](https://github.com/fransr/postMessage-tracker)






### Reference
https://medium.com/@youghourtaghannei/postmessage-xss-vulnerability-on-private-program-18e773e1a1ba

With Some Bypass : https://medium.com/@armaanpathan/exploiting-dom-based-xss-via-misconfigured-postmessage-function-bfc794969a0a
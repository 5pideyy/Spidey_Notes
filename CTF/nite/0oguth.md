![Challenge description](Pasted%20image%2020241217120045.png)



as per the name of the challenge we are hinted that , the web uses oAuth 

we are given a web url http://yankdeal.ooguth.chalz.nitectf2024.live/

when visiting it says to login with oogle 

![oogle Login](Pasted%20image%2020241217120440.png)
when login is clicked 
- The app then redirects the user to another login page (`oogle.ooguth.chalz.nitectf2024.live/login`), passing the callback URL (`redirectTo`) as a query parameter.
- Once the user completes the login process on the other page, they will be redirected to the callback URL (`http://yankdeal.ooguth.chalz.nitectf2024.live/callback`).
  
  
  when register an accouunt  scope parameter is set to profile 
  
```
  POST /login?redirectTo=http://yankdeal.ooguth.chalz.nitectf2024.live/callback&scope=profile HTTP/2
```

now what is scope in oauth lets google 

>Scope is a mechanism in OAuth 2.0 to limit an application's access to a user's account. An application can request one or more scopes, this information is then presented to the user in the consent screen, and the access token issued to the application will be limited to the scopes granted.

ref:https://oauth.net/2/scope/


now we are set to profile scope ,ok lets proceed further


after logged in with oogle , we can add to card , view cart , and logout 
when accessing `/profile` end point  gives not found

intrestingly 3 cookies are being set tokenC , session and token

when decoding we get to know scope is specified in jwt too . now its hinted that we need to change scope to some others . lets google how to get scopes and default 

got two  standard endpoints:

- `/.well-known/oauth-authorization-server`
- `/.well-known/openid-configuration`

from the gold mine for webers https://portswigger.net/web-security/oauth


now got scopes from 

![/.well-known/openid-configuration got scopes](Pasted%20image%2020241217123951.png)

- to tamper jwt with the scopes we dont have secret key , tried to brute force with rockyou no leads 
  
  - now lets modify the scope parameter while register and login

let me set every scopes

![[Pasted image 20241217124407.png]]

and now yes we have got all scopes set , 

![Decoded JWT](Pasted%20image%2020241217124556.png)


now , where is the flag???

lets access every end point 

``/payment_details`` endpoint throws flag


``Flag: nite{y0u_c4nt_h4ck_wh47_y0u_c4n7_f1nd_5550-1309-6672-6224}``









  


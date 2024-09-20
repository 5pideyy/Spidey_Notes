
- Requesting a Resource from server-> response to client -> stored in cache 
- Request Same resource ->retrieve from cache (Hence improved server load)
![[Pasted image 20240919234643.png]]

How to find same resouce Fetched ?

```ngnix.conf
http {
  proxy_cache_path /cache levels=1:2 keys_zone=STATIC:10m inactive=24h max_size=1g;

  server {
    listen       80;

    location / {
      proxy_pass             http://172.17.0.1:80;
      proxy_buffering        on;
      proxy_cache            STATIC;
      proxy_cache_valid      2m;
      proxy_cache_key $scheme$proxy_host$uri$args;
      add_header X-Cache-Status $upstream_cache_status;
    }
  }
}
```


- here` proxy_cache_key` defines request to be retrived from server or cache . 
- scheme , Host , uri , arguments are same then retrive from cache ,else from server


`$scheme$proxy_host$uri$args` these are ==Keyed== parameters which should be same to retrive from cache


user-agent , refferer etc are ==Unkeyed== Parameters 



==**Objective : Find Unkeyed Parameter .** ==
[BB Tricks](https://ltsirkov.medium.com/cross-site-scripting-via-web-cache-poisoning-and-waf-bypass-6cb3412d9e11)
- which servers from cache , not from original server
- try xss in unkeyed param . which stored in cache
- access same in another browser or curl 
- Donot mainly focus on unkeyed parameters also ==focus on headers too==

How to check cached or not ?

- **cache** one of header in response
- response timing 
- change a parameter value and the response remains the same



Nothing Worked out try  **Fat GET**


==try out X-Forwarded-Host: , X-Forwarded-Proto: http==

## Tools 

https://github.com/Hackmanit/Web-Cache-Vulnerability-Scanner







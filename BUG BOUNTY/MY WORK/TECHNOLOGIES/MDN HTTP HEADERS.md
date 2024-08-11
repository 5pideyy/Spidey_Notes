
#### X-Forwarded-Host
- used to identify original host requested by client
- when request going through proxy.

client request -> proxy/load balancer -> server

Client Request:

```
GET / HTTP/1.1
Host: original-client-host.com
```

when this request goes through proxy, proxy adds header

Proxy Adds Header:

```
GET / HTTP/1.1
Host: proxy-host.com
X-Forwarded-Host: original-client-host.com
```

backend under stands and realizes clent requests ` original-client-host.com`




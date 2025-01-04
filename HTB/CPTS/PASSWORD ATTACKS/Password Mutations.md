## Password Mutations

### Password File Criteria

To create a password file based on specific criteria:

- **Requirements:**
    - At least 1 lowercase letter
    - At least 1 uppercase letter
    - Numbers
    - Special characters

### Hashcat Rule File

|**Function**|**Description**|
|---|---|
|`:`|Do nothing.|
|`l`|Lowercase all letters.|
|`u`|Uppercase all letters.|
|`c`|Capitalize the first letter and lowercase others.|
|`sXY`|Replace all instances of X with Y.|
|`$!`|Add the exclamation character at the end.|

#### Custom Rule File Example

```shell
pradyun2005@htb[/htb]$ cat custom.rule

:
c
so0
c so0
sa@
c sa@
c sa@ so0
$!
$! c
$! so0
$! sa@
$! c so0
$! c sa@
$! so0 sa@
$! c so0 sa@
```

---
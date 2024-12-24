[Reference](https://medium.com/@zub3r.infosec/exploiting-prototype-pollutions-220f188438b2)


# Objects

- these are variables but contains many values of any type like dictionries

```
const person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};  

```

```
// Create an Object  
const person = {};  
  
// Add Properties  
person.firstName = "John";  
person.lastName = "Doe";  
person.age = 50;  
person.eyeColor = "blue";
```


```
// Create an Object  
const person = new Object();  
  
// Add Properties  
person.firstName = "John";  
person.lastName = "Doe";  
person.age = 50;  
person.eyeColor = "blue";
```

### Accessing 

```
objectName.propertyName

objectName["propertyName"]
```


- ==this==  refers to curreny object

# Prototypes

- consider an simple object literal 

```
const myObject = {
  city: "Madrid",
  greet() {
    console.log(`Greetings from ${this.city}`);
  },
};

myObject.greet(); // Greetings from Madrid

```

- if we try to acess by typing myObject. , it shows many other than city , greet

```
__defineGetter__
__defineSetter__
__lookupGetter__
__lookupSetter__
__proto__
city
constructor
greet
hasOwnProperty
isPrototypeOf
propertyIsEnumerable
toLocaleString
toString
valueOf
```

- when access it works , these built in properties are called as `prototypes`


![[Pasted image 20241224193031.png]]

- we can even assign values  to objects using  these prototypes , 

![[Pasted image 20241224193144.png]]

- we can even change the value of the prototype 

![[Pasted image 20241224194425.png]]

### Simplest Prototype pollution

```javascript
function Module(name, author, tier) {
	this.name = name;
	this.author = author;
	this.tier = tier;
}

var webAttacks = new Module("Web Attacks", "21y4d", 2)
```
- here  what if we create of modify a new property in `__proto__` 

![[Pasted image 20241224200140.png]]


## Real life Exmaple

- comment section to add comment to modules using json

```json
{"comment": "Great module."}
```


- this is processed using 

```javascript
// helper to determine if recursion is required
function isObject(obj) {
	return typeof obj === 'function' || typeof obj === 'object';
}

// merge source with target
function merge(target, source) {
	for (let key in source) {
		if (isObject(target[key]) && isObject(source[key])) {
			merge(target[key], source[key]);
		} else {
			target[key] = source[key];
		}
	}
	return target;
}
```

![[Pasted image 20241224200739.png]]

![[Pasted image 20241224200744.png]]

- function is vulnerable to `prototype pollution`

```json
{"__proto__": {"poc": "pwned"}}
```

![[Pasted image 20241224211700.png]]


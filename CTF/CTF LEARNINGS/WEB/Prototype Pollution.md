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
- here 
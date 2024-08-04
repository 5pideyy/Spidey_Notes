

### Web Services Description Language (WSDL)

[check here](https://www.tutorialworks.com/wsdl/#:~:text=A%20WSDL%20file%20is%20written%20in%20XML.%20It,to%20send%20a%20request%20to%20a%20web%20service.)

![[Pasted image 20240804173411.png]]

- instruction manual for interacting with a web service.
- defines rules t communicate btw application and web service 
## Structure of a WSDL file

|ELEMENT|WHAT IT DOES|
|---|---|
|`<types>`|Defines the data types (XML elements) that are used by the web service.|
|`<message>`|Defines the messages that can be exchanged with the web service. Each `<message>` contains a `<part>`.|
|`<portType>`|Defines each operation in the web service, and the messages associated with each operation.|
|`<binding>`|Defines exactly how each `operation` will take place over the network (we use SOAP, in the example below).|
|`<service>`|Defines the physical location of the service (e.g. its _endpoint_).|


- bruteforce to find wsdl directory
- blank page brute force for parameters
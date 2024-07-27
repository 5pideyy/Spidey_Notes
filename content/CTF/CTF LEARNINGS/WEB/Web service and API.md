#### WEB SERVICE
- ENABLE APPLICATIONS TO COMMUNICATE EACH OTHER
- Consider the following scenario:

	- One application written in Java is running on a Linux host and is using an Oracle database
	- Another application written in C++ is running on a Windows host and is using an SQL Server database

	- These two applications can communicate with each other over the internet with the help of web services.
#### API
- set of rules that enables data transmission between different software
- Consider the following example: A piece of software needs to access information, such as ticket prices for specific dates. To obtain the required information, it will make a call to the API of another software (including how data/functionality must be returned). The other software will return any data/functionality requested.
- The interface through which these two pieces of software exchanged data is what the API specifies.

#### WEB SERVICE VS API
- Web services are a type of application programming interface (API). The opposite is not always true!
- Web services need a network to achieve their objective. APIs can achieve their goal even offline.
- Web services rarely allow external developer access, and there are a lot of APIs that welcome external developer tinkering.
- Web services usually utilize SOAP for security reasons. APIs can be found using different designs, such as XML-RPC, JSON-RPC, SOAP, and REST.
- Web services usually utilize the XML format for data encoding. APIs can be found using different formats to store data, with the most popular being JavaScript Object Notation (JSON).


### XML-RPC
![[Pasted image 20240531194234.png]]
- The XML comtains method call to invoke the method
- name of the method(examples) and followed(getstatename) by function
- and parameter 
- ususlly xml uses http to transport information
### SOAP
- Simple object access protocol uses xml
- 1. **Components of SOAP Message:**
    
    - **Envelope:** This is the top element that defines the start and end of the message. It encapsulates the entire message.
    - **Header:** Optional part that contains metadata about the message, such as security information.
    - **Body:** Contains the actual message data, such as the request or response information.
    - **Fault:** This is an optional part within the body that provides information about errors that occurred during processing.
    ![[Pasted image 20240531200934.png]]
#### RESTful (Representational State Transfer)
-  REST web services usually use XML or JSON. WSDL declarations are supported but uncommon. HTTP is the transport of choice, and HTTP verbs are used to access/change/delete resources and use data.
 - XML ![[Pasted image 20240531201400.png]]
 - JSON ![[Pasted image 20240531201417.png]]

# Web Services Description Language (WSDL)
- XML-based file exposed by web services
- describes the service, specifying what the service does, where it resides, and how to invoke it
- ![[Pasted image 20240531202653.png]]
- **Note**: WSDL files can be found in many forms, such as `/example.wsdl`, `?wsdl`, `/example.disco`, `?disco` etc. [DISCO](https://docs.microsoft.com/en-us/archive/msdn-magazine/2002/february/xml-files-publishing-and-discovering-web-services-with-disco-and-uddi) is a Microsoft technology for publishing and discovering Web Services.
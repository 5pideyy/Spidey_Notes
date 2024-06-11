
*Network model is nothing but the list of rules how  it have to cnonnect too other device*

# TCP / IP

*PHYSICAL > NETWORK > TRANSPORT > APPLICATION*

- Physical = Ethernet cables
- Network = IP address / routers
- Transport = TCP /UDP/PORTS/protocols
- Application = sites  ? how it is going to communicatew with application



*PHYSICAL > DATALINK > NETWORK > TRANSPORT > APPLICATION*

- Physical = Ethernet cables
- Data Link =  Mac address
- Network = IP address / routers
- Transport = TCP /UDP/PORTS/protocols
- Application = sites  ? how it is going to communicatew with application


## *OSI MODEL*

*PHYSICAL > DATALINK > NETWORK > TRANSPORT > SESSION  > PRESENTATION > APPLICATION*



> All People Seen To Need Data Processing

> Please Do Not Throw Sausage Pizza Away

Bridges --- similar to switches
Repeaters -- wirted one like hub


UDP is fater that TCP


*Encapsulation*

It contains data what is source IP destinatio IP , It helps to travel for packets

APPLICATION  (DATA)
PRESENTATION 
SESSION
TRANSPORT(DATA,L4 HEADER)  -------SEGMENT
NETWORK(DATA,L4 HEADER,L3 HEADER) -------- PACKET
DATA LINK(L2 TRAILER , DATA , L4 HEADER , L3 HEADER,L2 HEADER) ------FRAME
PHYSICAL (ETHERNET)

*APPLICATION LAYER:*

- Determinging whether adequate resources exist  for communications.
- Managing communication betweeen applications 
- directing data to the correct program


*SESSION LAYER*

Responsible for managing and coordinating communication sessions between applications on different devices.

1.  Session establishment: The session layer is responsible for setting up and establishing a communication session between applications on different devices.
    
2.  Session maintenance: The session layer ensures that the communication session remains active and that data is exchanged smoothly between the applications.
    
3.  Session synchronization: The session layer ensures that the data transmitted by the sender and received by the receiver is in synchronization, so that the receiver can correctly interpret the data.
    
4.  Session termination: The session layer is responsible for ending the communication session in a proper manner, ensuring that all data has been transmitted and received correctly.


*TRANSPORT LAYER:*

Mainly UDP vs TCP 

TCP is more reliable....

1.  Connection-oriented: TCP is connection-oriented, which means that it establishes a connection between the sender and receiver before transmitting data. This ensures that data is transmitted in the correct order, and any lost or damaged packets can be retransmitted.
    
2.  Error checking: TCP uses a checksum to check for errors in the data. If an error is detected, TCP requests that the sender retransmit the data.
    
3.  Flow control: TCP provides flow control to ensure that data is transmitted at a rate that the receiver can handle. This prevents the receiver from being overwhelmed by too much data and dropping packets.
    
4.  Congestion control: TCP provides congestion control to prevent the network from becoming congested with too much traffic. This ensures that packets are transmitted efficiently and reduces the likelihood of packet loss.

*UDP:*

It is Fast..



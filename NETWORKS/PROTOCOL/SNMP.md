

- protocol used to monitor and manage network devices
- allows network administrators to collect information about network performance, detect network faults, and configure network devices remotely
### Components of SNMP:

1. **SNMP Manager (Client)**: The system used to control and monitor the activities of network devices using SNMP.
2. **SNMP Agent (Server)**: The software on network devices (like routers, switches, and servers) that reports information to the SNMP manager.
3. **Management Information Base (MIB)**: A database of objects that can be managed using SNMP. Each object in the MIB has a unique identifier (OID).
### SNMP Works:

1. **Polling**: The SNMP manager sends a request to the SNMP agent for information.
2. **Response**: The SNMP agent responds with the requested information.
3. **Set Command**: The SNMP manager can also send commands to change configurations on the network device.
4. **Traps**: The SNMP agent sends an unsolicited alert (trap) to the SNMP manager when a specific event occurs.



## Management Information Base (MIB)

- virtual database used for managing the entities in a network
- a collection of objects that can be monitored and controlled via SNMP.



- **Structure**: The MIB is structured hierarchically in a tree format.
- **Objects**: Each object in the MIB represents a specific piece of information about a network device, such as its status, configuration parameters, or performance metrics.
- **Standardization**: The structure and definitions of the objects in the MIB are standardized, so different SNMP tools and devices can understand and use them.


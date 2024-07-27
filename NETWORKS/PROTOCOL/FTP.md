- used for file transfer from one pc to other
- push the file to ftp server
- now the file is in both server and the pc which created
- anyone within the network can get the file using ftp
- ![[WhatsApp Image 2024-05-30 at 8.24.55 PM.jpeg]]
- here i have created file in PC1 and push into server 
- now i can get the file from server by PC0
### Working

#### ACTIVE
1. First, the FTP client establishes a command connection by connecting to the FTP port on the server.
2. The client authenticates itself, usually with username and password.
3. The client changes directory on the server to where it wants to deposit or retrieve files.
4. The client begins listening on a new port for the data connection, and then informs the server about that port.(DATA CHANNEL)
5. The server connects to the port the client requested.
6. The file is transmitted.
7. The data connection is closed.
#### PASSIVE
- the server opens an extra port, and tells the client to make the second connection(DATA TRANSFER)




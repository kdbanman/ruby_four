### Part 5 TODO

#### Ryan

- add server IP and port to new game dialogue

#### Kirby

- NetProtocol maybe should be a class
    - @err, @log, @socket?
    - mutex lock? probably not - each socket will be owned by a GameServer process

- master server will accept from TCPServer and fork a process with a GameServer for the resulting socket

- remove win message from socket communication (it's in the model now.)
    - reduce ALL socket communication to a single cycle:
        - server:
            1. accept message EX: token, exit, ...
            2. send response EX: exit, nop
            3. send model
        - client:
            1. send message 
            2. receive response
            3. receive model
    - if NetProtocol were aware of message patterns for steps 1 and 2 (from a gametype), then it could run that whole cycle in a pair:
        - `client_send(message: String): [response:String, model: Board]`
            - returns a response and a model (not in a block - may recurse indefinitely
        - `server_receive(): Block |message: String| : [response: String, model: Board]
            - calls a block with the message, block returns response and model to send

# Mechtron
A RAT tool.

## Commands
clients<br>
session IP
<br>
commands

## Instructions
```runner.rb``` has two options for server and client  mode. Run with ```-c IP``` for client mode and ```-s``` for server mode. You can have one server with multiple clients. Mechtron uses port 6666.
## Example Usage

### Server
```
chmod +x mechtron.rb
./mechtron -s
starting server on port 6666
127.0.0.1 joined
session 127.0.0.1
session started with 127.0.0.1
whoami
chrisbasinger
which ruby
/bin/ruby
exit
closing session
exit
exiting the server..

Process finished with exit code 0

```

### Client
```
chmod +x rat.rb
./mechtron -c 127.0.0.1
```

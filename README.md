# Mechtron
A RAT tool. Mechtron runs on port 6666.

## Commands
clients<br>
session IP
<br>
commands

## Instructions
***Client -*** ```./mechtron.rb -c IP```<br>
***Server -*** ```./mechtron.rb -s```<br>
***Help -*** ```./mechtron.rb -h```

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

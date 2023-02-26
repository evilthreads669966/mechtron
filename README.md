# Mechtron
A RAT tool. Mechtron allows you to remotely administrate computers and transfer files.

Mechtron runs on port 6666. It can handle multiple clients, but one session at a time. Meaning you can have one reverse shell instance at a time. I plan on publishing a debian package, but for now, you'll have to deal with the source folders.

## Commands
- **clients**<br>
- **session IP**<br>
  - session is used to start a reverse shell<br>
- **get IP FILE FORMAT** - formats awwre binary & text<br>
  - get is used for downloading files.<br>
- **put IP FILE FORMAT** - formats are binary & text<br>
  - put is used for uploading files<br>
- **commands**<br>

## Instructions
***Client Mode -*** ```./mechtron.rb -c IP```<br>
***Server Mode -*** ```./mechtron.rb -s```<br>
***Help -*** ```./mechtron.rb -h```

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
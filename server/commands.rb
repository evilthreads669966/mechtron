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
limitations under the License .
=end
require_relative 'client'
# This class contains the commands foor which you are able to execute on the server
class Commands

  def self.session(client)
    client.in_session = true
    t = Thread.new do
      client.puts 'session'
      puts "session started with #{client.to_s}"
      loop do
        print '$ '
        command = STDIN.gets.chomp
        if command.downcase == 'exit'
          puts 'closing session'
          client.puts 'exit'
          break
        end
        client.puts command
        loop do
          response = client.gets
          unless response
            break
          end
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
    client.in_session = false
  end

  def self.get(client, file, format)
    client.puts "get #{file} #{format}"
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
    length = client.sock.gets.to_i
    file.write client.sock.read length
    file.close
    puts 'Download finished'
  end

  def self.put(client, file, format)
    if file.include? '/'
      splitter = '/'
    else
      splitter = '\\'
    end
    unless File.exist? file
      puts 'File does not exist!'
      return
    end
    client.puts "put #{file.split(splitter).last} #{format}"
    if format == 'binary'
      content = File.binread file
    elsif format == 'text'
      content = File.read file
    else
      puts 'invalid format'
    end
    client.puts content.length
    client.puts content
    puts 'upload finished'
  end

  def self.scan(client)
    for port in 1..65536
      begin
        TCPSocket.new(client.ip,port).close
        puts "#{port} open"
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      end
    end
    puts 'scan finished'
  end

  def self.latency(client)
    start = Time.now
    client.puts 'latency'
    client.gets
    finish = Time.now
    latency = finish - start
    puts "#{latency} milliseconds"
  end

  def self.programs(client)
    client.puts 'programs'
    loop do
      response = client.gets
      if response == 'done'
        break
      end
      puts response
    end
    puts
  end

  def self.uptime(client)
    time = ((Time.now.to_i - client.time) / 60.0).round(1)
    puts "#{time} minutes"
  end

  def self.reboot(client)
    client.puts 'reboot'
  end

  # Prints out a list of the connected clients
  def self.clients_table(clients)
    if clients.empty?
      puts 'No clients connected'
      return
    end
    clients.sort_by(&:id)
    # There is no way to delete the last row from the table. So I put the rows in an array and remove the last before adding them to the table becasue it always ends up with a trailing separator
    rows = []
    t = Terminal::Table.new(:title => 'CLIENTS', :headings => ['ID', 'IP ADDRESS', 'NAME', 'OS']) do |t|
      clients.each do |client|
        rows << [client.id, client.ip, client.name, client.platform]
        rows << :separator
      end
    end
    rows.delete rows.last
    rows.each { |row| t << row}
    puts t
  end
end
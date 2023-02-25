require_relative 'client'

# handles the logic for executing commands
class Commands
  @@commands = ['clients', 'session IP', 'get IP file format', 'put IP file format']

  def self.session(client)
    client.write 'session'
    puts "session started with #{client.to_s}"
    loop do
      print '$ '
      command = STDIN.gets.chomp
      if command.downcase == 'exit'
        puts 'closing session'
        client.write 'exit'
        break
      end
      client.write command
      loop do
        response = client.read
        if response == 'done'
          break
        end
        puts response
      end
    end
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
    file = File.open(file, 'r')
    content = file.read
    file.close
    client.write content
    client.write 'done'
    puts 'upload finished'
  end

  # print out a list of all commands
  def self.list_commands
    @@commands.each { |cmd| puts cmd}
  end
end
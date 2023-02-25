require_relative 'client'

# handles the logic for executing commands
class Commands
  @@commands = ['clients', 'session IP']

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
    puts 'Starting download'
    if format == 'binary'
      file = File.new(file.split('/').last, 'wb')
    elsif format == 'text'
      file = File.new(file.split('/').last, 'w')
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
    client.write "put #{file.split('/').last} #{format}"

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
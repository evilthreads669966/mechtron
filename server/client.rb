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

require 'socket'

# class responsible for holding client information
class Client
  attr_reader :ip, :id, :sock
  @@counter = 0
  def initialize(sock)
    @sock = sock
    @ip = sock.peeraddr(false)[3]
    @id = @@counter
    @@counter += 1
  end

  def write(data)
    @sock.puts data
  end

  def read()
    return @sock.gets.chomp
  end

  def to_s
    "[#{@id}] #{@ip}"
  end

end
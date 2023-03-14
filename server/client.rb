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

require 'socket'
# class responsible for holding client information
class Client
  attr_accessor :name, :platform
  attr_reader :id, :ip, :sock, :time
  @@counter = 0
  def initialize(sock)
    @sock = sock
    @id = @@counter
    @ip = sock.peeraddr(false)[3]
    @@counter += 1
    @name = nil
    @time = Time.now.to_i
    @platform = nil
  end

  def puts(data)
    @sock.puts data
  end

  def gets()
    response = @sock.gets
    if response
      return response.chomp
    else
      return nil
    end
  end

  def to_s
    "[#{@id}] #{@ip} #{@name} #{@platform}"
  end

  def ==(other)
    return (self.class == other.class) && (@ip == other.ip)
  end

end
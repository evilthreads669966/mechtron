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
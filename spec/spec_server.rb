require_relative '../server/server'
require 'socket'

RSpec.describe Server do
  describe '.start' do
    context 'given a new connection' do
      it 'creates a client and adds it to the client list' do
        server = Server.new(1111)
        server.start
        TCPSocket.new('127.0.0.1', 1111)
        expect server.clients.size == 1
        server.stop
      end
    end
  end
end

RSpec.describe Server do
  describe '.start' do
    context 'given clients command' do
      it 'respond with clients' do
        server = Server.new(1111)
        server.start
        sleep 1
        sock = TCPSocket.new("127.0.0.1",1111)
        sock.puts 'clients'
        response = sock.gets.chomp
        expect response == '[0] 127.0.0.1'
      end
    end
  end
end

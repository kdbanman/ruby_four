require 'socket'

module NetProtocol

  # @param [String] str
  # @param [TCPSocket] sock
  def send_str(str, sock)
    sock.puts str.bytesize.to_s
    sock.send(str, 0)
  end

  # @param [TCPSocket] sock
  def recv_str(sock)
    size_str = sock.gets until size_str.to_i != 0
    sock.recv(size_str.to_i)
  end
end
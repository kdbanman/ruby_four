require 'socket'

module NetProtocol

  # @param [String] str
  # @param [TCPSocket] sock
  def send_str(str, sock, err = $stderr)
    # Send pending message size
    size = str.bytesize.to_s
    sock.syswrite size
    # Wait until receiver responds with same confirmed size
    response_size = sock.sysread str.bytesize.to_s.bytesize
    # Send pending message
    if response_size == size
      sock.syswrite str
    else
      err.puts "ERROR: Protocol size mismatch. got #{response_size} expected #{size} for msg\n #{str}"
    end
  end

  # @param [TCPSocket] sock
  def recv_str(sock)
    # Get incoming message size
    size = sock.sysread(100)
    # Respond with message size
    sock.syswrite size
    # Read message
    sock.sysread size.to_i
  end
end
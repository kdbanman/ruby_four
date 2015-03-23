require 'observer'
require 'socket'
require_relative '../model/data_source_contracts'
require_relative '../util/net_protocol'

# Server communication layer.
# Knows what messages to send to the server.
# Knows what messages in what sequence will be received by the server.
# Allows command sending to the server with method calls.
# Deserializes models from the server and updates observers with results.
class DataSource

  attr_reader :board

  include Observable
  include DataSourceContracts
  include NetProtocol

  private

  WIN_PATTERN = /win (\d)/
  EXIT_PATTERN = /exit (\d)/

  @server_socket
  @board

  public

  # @param [GameConfig] config
  # TODO should be initialized with Engine?  see WinSequence?
  def initialize(config)

    # connect with server and send serialized game config
    @server_socket = TCPSocket.new(config.ip, config.port)
    send_str(Marshal.dump(config), @server_socket)

    # receive serialized model
    @board = Marshal.load(recv_str(@server_socket))
    update_observers

    verify_invariants
  end

  # @param [Integer] player_id 1 or 2
  # @param [Integer] column
  # @param [Symbol] token_type :T :O or nil
  def place_token(player_id, column, token_type = nil)
    command = "token #{player_id} #{column}"
    command += " #{token_type}" unless token_type.nil?

    send_str command, @server_socket
    wait_for_response @server_socket
  end

  def exit_game(player_id)
    send_str "exit #{player_id}", @server_socket
    wait_for_response @server_socket
  end

  private

  # @param [TCPSocket] server_socket
  def wait_for_response server_socket
    msg = recv_str server_socket # may be win or model

    if msg =~ WIN_PATTERN
      win_game msg[WIN_PATTERN, 1].to_i
      msg = recv_str server_socket # will be model this time
    elsif msg =~ EXIT_PATTERN
      puts msg
      @server_socket.close
      return
    end

    @board = set_board msg
    update_observers
  end

  def set_board(serialized)
    begin
      Marshal.load serialized
    rescue ArgumentError
      warn 'ERROR: Model not received from server!'
      exit 1
    end
  end

  def update_observers
    changed
    notify_observers @board
  end

  def win_game(player)
    puts "WINNER #{player}"
  end

  def verify_invariants
  end

end
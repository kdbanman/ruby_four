require 'observer'
require 'socket'
require_relative '../model/data_source_contracts'

# Server communication layer.
# Knows what messages to send to the server and in what sequence
# Allows command sending to the server with RPC method calls.
class RPCDataSource

  attr_reader :board

  include Observable
  include DataSourceContracts

  private

  @board

  @client_rpc
  @server_proxy

  public

  # @param [GameConfig] config
  # @param [Integer] game_id
  def initialize(config, game_id)

    # connect with server and send serialized game config
    puts "DATASOURCE: connecting to server at #{config.ip}:#{config.port}"

    # call master server create game with config (return game id)

    # get game server proxy using game id

    # declare client_rpc xmlrpc server with player joined, update, and exit handlers
    # start client xmlrpc server in new thread

    # register client_rpc (random open port on local ip) with game server

    verify_invariants
  end

  # @param [Integer] player_id 1 or 2
  # @param [Integer] column
  # @param [Symbol] token_type :T :O or nil
  def place_token(player_id, column, token_type = nil)
    # call place token on server proxy
  end

  def exit_game(player_id)
    # call ext command on server proxy
  end

  # called by game server
  def remote_update_board(board)
    # set board and update observers
  end

  # called by game server
  def remote_exit_game
    # kill client rpc server

  end

  private

  def local_ip
    Socket.ip_address_list.each { |a| return a.ip_address if a.ipv4? && !a.ipv4_loopback? }
  end

  def unused_port
    s = Socket.new(:INET, :STREAM, 0)
    s.bind(Addrinfo.tcp('localhost', 0))
    s.local_address.ip_port
  end

  def update_observers
    changed
    notify_observers @board
  end

  def verify_invariants
  end

end
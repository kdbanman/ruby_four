require 'observer'
require 'socket'
require_relative '../model/rpc_data_source_contracts'

# GameServer communication layer.
# Knows what messages to send to the game server and in what sequence
# Does not know about game stats or game lists, just game instances
# Allows command sending to the server with RPC method calls.
class RPCDataSource

  attr_reader :board

  include Observable
  include RPCDataSourceContracts

  private

  @board

  @client_rpc
  @server_proxy

  public

  # @param [GameConfig] config
  def initialize(config)

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
    # preconditions
    is_integers player_id, column
    is_token_type token_type

    # call place token on server proxy

    verify_invariants
  end

  def exit_game(player_id)
    # preconditions
    is_integers player_id

    # call ext command on server proxy

    verify_invariants
  end

  # called by game server
  def remote_update_board(board)
    # set board and update observers

    verify_invariants
  end

  # called by game server
  def remote_exit_game(playerid)
    # kill client rpc server

    verify_invariants
  end

  private

  def local_ip
    ip = Socket.ip_address_list.each { |a| return a.ip_address if a.ipv4? && !a.ipv4_loopback? }

    # postconditions
    is_ip ip

    ip
  end

  def unused_port
    s = Socket.new(:INET, :STREAM, 0)
    s.bind(Addrinfo.tcp('localhost', 0))
    port = s.local_address.ip_port

    #postconditions
    is_integers port
    port
  end

  def update_observers
    # preconditions
    is_board @board

    changed
    notify_observers @board
  end

  def verify_invariants
    is_rpc_server @client_rpc
    is_rpc_proxy @server_proxy
  end

end
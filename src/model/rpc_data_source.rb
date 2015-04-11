require 'observer'
require 'xmlrpc/client'
require 'xmlrpc/server'
require_relative '../model/rpc_data_source_contracts'

# GameServer communication layer.
# Knows what messages to send to the game server and in what sequence
# Does not know about game stats or game lists, just game instances
# Allows command sending to the server with RPC method calls.
class RPCDataSource

  attr_reader :board, :game_id

  include Observable
  include RPCDataSourceContracts

  private

  @board
  @game_id

  @client_rpc
  @server_proxy

  public

  # @param [GameConfig] config
  def initialize(config)

    # connect with server and send serialized game config
    puts "DATASOURCE: connecting to server at #{config.ip}:#{config.port}"

    server = XMLRPC::Client.new( config.ip, '/', config.port)
    master = server.proxy('master')

    # call master server create game with config (return game id)
    id_and_port = master.create_game(config, config.name1)
    @game_id = id_and_port[0]
    port = id_and_port[1]

    # get game server proxy using game id
    server = XMLRPC::Client.new( config.ip, '/', port )
    @server_proxy = server.proxy( @game_id )

    # declare client_rpc xmlrpc server with player joined, update, and exit handlers
    # start client xmlrpc server in new thread
    my_port = unused_port
    @client_rpc = XMLRPC::Server.new( my_port, 'localhost', 1)
    @client_rpc.add_handler("#{game_id}", self);

    spawn do
      Signal.trap('INT') { @client_rpc.shutdown }
      @client_rpc.serve
    end

    # register client_rpc (random open port on local ip) with game server
    #  (no need to register twice, client messages ar broadcast)
    @server_proxy.register_client( local_ip, my_port )

    verify_invariants
  end

  # @param [Integer] player_id 1 or 2
  # @param [Integer] column
  # @param [Symbol] token_type :T :O or nil
  def place_token(player_id, column, token_type = nil)
    # preconditions
    is_integers player_id, column
    is_token_type token_type

    @server_proxy.place_token(player_id, column, token_type)

    verify_invariants
  end

  def exit_game(player_id)
    # preconditions
    is_integers player_id

    # call ext command on server proxy
    @server_proxy.exit_game(playerID)

    verify_invariants
  end

  # called by game server
  def remote_update_board(board)
    # set board and update observers
    @board = board

    changed
    notify_observers @board

    verify_invariants
  end

  # called by game server
  def remote_exit_game(playerid)
    # kill client rpc server
    @client_rpc.shutdown

    verify_invariants
  end

  def remote_sever_err(msg)

    puts "Server problem: #{msg}"
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
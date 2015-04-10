require 'xmlrpc/utils'
require_relative '../src/rpc_game_server_contracts'
require_relative '../src/controller/place_token_command'
require_relative '../src/model/game_config'
require_relative '../src/model/board'
require_relative '../src/model/game_type_factory'

class RPCGameServer

  include RPCGameServerContracts

  attr_accessor :game_id

  private

  @config
  @board
  @game_type

  @game_id

  @clients
  @exit_listeners

  public

  def initialize
    @clients = Array.new
    @exit_listeners = Array.new

    verify_invariants
  end

  # for master server to call.  not intended for clients to call.
  # @param [GameConfig] config
  # @param [String] game_id a uuid
  # @return [Board] the constructed board ready for moves
  def start_from_config(config, game_id)
    # preconditions
    is_true @config.nil?, 'start_from_config must only be called once'
    is_gameid game_id

    puts "Starting from config:\n#{config}"
    @config = config
    @game_type = GameTypeFactory.get_game_type(config)
    @board = Board.new(config, @game_type, game_id)

    @game_id = game_id

    verify_invariants

    @board
  end

  # for master server to call.  not intended for clients to call.
  # @param [Board] saved_game
  def start_from_existing(saved_game)
    # preconditions
    is_true @config.nil?, 'start_from_config must only be called once'
    is_board saved_game

    puts "Starting from board:\n#{saved_game}"
    @config = saved_game.config
    @game_type = GameTypeFactory.get_game_type(@config)
    @board = saved_game

    @game_id = saved_game.game_id

    verify_invariants

    @board
  end

  # @param [Integer] player_id
  # @param [Integer] column
  # @param [Symbol or Integer] token_type
  # @return [Board] the board after tho token placement has been attempted, winner evaluated, etc.
  def place_token(player_id, column, token_type)
    check_winner if PlaceTokenCommand.new(player_id, column, token_type, @game_type).run(@board)
    #TODO check_playable (no winner possible)

    # TODO wrap exception XMLRPC::FaultException
    # send board to registered clients
    @clients.each { |client| client.call("#{@game_id}.remote_update_board", @board)}

    # postconditions
    token_delta_one @board

    verify_invariants
    
    @board
  end

  # @param [Integer] playerID
  def exit_game(playerID)

    # TODO save game
    # master server will save game with listener callback
    @exit_listeners.each { |listener| listener.call(playerID) }

    # TODO wrap exception XMLRPC::FaultException
    @clients.each { |client| client.call("#{@game_id}.remote_exit_game", playerID)}

    verify_invariants
  end

  def check_winner
    puts @board.most_recent_token

    winner = @game_type.get_winner(@board)
    if winner
      puts "Player #{winner} wins"
      @board.set_winner(winner)
    end

    verify_invariants
  end

  def register_client(ip, port)
    #preconditions
    is_ip ip
    CommonContracts.positive_integers port

    # start new rpc client at ip, port
    # methods will be called with '<game id>.<method>'
    begin
      client = XMLRPC::Client.new(ip, '/', port)
      @clients.push(client)
    rescue Errno::ECONNREFUSED => e
      warn "Could not connect to client at #{ip}:#{port}"
    end

    verify_invariants
  end

  def register_exit_listener(&callback)
    @exit_listeners.push(callback)

    verify_invariants
  end

  private

  def verify_invariants
    is_true @clients.length >= 0 && @clients.length <= 2

    @exit_listeners.all? { |listener| CommonContracts.block_callable listener }
  end

end
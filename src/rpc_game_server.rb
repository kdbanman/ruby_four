require 'xmlrpc/utils'
require 'observer'
require_relative '../src/rpc_game_server_contracts'
require_relative '../src/controller/place_token_command'
require_relative '../src/model/game_config'
require_relative '../src/model/board'
require_relative '../src/model/game_type_factory'

class RPCGameServer

  include RPCGameServerContracts

  attr_accessor :game_id, :board, :config

  private

  @master

  @config
  @board
  @game_type

  @game_id

  @clients

  public

  # @param [MasterServer] master_server
  # @param [GameConfig] config
  def initialize(master_server, config = nil)
    @master = master_server
    @clients = Array.new
    @config = config

    verify_invariants
  end

  ####
  # METHODS FOR CALL BY MASTER SERVER
  ####

  # for master server to call.  not intended for clients to call.
  # @param [GameConfig] config
  # @param [String] game_id a uuid
  # @return [Board] the constructed board ready for moves
  def start_from_config(game_id)
    # preconditions
    is_true @board.nil?, 'start_from_* must only be called once'
    is_true !@config.nil?, 'start_from_config must be used with config construction'
    is_gameid game_id

    puts "Starting from config:\n#{@config}"
    @game_type = GameTypeFactory.get_game_type(@config)
    @board = Board.new(@config, @game_type, game_id)

    @game_id = game_id

    verify_invariants

    @board
  end

  # for master server to call.  not intended for clients to call.
  # @param [Board] saved_game
  def start_from_existing(saved_game)
    # preconditions
    is_true @config.nil?, 'start_from_existing must only be called after nil config construction'
    is_true @board.nil?, 'start_from_* must only be called once'
    is_board saved_game

    puts "Starting from board:\n#{saved_game}"
    @config = saved_game.config
    @game_type = GameTypeFactory.get_game_type(@config)
    @board = saved_game

    @game_id = saved_game.game_id

    verify_invariants

    @board
  end


  ####
  # METHODS FOR CALL BY CLIENT OVER RPC
  ####

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

  # @param [Integer] player_id
  # @param [Integer] column
  # @param [Symbol or Integer] token_type
  # @return [Board] the board after tho token placement has been attempted, winner evaluated, etc.
  def place_token(player_id, column, token_type)
    check_winner if PlaceTokenCommand.new(player_id, column, token_type, @game_type).run(@board)

    #TODO check_playable (no winner possible)

    @master.save_game(@game_id, @board) # TODO wrap db exception: client error

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

    # TODO wrap exception XMLRPC::FaultException
    @clients.each { |client| client.call("#{@game_id}.remote_exit_game", playerID)}

    @master.exit_game(@game_id);

    verify_invariants
  end



  private

  def check_winner
    puts @board.most_recent_token

    winner = @game_type.get_winner(@board)
    if winner
      puts "Player #{winner} wins"
      @board.set_winner(winner)
    end

    @master.win_game(@game_id)

    #no need to tell clients - they'll see it in the board update

    verify_invariants
  end

  def verify_invariants
    is_true @clients.length >= 0 && @clients.length <= 2
  end

end
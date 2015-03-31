require 'xmlrpc/utils'
require_relative '../src/controller/place_token_command'
require_relative '../src/model/game_config'
require_relative '../src/model/board'
require_relative '../src/model/game_type_factory'

class RPCGameServer

  attr_accessor :game_id

  private

  @config
  @board
  @game_type

  @game_id

  public

  # not intended for clients to call.
  # @param [GameConfig] config
  # @param [Integer] game_id
  # @return [Board] the constructed board ready for moves
  def start_from_config(config, game_id)
    # preconditions
    # TODO must only be called once.
    # TODO must be a complete config, @config, @board must be nil

    puts "Starting from config:\n#{config}"
    @config = config
    @game_type = GameTypeFactory.get_game_type(config)
    @board = Board.new(config, @game_type, game_id)

    @board
  end

  # @param [Integer] player_id
  # @param [Integer] column
  # @param [Symbol or Integer] token_type
  # @return [Board] the board after tho token placement has been attempted, winner evaluated, etc.
  def place_token(player_id, column, token_type)
    check_winner if PlaceTokenCommand.new(player_id, column, token_type, @game_type).run(@board)
    #TODO check_playable (no winner possible)

    # send board to registered clients

    # postconditions
    # TODO board tokens per player delta of 1 or 0

    @board
  end

  # @param [Integer] playerID
  def exit_game(playerID)
    # TODO save game, broadcast exit to registered clients
  end

  def check_winner
    puts @board.most_recent_token

    if (winner = @game_type.get_winner(@board))
      puts "Player #{winner} wins"
      @board.set_winner(winner)
    end
  end

  def register_client(ip, port)

    # start new rpc client at ip, port

  end

end
require_relative '../util/common_contracts'
require_relative '../controller/place_token_command_contracts'

class PlaceTokenCommand

  attr_reader :column, :player_id

  private

  include PlaceTokenCommandContracts

  @game_type
  @player_id
  @column
  @token_type

  public

  # @param [String] message
  # @param [GameType] game_type
  def initialize(message, game_type)
    #preconditions
    #TODO param types
    #TODO message matches game type token pattern

    @game_type = game_type
    @column = game_type.get_column(message)
    @player_id = game_type.get_player(message)
    @token_type = game_type.get_token_type(message)
  end

  # @param [Board] board
  def run(board)
    #preconditions
    #TODO input is a board

    return unless is_valid_command(board) && board.get_player(@player_id).pop_token(@token_type)

    height = board.get_col_height @column
    token = @game_type.new_token(Coord.new(@column, height + 1), @token_type)
    board.add_token token
    board.switch_player
  end

  private

  # @param [Board] board
  def is_valid_command(board)
    valid = true
    valid &= board.is_current_player @player_id
    valid &= @column >= 0 &&  @column < board.board.col_count
    valid &= board.get_col_height(@column) < board.board.col_height - 1
    valid
  end

end
require_relative '../model/player'
require_relative '../controller/computer_player_contracts'

class ComputerPlayer < Player

  include ComputerPlayerContracts

  private

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  def initialize(name, initial_tokens, id)
    super name, initial_tokens, id
  end

  private

  # @param [Board] board
  def choose_random_column(board)
    # TODO is a board.
    column = -1
    column = Random.rand(board.board.col_count) while board.get_col_height(column) < board.board.col_height - 1
  end

end

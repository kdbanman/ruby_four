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
    height = board.board.col_height
    column = -1
    until height < board.board.col_height - 1
      column = Random.rand(board.board.col_count)
      height = board.get_col_height(column)
    end
    column
  end

end

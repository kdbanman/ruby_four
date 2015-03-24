require_relative '../controller/computer_player'
require_relative '../model/coord'

class HardComputerPlayer < ComputerPlayer

  private

  @token_sym

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  def initialize(name, initial_tokens, id)
    super name, initial_tokens, id
    @token_sym = initial_tokens[0]
  end

  # @param [Board] board
  # @param [Array<Symbol> or Array<Integer>] win_pattern
  # @param [Array<Symbol> or Array<Integer>] lose
  def get_column(board, win_pattern, lose_pattern)
    # preconditions
    if board.full?
      puts 'Computer player sees full board.'
      return nil
    end
    winning_column = find_winning_col board, win_pattern
    return winning_column unless winning_column.nil?

  end

  private

  # @param [Board] board
  # @param [Array<Symbol> or Array<Integer>] win_pattern
  def find_winning_col(board, win_pattern)
    (0...board.board.col_count).each do |col|

      board = board.dup

      candidate_coord = Coord.new(col, board.get_col_height + 1)
      #TODO add token to duplicated board
      board.each_colinear candidate_coord do |line|
        #TODO if game_type.get_winner = me return candidate
      end
    end
  end
end
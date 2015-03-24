require_relative '../controller/computer_player'
require_relative '../model/token'
require_relative '../model/token_proxy'
require_relative '../model/coord'

class HardComputerPlayer < ComputerPlayer

  private

  @game_type

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  # @param [GameType] game_type
  def initialize(name, initial_tokens, id, game_type)
    super name, initial_tokens, id
    @game_type = game_type
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

    choose_random_column board
  end

  private

  # @param [Board] board
  # @param [Array<Symbol> or Array<Integer>] win_pattern
  def find_winning_col(board, win_pattern)
    (0...board.board.col_count).each do |col|
      board = TokenProxy.new(board.tokens, board.board)

      candidate_token = Token.new(Coord.new(col, board.get_col_height(col) + 1),
                                  @game_type.get_player_token_type(@id))
      board.add_token(candidate_token)
      return col if @game_type.get_winner(board) == @id
    end
    nil
  end
end
require_relative '../controller/computer_player'

class HardComputerPlayer < ComputerPlayer

  private

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  def initialize(name, initial_tokens, id)
    super name, initial_tokens, id
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
    choose_random_column board
  end

  private

end
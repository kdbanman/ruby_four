require_relative '../model/player'
require_relative '../controller/computer_player_contracts'

class ComputerPlayer < Player

  include ComputerPlayerContracts

  private

  public

  def initialize

  end

  def get_column(other_player_tokens)
    # preconditions
    token_array other_player_tokens

    column = 1

    # postconditions
    integer_result column

    column
  end

end

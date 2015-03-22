require_relative '../model/game_type_contracts'

module GameType

  include GameTypeContracts

  EXIT_PATTERN = /exit (\d)/
  PLAYER_PATTERN = /token ([12]).*/
  COLUMN_PATTERN = /token [12] (\d).*/

  def GameType.get_exiter(message)
    #preconditions
    #TODO matches pattern
    message[EXIT_PATTERN, 1].to_i
  end

  def GameType.get_player(message)
    #preconditions
    #TODO matches pattern
    message[PLAYER_PATTERN, 1].to_i
  end

  def GameType.get_column(message)
    #preconditions
    #TODO matches pattern
    message[COLUMN_PATTERN, 1].to_i
  end

  # TODO win condition helpers
end
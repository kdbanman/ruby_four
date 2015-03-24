require_relative '../model/game_type_contracts'

module GameType

  include GameTypeContracts

  EXIT_PATTERN = /exit (\d)/
  PLAYER_PATTERN = /token ([12]).*/
  COLUMN_PATTERN = /token [12] (\d).*/

  def GameType.get_exiter(message)
    #preconditions
    message[EXIT_PATTERN, 1].to_i
  end

  def GameType.get_player(message)
    #preconditions
    message[PLAYER_PATTERN, 1].to_i
  end

  def GameType.get_column(message)
    #preconditions
    message[COLUMN_PATTERN, 1].to_i
  end

end
require_relative '../util/contracted'
require_relative '../util/common_contracts'
require_relative '../model/player'
require_relative '../model/board_dimensions'

module DataSourceContracts

  def two_players(players)
    CommonContracts.array players

    unless players.compact.length == 2
      failure 'Must have only 2 players'
    end
    unless players[1].is_a?(Player) && players[2].is_a?(Player)
      failure 'Players may contain only Player objects in positions 1 and 2'
    end
  end

  def has_board(board)
    unless board.is_a? BoardDimensions
      failure 'Must have a board attribute'
    end
  end

end
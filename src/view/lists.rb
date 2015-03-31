require 'gtk'
require_relative '../view/contracts/lists_contracts'
require_relative '../util/common_contracts'

class ListView
  attr_reader :view
  include ListsContracts

  def initalize
  end

  def addItem(view)
    is_a_view view
  end

end

class LoadGame < ListView

  def initialize(games)
    CommonContracts.array games
  end

  def build_row(saved_game)
    is_a_saved_game saved_game
  end
end

class GameStatistics < ListView
  def initialize(stats)
    CommonContracts.array stats
  end

  def buildRow(game_stat)
    is_a_game_stat game_stat
  end
end


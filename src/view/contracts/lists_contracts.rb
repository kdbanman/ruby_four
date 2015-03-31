require 'gtk'
require_relative '../../../src/util/contracted'
require_relative '../../../src/model/containers'

module ListsContracts
  def is_a_view(input)
    failure 'Must pass a view' unless input.is_a? GTK::View
  end

  def is_a_game_stat(input)
    failure 'must pass a GameStat' unless input.is_a? GameStat
  end

  def is_a_saved_game(input)
    failure 'must pass a SavedGame' unless input.is_a? SavedGame
  end

end
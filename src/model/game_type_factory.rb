require_relative '../util/common_contracts.rb'
require_relative 'game_config.rb'

class GameTypeFactory

  include GameTypeFactoryContracts

  def initialize(gamconfig)
  	verify_type(type)
  end

  def build_game_type()
  end

  def set_players(number)
  	CommonContracts.integers(number)
  end

  def set_ai_difficulty(difficulty)
  	CommonContracts.verify_difficulty(difficulty)
  end

end
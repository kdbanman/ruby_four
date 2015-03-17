require_relative '../util/common_contracts.rb'
require_relative 'game_config.rb'

class GameTypeFactory

  include GameTypeFactoryContracts

  def initialize(gamconfig)
  	verify_type(type)
  end

  def buildGameType()
  end

  def setPlayers(number)
  	CommonContracts.integers(number)
  end

  def setAIdifficulty(difficulty)
  	CommonContracts.verify_difficulty(difficulty)
  end

end
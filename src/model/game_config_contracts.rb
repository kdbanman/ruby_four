require_relative '../util/contracted'
require_relative '../util/common_contracts'

module GameConfigContracts

  def verify_type(type)
    CommonContracts.verify_type type
  end

  def verify_player(player)
    CommonContracts.verify_player player
  end

  def verify_difficulty(difficulty)
    CommonContracts.verify_difficulty difficulty
  end

end
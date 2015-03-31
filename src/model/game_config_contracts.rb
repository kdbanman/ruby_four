require_relative '../util/contracted'
require_relative '../util/common_contracts'

module GameConfigContracts

  def verify_type(type)
    CommonContracts.verify_type type
  end

  def verify_player(player)
    unless player == :human || player == :computer
      failure 'Player must either be :human or :computer'
    end
  end

  def verify_name(name)
    CommonContracts.is_username name
  end

  def verify_difficulty(difficulty)
    unless difficulty == :easy || difficulty == :hard
      failure 'Difficulty must either be :easy or :hard'
    end
  end

end

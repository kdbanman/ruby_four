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
    unless name.is_a?(String) && name.length > 0 && name =~ /^[a-zA-Z0-9]*$/
      failure 'Name must be a string with at least one character.'
    end
    unless name =~ /^[a-zA-Z0-9]*$/
      failure 'Name must contain only alphanumeric characters.'
    end
  end

  def verify_difficulty(difficulty)
    unless difficulty == :easy || difficulty == :hard
      failure 'Difficulty must either be :easy or :hard'
    end
  end

end

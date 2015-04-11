require_relative '../src/util/contracted'
require_relative '../src/util/common_contracts'

module MasterServerContracts

  include CommonContracts

  def is_int(*args)
    CommonContracts.integers *args
  end

  def is_positive_int(*args)
    CommonContracts.positive_integers *args
  end

  def is_username(name)
    CommonContracts.is_username name
  end

  def is_passwd(pass)
    CommonContracts.is_passwd pass
  end

  # @param [GameConfig] config
  def at_least_one_player(config)
    unless config.player1 == :human || config.player1 == :computer ||
           config.player2 == :human || config.player2 == :computer
      failure "Config must have at least one player.  has #{config.player1.class}:#{config.player1} #{config.player2.class}:#{config.player2}"
    end
  end

  def is_true(bool, msg = 'Must be true')
    failure msg unless bool
  end

  def one_matches(first, second, tomatch)
    unless first == tomatch || second == tomatch
      failure 'username must be one of the config names'
    end
  end

end
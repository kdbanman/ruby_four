require_relative '../util/contracted'
require_relative '../util/common_contracts'

module GameStatsContracts

  include CommonContracts

  def is_username(name)
    CommonContracts.is_username name
  end

  def is_type(type)
    CommonContracts.verify_type type
  end

  def is_outcome(sym)
    unless sym == "wins" || sym == "losses" || sym == "draws"
      failure 'Outcome must be "wins", "losses", or "draws"'
    end
  end

  def is_positive_int(num)
    CommonContracts.positive_integers num
  end

  def is_hash(obj)
    CommonContracts.is_hash obj
  end

end
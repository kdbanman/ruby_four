require_relative '../util/contracted'
require_relative '../util/common_contracts'

module PlayerContracts

  def valid_name(name)
    unless name.is_a?(String) && name.length > 0
      failure 'Player name must be a nonempty string'
    end
  end

  def token_array(tokens)
    CommonContracts.array(tokens)

    unless tokens.all? { |element| element.is_a? Token }
      failure 'Token array must contain only Tokens'
    end
  end

end
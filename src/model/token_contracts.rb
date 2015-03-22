require_relative '../util/contracted'
require_relative '../util/common_contracts'

module  TokenContracts

  def valid_coord(coord)
    CommonContracts.valid_coordinate coord
  end

  def verify_type(type)
    CommonContracts.verify_type type
  end

  def verify_side(type)
    unless (type == :T || type == :O || type == 1 || type == 2)
      failure 'Tokens must be :T or :O or 1 or 2'
    end
  end
end
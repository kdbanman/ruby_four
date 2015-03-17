require_relative '../util/contracted'
require_relative '../util/common_contracts'

module  TokenContracts

  def valid_coord(coord)
    CommonContracts.valid_coordinate coord
  end

  def verify_type(type)
    CommonContracts.verify_type type
  end

  def verify_side(side, type)
    CommonContracts.verify_type type

    if type == :otto
      unless (side == :T || side == :O)
        failure 'Otto tokens side must be :T or :O'
      end
    end

    if type == :connect4
      unless side == nil
        failure 'Connect 4 tokens side must be nil'
      end
    end
  end
end
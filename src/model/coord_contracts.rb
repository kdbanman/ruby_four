require_relative '../util/contracted'
require_relative '../util/common_contracts'

module CoordContracts

  def valid_coordinate(coord)
    CommonContracts.valid_coordinate coord
  end

end

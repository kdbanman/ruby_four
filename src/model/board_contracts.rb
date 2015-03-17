require_relative '../util/contracted'
require_relative '../util/common_contracts'

module BoardContracts

  def valid_width(width)
    CommonContracts.nonzero_positive_integers width
  end

  def valid_height(height)
    CommonContracts.nonzero_positive_integers height
  end

  def invariants(board)
    valid_width board.col_height
    valid_height board.col_count
  end
end
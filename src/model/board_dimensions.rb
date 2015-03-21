require_relative './board_contracts'

class BoardDimensions

  include BoardContracts

  attr_reader :col_count, :col_height

  private

  public

  def initialize(col_count, col_height)
    # preconditions
    valid_width col_count
    valid_height col_height

    @col_count = col_count
    @col_height = col_height

    invariants self
  end

end
require_relative './board_contracts'

class Board

  include BoardContracts

  attr_reader :col_count, :col_height

  private

  public

  def initialize(col_count, col_height)
    # preconditions
    valid_width col_count
    valid_height col_height

    #postconditions

    invariants self
  end

end
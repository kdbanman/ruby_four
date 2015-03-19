require_relative '../model/coord_contracts'

# Read only coordinate class with x (column number) and y (height)
# Bottom left of board is 0,0
class Coord

  include CoordContracts

  attr_reader :column, :height

  alias_method :x, :column
  alias_method :y, :height

  # @param [Integer] column
  # @param [Integer] height
  def initialize(column, height)
    @column = column
    @height = height

    verify_invariants
  end

  private

  def verify_invariants
    valid_coordinate self
  end

end

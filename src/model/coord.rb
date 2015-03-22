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

  def to_s
    "(#{@column}, #{@height})"
  end

  # @param [Coord] coord
  def +(coord)
    Coord.new(@column + coord.column, @height + coord.height)
  end

  # @param [Coord] coord
  def -(coord)
    Coord.new(@column - coord.column, @height - coord.height)
  end

  # @param [Coord] coord
  def eql?(coord)
    coord.class.equal?(self.class) && coord.column.eql?(@column) && coord.height.eql?(@height)
  end
  alias_method :==, :eql?

  def hash
    @column.hash ^ (-1 * @height).hash
  end

  private

  def verify_invariants
    valid_coordinate self
  end

end


# Read only coordinate class with x (column number) and y (height)
class Coord

  attr_reader :column, :height

  alias_method :x, :column
  alias_method :y, :height

  def initialize(column, height)
    @column = column
    @height = height

    verify_invariants
  end

  private

  def verify_invariants

  end

end
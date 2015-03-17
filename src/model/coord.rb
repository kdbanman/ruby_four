
# Read only coordinate class with x (column number) and y (height)
class Coord

  attr_reader :column, :height

  alias_method :x, :column
  alias_method :y, :height

  def initialize(column, height)

  end

end
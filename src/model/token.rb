require_relative '../model/token_contracts'
require_relative '../model/coord'

class Token

  include TokenContracts

  attr_reader :coord, :type

  private

  public

  # @param [Coord] coord
  # @param [Symbol or Integer] type either :T or :O (otto tokens) or 1 or 2 (connect4 tokens)
  def initialize(coord, type)
    @coord = coord
    @type = type

    verify_invariants
  end

  def to_s
    str = "col: #{@coord.column} height: #{@coord.height}"
    str + " type: #{@type.to_s}"
  end

  private

  def verify_invariants
    valid_coord @coord
    verify_side @type
  end

end
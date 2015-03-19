require_relative '../model/token_contracts'
require_relative '../model/coord'

class Token

  include TokenContracts

  attr_reader :coord, :type, :side

  private

  public

  # @param [Coord] coord
  # @param [Symbol] type either :otto or :connect4
  # @param [Symbol] side either :T or :O (or default nil for :connect4 game type)
  def initialize(coord, type, side = nil)
    @coord = coord
    @type = type
    @side = side

    verify_invariants
  end

  private

  def verify_invariants
    valid_coord @coord
    verify_type @type
    verify_side @side, @type
  end

end
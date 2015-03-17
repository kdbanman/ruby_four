require_relative '../model/token_contracts'

class Token

  include TokenContracts

  attr_reader :coord, :type, :side

  private

  public

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
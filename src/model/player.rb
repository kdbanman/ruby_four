require_relative '../model/player_contracts'

class Player

  include PlayerContracts

  attr_reader :name

  private

  @name

  public

  # @param [String] name
  def initialize(name)
    @name = name

    verify_invariants
  end

  private

  def verify_invariants
    valid_name @name
  end

end
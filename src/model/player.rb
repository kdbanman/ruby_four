require_relative '../model/player_contracts'

class Player

  include PlayerContracts

  private

  @name
  @tokens

  public

  # @param [String] name
  def initialize(name)
    @name = name
    @tokens = Array.new

    verify_invariants
  end

  private

  def verify_invariants
    valid_name @name
    token_array @tokens
  end

end
require_relative '../model/player_contracts'

class Player

  include PlayerContracts

  attr_reader :name, :remaining_tokens, :id

  private

  @name
  @remaining_tokens
  @id

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  def initialize(name, initial_tokens, id)
    @name = name
    @remaining_tokens = initial_tokens
    @id = id
    verify_invariants
  end

  # @param [Symbol or Integer or nil] type
  def pop_token(type)
    @remaining_tokens.delete_at(@remaining_tokens.index(type) || @remaining_tokens.length)
  end

  private

  def verify_invariants
    valid_name @name
  end

end
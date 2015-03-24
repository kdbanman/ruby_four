require_relative '../model/player'

class HumanPlayer < Player

  private

  public

  # @param [String] name
  # @param [Array<Symbol> or Array<Integer>]
  # @param [Integer] id
  def initialize(name, initial_tokens, id)
    super name, initial_tokens, id
  end

  def get_column(*args)
    return nil
  end

end
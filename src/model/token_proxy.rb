require_relative '../model/abstract_board'

# Intended for use using only the iterators and add_token from Board.  Other functionality not supported.
class TokenProxy < AbstractBoard

  private

  public

  # @param [Hash<Coord, Token>] tokens
  # @param [BoardDimensions] dims
  def initialize(tokens, dims)
    @tokens = tokens.clone
    @board = dims
    @token_count = @tokens.length
  end

end
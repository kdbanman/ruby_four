require_relative '../model/game_type_contracts'

module  OttoGameType

  include GameTypeContracts

  # @param [Coord] coord
  # @param [Symbol] side either :T or :O
  def OttoGameType.new_token(coord, side)
    Token.new(coord, :otto, side)
  end

  # @param [Array<Token>] player_tokens
  def OttoGameType.is_winner(player_tokens)
    #TODO implement me
    false
  end

end
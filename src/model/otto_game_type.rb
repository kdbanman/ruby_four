require_relative '../model/game_type_contracts'
require_relative '../model/token'
require_relative '../model/game_type'

module  OttoGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d) ([TO])/

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

  private

  def OttoGameType.method_missing(m, *args, &block)
    GameType.send(m, *args, &block)
  end

end
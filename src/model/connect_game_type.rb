require_relative '../model/game_type_contracts'
require_relative '../model/token'

module  ConnectGameType

  include GameTypeContracts

  # @param [Coord] coord
  def new_token(coord)
    Token.new(coord, :connect4)
  end

  # @param [Array<Token>] player_tokens
  def is_winner(player_tokens)
    #TODO implement me
    player_tokens.length > 4 && Random.rand(100) < 50
  end

end
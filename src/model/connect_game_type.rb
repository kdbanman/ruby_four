require_relative '../model/game_type_contracts'
require_relative '../model/token'

module  ConnectGameType

  include GameTypeContracts

  # @param [Coord] coord
  def ConnectGameType.new_token(coord, side = nil)
    Token.new(coord, :connect4)
  end

  # @param [Array<Token>] player_tokens
  def ConnectGameType.is_winner(player_tokens)
    #TODO implement me
    Random.rand(100) < 80
  end

end
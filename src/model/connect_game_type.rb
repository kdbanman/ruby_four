require_relative '../model/game_type_contracts'
require_relative '../model/game_type'
require_relative '../model/token'

module  ConnectGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d)/

  # @param [Coord] coord
  def ConnectGameType.new_token(coord, side = nil)
    Token.new(coord, :connect4)
  end

  # @param [Array<Token>] player_tokens
  def ConnectGameType.is_winner(player_tokens)
    #TODO implement me
    false
  end

  private

  def ConnectGameType.method_missing(m, *args, &block)
    GameType.send(m, *args, &block)
  end

end
require_relative '../model/game_type_contracts'
require_relative '../model/game_type'
require_relative '../model/token'

module  ConnectGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d)/

  # @param [Coord] coord
  # @param [Integer] player 1 for player 1, 2 for player 2
  def ConnectGameType.new_token(coord, player)
    # preconditions
    # TODO player is 1 or 2
    Token.new(coord, player)
  end

  # @param [String] message
  def ConnectGameType.get_token_type(message)
    #precondition
    #TODO matches token pattern
    message[TOKEN_PATTERN, 1].to_sym
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
require_relative '../model/game_type_contracts'
require_relative '../model/token'
require_relative '../model/game_type'

module  OttoGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d) ([TO])/

  # @param [Coord] coord
  # @param [Symbol] letter either :T or :O
  def OttoGameType.new_token(coord, letter)
    # preconditions
    #TODO letter is :T or :O
    Token.new(coord, letter)
  end

  # @param [String] message
  def OttoGameType.get_token_type(message)
    #precondition
    #TODO matches token pattern
    message[TOKEN_PATTERN, 3].to_sym
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
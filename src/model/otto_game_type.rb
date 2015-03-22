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

  # @param [Board] board
  # @return [Integer or nil] nil for no winner, 1 or 2 for player winner
  def ConnectGameType.get_winner(board)
    #TODO implement me
    nil
  end

  private

  def OttoGameType.method_missing(m, *args, &block)
    GameType.send(m, *args, &block)
  end

end
require_relative '../model/game_type_contracts'
require_relative '../model/game_type'
require_relative '../model/token'

module  ConnectGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d)/

  WIN_PATTERN_1 = [1, 1, 1, 1]
  WIN_PATTERN_2 = [2, 2, 2, 2]

  # @param player [Integer] player 1 or 2
  # @param board [Integer] count
  def ConnectGameType.make_initial_tokens(player, count)
    # preconditions
    #TODO player is either 1 or 2
    #TODO count is >= 16 (min 4x4 game)
    (1..count).map { player }
  end

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
    message[TOKEN_PATTERN, 1].to_i
  end

  # @param [Board] board
  # @return [Integer or nil] nil for no winner, 1 or 2 for player winner
  def ConnectGameType.get_winner(board)
    board.each_colinear(board.most_recent_token.coord) do |line|
      return 1 if line == WIN_PATTERN_1
      return 2 if line == WIN_PATTERN_2
    end
    nil
  end

  private

  def ConnectGameType.method_missing(m, *args, &block)
    GameType.send(m, *args, &block)
  end

end
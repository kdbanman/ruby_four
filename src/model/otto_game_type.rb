require_relative '../model/game_type_contracts'
require_relative '../model/token'
require_relative '../model/game_type'

module  OttoGameType

  include GameTypeContracts
  include GameType

  TOKEN_PATTERN = /token ([12]) (\d) ([TO])/

  WIN_PATTERN_1 = [:O, :T, :T, :O]
  WIN_PATTERN_2 = [:T, :O, :O, :T]

  # @param player [Integer] player 1 or 2
  # @param board [Integer] count
  def OttoGameType.make_initial_tokens(player, count)
    # preconditions
    (1..count).map { player == 1 ? :T : :O }
  end

  # @param [Coord] coord
  # @param [Symbol] letter either :T or :O
  def OttoGameType.new_token(coord, letter)
    # preconditions
    Token.new(coord, letter)
  end

  # @param [String] message
  def OttoGameType.get_token_type(message)
    #precondition
    message[TOKEN_PATTERN, 3].to_sym
  end

  # @param [Board] board
  # @return [Integer or nil] nil for no winner, 1 or 2 for player winner
  def OttoGameType.get_winner(board)
    board.each_colinear(board.most_recent_token.coord) do |line|
      return 1 if line == WIN_PATTERN_1
      return 2 if line == WIN_PATTERN_2
    end
    nil
  end

  # @param [Symbol] either :T or :O
  def OttoGameType.get_token_image_path(token_type)
    return File.dirname(__FILE__) + '/../resources/tPiece.png' if token_type == :T
    return File.dirname(__FILE__) + '/../resources/oPiece.png' if token_type == :O
  end

  # @param [Integer] player_id
  def OttoGameType.get_player_token_type(player_id)
    return :T if player_id == 1
    return :O if player_id == 2
  end

  # @param [Integer] player_id
  def OttoGameType.get_win_pattern(player_id)
    return WIN_PATTERN_1 if player_id == 1
    return WIN_PATTERN_2 if player_id == 2
  end

  private

  def OttoGameType.method_missing(m, *args, &block)
    GameType.send(m, *args, &block)
  end

end
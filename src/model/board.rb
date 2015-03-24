require_relative '../controller/human_player'
require_relative '../controller/easy_computer_player'
require_relative '../controller/hard_computer_player'
require_relative '../model/board_dimensions'
require_relative '../model/game_config'

class Board

  attr_reader :board, :tokens, :token_count, :most_recent_token, :player1, :player2, :current_player_id, :winner

  private

  @board
  @tokens
  @token_count
  @most_recent_token

  @player1
  @player2
  @current_player_id
  @winner

  public

  # @param [GameConfig] config
  # @param [GameType] game_type
  def initialize(config, game_type)
    @board = BoardDimensions.new(config.num_cols, config.num_rows)
    @tokens = Hash.new
    @token_count = 0

    player_token_count = (config.num_rows * config.num_cols / 2.0).ceil

    # TODO this should use a player factory initialized with token count, game type.
    @player1 = build_player(player_token_count, game_type, config.player1, config.name1, 1, config.difficulty)
    @player2 = build_player(player_token_count, game_type, config.player2, config.name2, 2, config.difficulty)

    @current_player_id = 1
  end

  # @param [Integer] token_count
  # @param [GameType] game_type
  # @param [Symbol] type either :human or :computer
  # @param [String] name
  # @param [Integer] id either 1 or 2
  # @param [Symbol] difficulty either :easy or :hard
  def build_player(token_count, game_type, type, name, id, difficulty = :easy)
    return HumanPlayer.new(name, game_type.make_initial_tokens(id, token_count), id) if (type == :human)

    return EasyComputerPlayer.new(name, game_type.make_initial_tokens(id, token_count), id) if (difficulty == :easy)
    HardComputerPlayer.new(name, game_type.make_initial_tokens(id, token_count), id)
  end

  # @param [Token] token
  def add_token(token)
    # preconditions
    #TODO token is a token
    #TODO token is in bounds
    #TODO token coord is not filled

    @token_count += 1
    @most_recent_token = tokens[token.coord] = token
  end

  # @return [Player] player 1 or player 2
  def get_player(id)
    #preconditions
    #TODO id is 1 or 2
    if id == 1
      @player1
    else
      @player2
    end
  end

  def switch_player
    @current_player_id = 1 + @current_player_id % 2
  end

  def current_player
    return @player1 if @current_player_id == 1
    return @player2 if @current_player_id == 2
  end

  # @param [Integer] id
  def is_current_player(id)
    id == @current_player_id
  end

  # @param [Integer] column
  def get_col_height(column)
    height = -1
    @tokens.each_key { |coord| height = [height, coord.height].max if coord.column == column }
    height
  end

  def full?
    @tokens.length == @board.col_count * @board.col_height
  end

  # @param [Coord] coord
  # @yieldparam [Array<Symbol> or Array<Integer>] line of token types colinear coordinate. nils possible!
  def each_colinear(coord)

    # top-left to bottom-right lines
    each_colinear_in_direction(-1, 1, coord) { |line| yield line }

    # left to right lines intersecting coord
    each_colinear_in_direction(-1, 0, coord) { |line| yield line }

    # bottom-left to top-right lines
    each_colinear_in_direction(-1, -1, coord) { |line| yield line }

    # bottom to top lines
    each_colinear_in_direction(0, -1, coord) { |line| yield line }

  end

  # @param [Integer] x either -1, 0, or 1
  # @param [Integer] y either -1, 0, or 1
  def each_colinear_in_direction(x, y, coord)
    (0...4).each do |line_offset|
      line = (0...4).collect do |element_offset|
        offset = Coord.new(x * (line_offset - element_offset),
                           y * (line_offset - element_offset))
        @tokens[coord + offset].type unless @tokens[coord + offset].nil?
      end
      yield line
    end
  end

  # @param [Integer] player_id either 1 or 2
  def set_winner(player_id)
    # make sure winner is only set once
    if @winner.nil?
      @winner = player1 if player_id == 1
      @winner = player2 if player_id == 2
    end
  end

end
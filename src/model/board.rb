require_relative '../model/player'
require_relative '../model/board_dimensions'
require_relative '../model/game_config'

class Board

  attr_reader :board, :tokens, :player1, :player2, :current_player_id

  private

  @board
  @tokens
  @player1
  @player2
  @current_player_id

  public

  # @param [GameConfig] config
  def initialize(config)
    @board = BoardDimensions.new(config.num_cols, config.num_rows)
    @tokens = Hash.new
    @player1 = Player.new(config.name1)
    @player2 = Player.new(config.name2)

    @current_player_id = 1
  end

  # @param [Token] token
  def add_token(token)
    # preconditions
    #TODO token is a token
    #TODO token is in bounds
    #TODO token coord is not filled

    tokens[token.coord] = token
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
    height = 0
    @tokens.each_key { |coord| height = [height, coord.height].max if coord.column == column }
    height
  end

end
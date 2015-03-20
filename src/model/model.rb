require_relative '../model/player'
require_relative '../model/board'
require_relative '../model/game_config'

class Model

  attr_reader :board, :player1, :player2, :current_player_id

  private

  @board
  @player1
  @player2
  @current_player_id

  public

  # @param [GameConfig] config
  def initialize(config)
    @board = Board.new(config.num_cols, config.num_rows)
    @player1 = Player.new(config.name1)
    @player2 = Player.new(config.name2)
    @current_player_id = 1
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
    @player1.tokens.each { |token| height = [height, token.coord.height].max}
    @player2.tokens.each { |token| height = [height, token.coord.height].max}
    height
  end

end
require_relative '../model/player'
require_relative '../model/board'
require_relative '../model/game_config'

class Model

  attr_reader :board, :player1, :player2

  private

  @board
  @player1
  @player2

  public

  # @param [GameConfig] config
  def initialize(config)
    @board = Board.new(config.num_cols, config.num_rows)
    @player1 = Player.new(config.name1)
    @player2 = Player.new(config.name2)
  end

end
gem 'minitest'
require 'minitest/autorun'
require_relative '../src/util/contracted'
require_relative '../src/model/board'
require_relative '../src/model/coord'
require_relative '../src/model/data_source'
require_relative '../src/model/game_type'
require_relative '../src/model/game_type_factory'
require_relative '../src/model/player'
require_relative '../src/model/token'
require_relative '../src/model/game_config'

class ModelTests < Minitest::Test

  def test_board
    b = Board.new(6, 7)
  end

  def test_coord
    c = Coord.new(3, 3)
  end

  def test_datasource
    d = DataSource.new
  end

  def test_game_type
    gt = GameType.new
  end

  def test_game_type_fact
    gtf = GameTypeFactory.new
  end

  def test_player
    p = Player.new 'namey'
  end

  def test_token
    t = Token.new Coord.new(1,1), :otto, :T
  end

  def test_config
    c = GameConfig.new :otto, :human, :computer, 'steve', 'jimbo', :hard
  end

end

gem 'minitest'
require 'minitest/autorun'
require '../src/util/contracted'
require '../src/model/board'
require '../src/model/coord'
require '../src/model/data_source'
require '../src/model/game_type'
require '../src/model/game_type_factory'
require '../src/model/player'
require '../src/model/token'
require '../src/model/game_config'

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
    c = GameConfig.new :otto, :human, :computer, :hard
  end

end
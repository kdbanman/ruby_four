require_relative '../controller/window_manager'
require_relative '../model/game_config'
require_relative '../model/data_source'
require_relative '../model/game_type_factory'
require_relative '../view/game_screen'
require_relative '../view/stats_screen'
require_relative '../model/containers'


class UITestingFramework
  @window_manager
  @game_config
  @game_type
  @data_source

  def initialize
    @window_manager = WindowManager.new
  end

  def push_stats_screen
    username = 'Bob'
    stats = []
    stats << GameStat.new(:connect4, username, 1, 2, 3)
    stats << GameStat.new(:otto, username, 4, 5, 6)
    stats << GameStat.new(:connect4, 'Alice', 7, 7, 7)

    stats_screen = StatsScreen.new(username, stats)
    @window_manager.open_window stats_screen
    @window_manager.start
  end

  def push_game_screen
    set_up_game_config
    @window_manager.open_window GameScreen.new @game_type, @data_source, @game_config
    @window_manager.start
  end

  def set_up_game_config()
    @game_config = GameConfig.new(:connect4, :human, :human, 'player1', 'player2', :hard, 10, 10)
    @game_type = GameTypeFactory.get_game_type @game_config
    #TODO talk to kirby about how to start a game server
    @data_source = DataSource.new @game_config
  end

end

framework = UITestingFramework.new

# Test Game Screen
# framework.push_game_screen

# Test Stats Screen
framework.push_stats_screen
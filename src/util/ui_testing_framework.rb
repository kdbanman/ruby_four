require_relative '../controller/window_manager'
require_relative '../model/game_config'
require_relative '../model/data_source'
require_relative '../model/game_type_factory'
require_relative '../view/game_screen'
require_relative '../view/stats_screen'
require_relative '../view/load_game_screen'
require_relative '../model/containers'


class UITestingFramework
  @window_manager
  @game_config
  @game_type
  @data_source

  def initialize
    @window_manager = WindowManager.new
  end

  def push_load_game_screen
    player1 = 'Bob'
    player2 = 'Alice'
    saved_games = []

    8.times {|i| saved_games << SavedGame.new(player1, player2, i, :otto)}
    8.times {|i| saved_games << SavedGame.new(player1, player2, i+8, :connect4)}

    load_game_screen = LoadGameScreen.new(saved_games)

    load_game_screen.set_on_ok_listener {|id| @window_manager.push_information_dialog "Load Game Clicked on game: #{id}" }
    @window_manager.open_window(load_game_screen)
    @window_manager.start
  end

  def push_stats_screen
    username = 'Bob'
    stats = []
    stats << GameStat.new(:connect4, username, 1, 2, 3)
    stats << GameStat.new(:otto, username, 4, 5, 6)
    15.times {|i| stats << GameStat.new(:connect4, 'c4_player' + i.to_s, 7, 7, 7)}
    15.times {|i| stats << GameStat.new(:otto, 'otto_player' + i.to_s, 7, 7, 7)}

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
# framework.push_stats_screen

# Test Load Game
framework.push_load_game_screen
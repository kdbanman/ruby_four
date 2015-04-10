require_relative '../controller/window_manager'
require_relative '../model/game_config'
require_relative '../model/data_source'
require_relative '../model/game_type_factory'
require_relative '../view/game_screen'
require_relative '../view/stats_screen'
require_relative '../view/load_game_screen'
require_relative '../model/containers'
require_relative '../view/login_screen'
require_relative '../view/main_screen'
require_relative '../view/new_game_dialog'

class UITestingFramework
  @window_manager
  @game_config
  @game_type
  @data_source

  def initialize
    @window_manager = WindowManager.new
  end

  def push_main_screen
    ds = FakeDS.new

    main_screen = MainScreen.new ds

    main_screen.set_load_game_listener {push_load_game_screen}
    main_screen.set_refresh_listener {main_screen.update}
    main_screen.set_stats_listener {push_stats_screen}
    main_screen.set_new_game_listener{push_new_game_dialog}

    #TODO replace with real screens
    main_screen.set_join_game_listener{ |game_id| @window_manager.push_information_dialog "Requested to join game #{game_id}"}

    @window_manager.set_head_and_kill_rest main_screen
    @window_manager.start unless @window_manager.started
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
    @window_manager.start unless @window_manager.started
  end

  def push_login_Screen
    screen = LoginScreen.new
    screen.set_sign_in_listener do |u, p, ip|
      puts "Signed in with: #{u}, #{p}, #{ip}"
      push_main_screen
    end
    @window_manager.open_window(screen)
    @window_manager.start unless @window_manager.started
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
    @window_manager.start unless @window_manager.started
  end

  def push_game_screen
    set_up_game_config
    @window_manager.open_window GameScreen.new @game_type, @data_source, @game_config
    @window_manager.start unless @window_manager.started
  end

  def set_up_game_config()
    @game_config = GameConfig.new(:connect4, :human, :human, 'player1', 'player2', :hard, 10, 10)
    @game_type = GameTypeFactory.get_game_type @game_config
    #TODO talk to kirby about how to start a game server
    @data_source = DataSource.new @game_config
  end

  def push_new_game_dialog
    @window_manager.open_window NewGameDialog.new
    @window_manager.start unless @window_manager.started
  end

end

class FakeDS
  @rnd
  @observers

  def initialize
    @rnd = Random.new
    @observers = []
  end

  def add_observer(window)
    @observers << window
  end

  def open_games
    list = []
    @rnd.rand(15).times do |i|
      gametype = :otto if i % 2 == 0
      gametype = :connect4 if i % 2 == 1

      list << OpenGame.new(i, "Player-#{i}", gametype)
    end
    list
  end
end

framework = UITestingFramework.new

# Test Game Screen
# framework.push_game_screen

# Test Stats Screen
# framework.push_stats_screen

# Test Load Game
#framework.push_load_game_screen

#Test Login Screen
framework.push_login_Screen

#Test Main Screen
#framework.push_main_screen
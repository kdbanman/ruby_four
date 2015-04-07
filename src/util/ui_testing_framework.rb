require_relative '../controller/window_manager'
require_relative '../model/game_config'
require_relative '../model/data_source'
require_relative '../model/game_type_factory'
require_relative '../view/game_screen'


class UITestingFramework
  @window_manager
  @game_config
  @game_type
  @data_source

  def initialize
    @window_manager = WindowManager.new
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

a = UITestingFramework.new
a.push_game_screen
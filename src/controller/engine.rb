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
require_relative '../model/master_data_source'

require 'xmlrpc/client'

class Engine

  private

  #Master Game Server (proxy)
  @master

  #Window Manager
  @window_manager

  public

  def initialize
    @window_manager = WindowManager.new
  end

  def start
    push_login_Screen
  end

  def push_main_screen
    main_screen = MainScreen.new @master

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
    load_game_screen = LoadGameScreen.new(@master.saved_games)

    load_game_screen.set_on_ok_listener {|id| @master.start_saved_game id }
    @window_manager.open_window(load_game_screen)
    @window_manager.start unless @window_manager.started
  end

  def push_login_Screen
    screen = LoginScreen.new
    screen.set_sign_in_listener do |u, p, ip|
      puts "Signed in with: #{u}, #{p}, #{ip}"
      connect_to_server(u, p, ip)
      attempt_login(u, p)
    end
    @window_manager.open_window(screen)
    @window_manager.start unless @window_manager.started
  end

  def push_stats_screen
    stats_screen = StatsScreen.new(@master.username, @master.get_stats)
    @window_manager.open_window stats_screen
    @window_manager.start unless @window_manager.started
  end

  def push_game_screen
    @game_config = GameConfig.new(:connect4, :human, :human, 'player1', 'player2', :hard, 10, 10) unless @game_config
    set_up_game_config unless @game_type

    game_screen = GameScreen.new @game_type, @data_source, @game_config
    game_screen.set_column_selected_listener { |num| puts "Column Selected: #{num}" }
    game_screen.set_close_listener {push_main_screen}
    game_screen.set_board_full_listenener{@window_manager.push_information_dialog 'Board Full'}
    game_screen.set_win_listener {@window_manager.push_information_dialog 'There was a winner'}

    @window_manager.set_head_and_kill_rest game_screen
    @window_manager.start unless @window_manager.started
  end

  def set_up_game_config()
    #@game_config = GameConfig.new(:connect4, :human, :human, 'player1', 'player2', :hard, 10, 10)
    @game_type = GameTypeFactory.get_game_type @game_config
    #TODO talk to kirby about how to start a game server
    #@data_source = DataSource.new @game_config
  end

  def push_new_game_dialog
    new_game_dialog = NewGameDialog.new
    new_game_dialog.set_ok_listener do |gameconfig|
      @game_config = gameconfig
      set_up_game_config
      push_game_screen
    end

    @window_manager.open_window new_game_dialog
    @window_manager.start unless @window_manager.started
  end

  private
  def connect_to_server(username, password, ip)
    server_address = ip.split(':')
    begin
      server = XMLRPC::Client.new(server_address[0], '/',server_address[1])
      server.timeout = 3000
      @master = MasterDataSource.new server.proxy('master')
    rescue Errno::ECONNREFUSED => e
      puts 'ERROR: COULD NOT CONNECT TO SERVER'
      @window_manager.push_information_dialog('Could not connect to server!')
    end
  end

  def attempt_login(username, password)
    if @master
      begin
        if @master.login(username, password)
          push_main_screen
        else
          @window_manager.push_information_dialog('Login Credentials, are incorrect')
        end
      rescue
        @window_manager.push_information_dialog('Server Connection Error')
      end
    end
  end

end

engine = Engine.new
engine.start
require_relative '../view/contracts/main_screen_contracts'
require_relative '../util/common_contracts'
require_relative '../view/window'
require_relative '../resources/about_screen'

require 'gtk2'

class MainScreen
  include Window
  @screen
  @builder
  @treeview

  @load_game_listener
  @new_game_listener
  @stats_listener
  @refresh_listener
  @join_game_listener

  @datasource


  def initialize(datasource)
    @builder = Gtk::Builder.new
    @builder.add_from_file File.dirname(__FILE__) + '/../resources/main_screen.glade'
    @screen = @builder.get_object('main_screen')
    @datasource = datasource

    @datasource.add_observer(self)

    build_screen
  end

  def start
    MainScreenContracts.listener_not_null @load_game_listener, 'Load Game'
    MainScreenContracts.listener_not_null @new_game_listener, 'New Game'
    MainScreenContracts.listener_not_null @stats_listener, 'Stats'
    MainScreenContracts.listener_not_null @refresh_listener, 'Refresh'
    MainScreenContracts.listener_not_null @join_game_listener, 'Join Game'
    @screen.show_all
  end

  def kill
    @screen.destroy
  end

  def set_on_destroy(&block)
    CommonContracts.block_callable block
    @screen.signal_connect('destroy') { block.call }
  end

  def build_screen
    @treeview = @builder.get_object('open_games_treeview')
    @builder.get_object('refresh_button').signal_connect('released') {@refresh_listener.call}
    @builder.get_object('stats_button').signal_connect('released') {@stats_listener.call}
    @builder.get_object('load_game_button').signal_connect('released') {@load_game_listener.call}
    @builder.get_object('new_game_button').signal_connect('released') {@new_game_listener.call}
    @builder.get_object('join_game_button').signal_connect('released') do
      selection = @treeview.selection.selected
      @join_game_listener.call(selection) if selection
    end

    @builder.get_object('new_game_menuitem').signal_connect('activate') {@new_game_listener.call}
    @builder.get_object('load_game_menuitem').signal_connect('activate') {@load_game_listener.call}
    @builder.get_object('stats_menuitem').signal_connect('activate') {@stats_listener.call}
    @builder.get_object('quit_menuitem').signal_connect('activate') {kill}
    @builder.get_object('about_menuitem').signal_connect('activate') {AboutScreen.new}


    renderer = Gtk::CellRendererText.new

    col = Gtk::TreeViewColumn.new('Game ID', renderer, :text=> 0)
    @treeview.append_column col

    col = Gtk::TreeViewColumn.new('Game Type', renderer, :text=> 1)
    @treeview.append_column col

    col = Gtk::TreeViewColumn.new('Player', renderer, :text=> 2)
    @treeview.append_column col

    update
  end

  def update
    @treeview.model = build_list
  end


  def set_load_game_listener(&block)
    CommonContracts.block_callable block
    @load_game_listener = block
  end

  def set_new_game_listener(&block)
    CommonContracts.block_callable block
    @new_game_listener = block
  end

  def set_stats_listener(&block)
    CommonContracts.block_callable block
    @stats_listener = block
  end

  def set_refresh_listener(&block)
    CommonContracts.block_callable block
    @refresh_listener = block
  end

  def set_join_game_listener(&block)
    CommonContracts.block_callable block
    @join_game_listener = block
  end

  private
  def call_load_game_listener
    @load_game_listener.call
  end

  def call_new_game_listener
    @new_game_listener.call
  end

  def call_stats_listener
    @stats_listener.call
  end

  def call_refresh_listener
    @refresh_listener.call
  end

  def call_join_game_listener(game_id)
    @join_game_listener.call game_id
  end

  def build_list
    #Game ID, Game Type, Player
    list_store = list_store = Gtk::ListStore.new(Integer, String, String)
    list = @datasource.open_games.sort {|x, y| x.game_id <=> y.game_id}

    list.each do |game|
      row_item = list_store.append
      row_item[0] = game.game_id
      row_item[1] = game.game_type.to_s
      row_item[2] = game.player_name
    end

    list_store
  end
end
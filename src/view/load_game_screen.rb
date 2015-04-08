require_relative '../view/window'
require_relative '../util/common_contracts'

require 'gtk2'

class LoadGameScreen
  include Window

  @saved_games
  @screen

  def initialize(saved_games)
    CommonContracts.array saved_games
    @saved_games = saved_games
    build_screen
  end

  def set_on_destroy(&block)
    @screen.signal_connect('destroy') { block.call }
  end

  def start
    @screen.show_all
  end

  def kill
    @screen.destroy
  end

  private
  def build_screen
    gtk_builder = @builder = Gtk::Builder.new
    gtk_builder.add_from_file(File.dirname(__FILE__) + '/../resources/load_game_screen.glade')

    @screen = gtk_builder.get_object('Load_Game')
    build_tree gtk_builder
  end

  def build_tree(builder)
    tree = builder.get_object('saved_games_treeview')
    tree.model = build_list
    tree.selection.mode = Gtk::SELECTION_SINGLE

    renderer = Gtk::CellRendererText.new


    col = Gtk::TreeViewColumn.new('Game ID', renderer, :text => 0)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Game Type', renderer, :text => 1)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Player 1', renderer, :text => 2)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Player 2', renderer, :text => 3)
    tree.append_column col

    tree
  end

  def build_list
    list_store = Gtk::ListStore.new(Integer, String, String, String)
    @saved_games.sort! {|x, y| x.game_id <=> y.game_id}

    @saved_games.each do |game|
      row_item = list_store.append
      row_item[0] = game.game_id
      row_item[1] = game.game_type.to_s
      row_item[2] = game.player_1_name
      row_item[3] = game.player_2_name
    end

    list_store
  end
end
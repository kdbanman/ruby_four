require_relative '../view/window'
require_relative '../model/containers'

require 'gtk2'

class StatsScreen
  include Window

  @player_name
  @stats
  @screen

  # @param [String] player_name
  # @param [Array] all_stats
  def initialize(player_name, all_stats)
    @player_name = player_name
    @stats = all_stats
    build_screen
  end

  def start
  @screen.show_all

  #post
  CommonContracts.is_visible @screen
  end

  def set_on_destroy(&block)
    @screen.signal_connect('destroy') { block.call }
  end

  def kill
    @screen.destroy
  end

  private
  def build_screen
    gtk_builder = @builder = Gtk::Builder.new
    gtk_builder.add_from_file(File.dirname(__FILE__) + '/../resources/stats_screen.glade')
    @screen = gtk_builder.get_object('stats_window')
    build_personal_tab(gtk_builder)
    build_league_tab(gtk_builder)
  end

  def build_personal_tab(builder)
    c4_stat = find_game_stat("connect4")
    otto_stat = find_game_stat("otto")

    builder.get_object('connect4_wins_label').set_text(c4_stat.wins.to_s)
    builder.get_object('connect4_losses_label').set_text(c4_stat.losses.to_s)
    builder.get_object('connect4_draws_label').set_text(c4_stat.draws.to_s)

    builder.get_object('otto_wins_label').set_text(otto_stat.wins.to_s)
    builder.get_object('otto_losses_label').set_text(otto_stat.losses.to_s)
    builder.get_object('otto_draws_label').set_text(otto_stat.draws.to_s)

  end

  def build_league_tab(builder)
    c4_tree = build_tree_view('connect4_treeview', builder, "connect4")
    otto_tree = build_tree_view('otto_treeview', builder, "otto")

  end

  def build_tree_view(name, builder, game_type)
    tree = builder.get_object(name)
    tree.model = build_list game_type
    tree.selection.mode = Gtk::SELECTION_NONE

    renderer = Gtk::CellRendererText.new

    col = Gtk::TreeViewColumn.new('Rank', renderer, :text => 0)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Username', renderer, :text => 1)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Wins', renderer, :text => 2)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Losses', renderer, :text => 3)
    tree.append_column col

    col = Gtk::TreeViewColumn.new('Draws', renderer, :text => 4)
    tree.append_column col

    tree
  end

  def build_list(game_type)
    #List with headings Rank, Username, wins, Losses, Draws
    list_store = Gtk::ListStore.new(Integer, String, Integer, Integer, Integer)
    stats = @stats.select {|stat| stat.game_type == game_type}
    stats.sort! {|x, y| y.wins <=> x.wins}
    stats.each do |stat|
      row_item = list_store.append
      row_item[0] = (stats.index stat)+1
      row_item[1] = stat.player_name
      row_item[2] = stat.wins
      row_item[3] = stat.losses
      row_item[4] = stat.draws
    end
    list_store
  end

  def find_game_stat(game_type)
    @stats.each do |stat|
      return stat if stat.player_name == @player_name and stat.game_type == game_type
    end
  end
end
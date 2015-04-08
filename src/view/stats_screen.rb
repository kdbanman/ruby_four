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
  end

  def build_personal_tab(builder)
    c4_stat = find_c4_game_stat
    otto_stat = find_otto_game_stat

    builder.get_object('connect4_wins_label').set_text(c4_stat.wins.to_s)
    builder.get_object('connect4_losses_label').set_text(c4_stat.losses.to_s)
    builder.get_object('connect4_draws_label').set_text(c4_stat.draws.to_s)

    builder.get_object('otto_wins_label').set_text(otto_stat.wins.to_s)
    builder.get_object('otto_losses_label').set_text(otto_stat.losses.to_s)
    builder.get_object('otto_draws_label').set_text(otto_stat.draws.to_s)

  end

  def find_c4_game_stat
    @stats.each do |stat|
      if stat.player_name == @player_name and stat.game_type == :connect4
        return stat
      end
    end
  end

  def find_otto_game_stat
    @stats.each do |stat|
      if stat.player_name == @player_name and stat.game_type == :otto
        return stat
      end
    end
  end
end
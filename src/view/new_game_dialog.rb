require 'gtk2'

class NewGameDialog

  def initialize
    Gtk.init
    @builder = Gtk::Builder.new
    @builder.add_from_file('../resources/new_game_dialogue.glade')
    @mainWindow = @builder.get_object('main_window')
    set_up_game_type
    set_up_players
    set_up_difficulty
  end

  def start
    @mainWindow.show_all
    @mainWindow.signal_connect('destroy') { Gtk.main_quit }
    Gtk.main
  end

  private
  def set_up_game_type
    tootButton = @builder.get_object('toot_radio_button')
    c4Button = @builder.get_object('connect4_radio_button')

    c4Button.group = tootButton
  end

  def set_up_players
    zeroButton = @builder.get_object('players0_radio_button')
    oneButton = @builder.get_object('players1_radio_button')
    twoButton = @builder.get_object('players2_radio_button')

    oneButton.group =  zeroButton
    twoButton.group = zeroButton

    player2Name = @builder.get_object('player2_entry_box')
    player2Name.set_sensitive FALSE
  end

  def set_up_difficulty
    easyButton = @builder.get_object('computer_difficulty_easy')
    hardButton = @builder.get_object('computer_difficulty_hard')

    hardButton.group = easyButton
  end
end

h = NewGameDialog.new
h.start

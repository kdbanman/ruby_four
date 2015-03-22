require 'gtk2'

class NewGameDialog

  TOOT_RADIO_BUTTON = 'toot_radio_button'
  CONNECT4_RADIO_BUTTON = 'connect4_radio_button'

  PLAYERS0_RADIO_BUTTON = 'players0_radio_button'
  PLAYERS1_RADIO_BUTTON = 'players1_radio_button'
  PLAYERS2_RADIO_BUTTON = 'players2_radio_button'

  MAIN_WINDOW = 'main_window'

  def initialize
    Gtk.init
    @builder = Gtk::Builder.new
    @builder.add_from_file('../resources/new_game_dialogue.glade')
    @mainWindow = @builder.get_object(MAIN_WINDOW)
    set_up_game_type
    set_up_players
    set_up_difficulty
  end

  def start
    @mainWindow.show_all
    @mainWindow.signal_connect('destroy') { Gtk.main_quit }
    Gtk.main
  end

  def setup_ok_listener (&block)

  end

  def setup_cancel_listener(&block)

  end

  private
  def set_up_game_type
    tootButton = @builder.get_object(TOOT_RADIO_BUTTON)
    c4Button = @builder.get_object(CONNECT4_RADIO_BUTTON)

    c4Button.group = tootButton

    @gametype = :toot
    tootButton.group.each do |groupItem|
      groupItem.signal_connect('toggled') do |button|
        if button.active?
          #todo could be extracted into class if have time
          @gametype = :toot if button == tootButton
          @gametype = :connect4 if button == c4Button
        end
      end
    end
  end

  def set_up_players
    zeroButton = @builder.get_object(PLAYERS0_RADIO_BUTTON)
    oneButton = @builder.get_object(PLAYERS1_RADIO_BUTTON)
    twoButton = @builder.get_object(PLAYERS2_RADIO_BUTTON)

    oneButton.group =  zeroButton
    twoButton.group = zeroButton

    player2Name = @builder.get_object('player2_entry_box')
    player2Name.set_sensitive FALSE

    player1Name = @builder.get_object('player1_entry_box')
    player1Name.set_sensitive FALSE

    @player1 = :computer
    @player2 = :human
    zeroButton.group.each do |item|
      item.signal_connect('toggled') do |button|
        #todo could switch here
        if button.active?
          if button == zeroButton
            @player1 = :computer
            @player2 = :computer
            player2Name.set_sensitive FALSE
            player1Name.set_sensitive FALSE
          elsif button == oneButton
            @player1 = :human
            @player2 = :computer
            player1Name.set_sensitive TRUE
            player2Name.set_sensitive FALSE
          elsif button == twoButton
            @player1 = :human
            @player2 = :computer
            player1Name.set_sensitive TRUE
            player2Name.set_sensitive TRUE
          end
        end
      end
    end

  end

  def set_up_difficulty
    easyButton = @builder.get_object('computer_difficulty_easy')
    hardButton = @builder.get_object('computer_difficulty_hard')

    hardButton.group = easyButton
  end


end

h = NewGameDialog.new
h.start

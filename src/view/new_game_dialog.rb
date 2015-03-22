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
    connect_cancel_listener
  end

  def start
    @mainWindow.show_all
    @mainWindow.signal_connect('destroy') { kill }
    Gtk.main
  end

  def kill
    Gtk.main_quit
  end

  def setup_ok_listener (&block)
    @okListener = block
  end

  private

  def connect_cancel_listener
    cancel_button = @builder.get_object('cancel_button')
    cancel_button.signal_connect('released') do
      kill
    end
  end

  def connect_ok_listener
    ok_button = @builder.get_object('ok_button')
    ok_button.signal_connect('released') do
      ok_listener
    end
  end

  def ok_listener
    if validate_fields
      @okListener.call(get_fields)
      kill
    end
  end

  def get_fields

  end

  def validate_fields

  end

  def validate_name

  end

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
    @player2 = :computer
    zeroButton.group.each do |item|
      item.signal_connect('toggled') do |button|
        #todo should pll this up into anther class. This is trash.
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
    @difficulty = :easy
    easyButton.group.each do |item|
      item.signal_connect('toggled') do |button|
        if button.active?
          @difficulty = :easy if button == easyButton
          @difficulty = :hard if button == hardButton
        end
      end
    end
  end

end

h = NewGameDialog.new
h.start

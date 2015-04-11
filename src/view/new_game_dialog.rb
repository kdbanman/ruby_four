require_relative '../model/game_config.rb'
require_relative '../util/name_entry.rb'
require_relative '../util/size_entry.rb'
require_relative '../view/window'

require 'gtk2'

#TODO this file could use some major refactoring
class NewGameDialog
  include Window

  TOOT_RADIO_BUTTON = 'toot_radio_button'
  CONNECT4_RADIO_BUTTON = 'connect4_radio_button'

  PLAYERS0_RADIO_BUTTON = 'players0_radio_button'
  PLAYERS1_RADIO_BUTTON = 'players1_radio_button'
  PLAYERS2_RADIO_BUTTON = 'players2_radio_button'

  PLAYER1_ENTRY_BOX = 'player1_entry_box'
  PLAYER2_ENTRY_BOX = 'player2_entry_box'

  WIDTH_ENTRY_BOX = 'width_entry_box'
  HEIGHT_ENTRY_BOX = 'height_entry_box'

  OK_BUTTON = 'ok_button'
  CANCEL_BUTTON = 'cancel_button'

  COMPUTER_DIFFICULTY_EASY = 'computer_difficulty_easy'
  COMPUTER_DIFFICULTY_HARD = 'computer_difficulty_hard'


  MAIN_WINDOW = 'main_window'

  def initialize
    @builder = Gtk::Builder.new
    @builder.add_from_file(File.dirname(__FILE__) + '/../resources/new_game_dialogue.glade')
    @screen = @builder.get_object(MAIN_WINDOW)
    set_up_game_type
    set_up_players
    set_up_difficulty
    connect_cancel_listener
    connect_ok_listener
    get_fields
  end

  def start
    @screen.show_all

    #post
    CommonContracts.is_visible @screen
  end

  def kill
   @screen.destroy
  end

  def set_ok_listener (&block)
    CommonContracts.block_callable block
    @okListener = block
  end

  def set_on_destroy(&block)
    CommonContracts.block_callable block
    @screen.signal_connect('destroy') {block.call}
  end

  private

  def connect_cancel_listener
    cancel_button = @builder.get_object(CANCEL_BUTTON)
    cancel_button.signal_connect('released') do
      kill
    end
  end

  def connect_ok_listener
    ok_button = @builder.get_object(OK_BUTTON)
    ok_button.signal_connect('released') {ok_listener}
  end

  def ok_listener
    @okListener.call(get_config) if validate_fields
  end

  def get_fields
    @player1_name = NameEntry.new @builder.get_object(PLAYER1_ENTRY_BOX), PLAYER1_ENTRY_BOX
    @player2_name = NameEntry.new @builder.get_object(PLAYER2_ENTRY_BOX), PLAYER2_ENTRY_BOX

    @width = SizeEntry.new @builder.get_object(WIDTH_ENTRY_BOX), WIDTH_ENTRY_BOX
    @height = SizeEntry.new @builder.get_object(HEIGHT_ENTRY_BOX), HEIGHT_ENTRY_BOX
  end

  def get_config
    GameConfig.new(@gametype, @player1, @player2, @player1_name.text,
                   @player2_name.text, @difficulty, @width.value, @height.value)
  end

  def validate_fields
    if @player1 == :human
      return FALSE unless @player1_name.valid?
    end

    if @player2 == :human
      return FALSE unless @player2_name.valid?
    end

    return @width.valid? && @height.valid?
  end

  def set_up_game_type
    tootButton = @builder.get_object(TOOT_RADIO_BUTTON)
    c4Button = @builder.get_object(CONNECT4_RADIO_BUTTON)

    c4Button.group = tootButton

    @gametype = :otto
    tootButton.group.each do |groupItem|
      groupItem.signal_connect('toggled') do |button|
        if button.active?
          #todo could be extracted into class if have time
          @gametype = :otto if button == tootButton
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

    player2Name = @builder.get_object(PLAYER2_ENTRY_BOX)
    player2Name.set_sensitive FALSE

    player1Name = @builder.get_object(PLAYER1_ENTRY_BOX)
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
            @player2 = :human
            player1Name.set_sensitive TRUE
            player2Name.set_sensitive TRUE
          end
        end
      end
    end

  end

  def set_up_difficulty
    easyButton = @builder.get_object(COMPUTER_DIFFICULTY_EASY)
    hardButton = @builder.get_object(COMPUTER_DIFFICULTY_HARD)

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

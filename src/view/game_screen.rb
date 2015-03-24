require_relative '../resources/column_view.rb'
require_relative './game_screen_contracts.rb'
require_relative './game_board'
require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'
require_relative './/token_selector.rb'
require_relative '../view/new_game_dialog.rb'
require_relative '../resources/about_screen.rb'
require 'gtk2'

class GameScreen
  attr_reader :gameBoard

	include GameScreenContracts
	include GameBoardContracts

	public
  # @param [GameType] gametype
  # @param [DataSource] datasource
  # @param [GameConfig] gameconfig
	def initialize(gametype, datasource, gameconfig)
		#pre
    Gtk.init
    datasource.add_observer(self)
    @builder = Gtk::Builder.new
    @builder.add_from_file(File.dirname(__FILE__) + '/../resources/game_screen.glade')
    @screen = @builder.get_object('game_screen')
    @boardContainer = @builder.get_object('board_container')
    @mainLayout = @builder.get_object('main_layout')
    @gameBoard = GameBoard.new(gametype,gameconfig.num_cols, gameconfig.num_rows)
    @boardContainer.add(@gameBoard.boardView)
    @playerTurnLabel = @builder.get_object('player_name_label')
    @screen.show_all()
    set_up_game_board_events
    set_about_handler
    #@okay_pressed = false
    update(datasource.board)
	end

	def start
    verify_column_selected @columnSelectedListener
    verify_game_closed_listener @closeListener
    #TODO leave in for part 5
    #verify_new_game_listener @newGameListener
    Gtk.main()
  end

  def kill
    @closeListener.call
    puts 'RETURNED FROM CLOSE LISTENER'
    Gtk.main_quit #unless @okay_pressed
    puts 'killed game_screen loop'
  end

	def set_column_selected_listener(&block)
		CommonContracts.block_callable(block)
    @columnSelectedListener = block
    @gameBoard.set_column_click_listener &block
	end

	def set_close_listener(&block)
		CommonContracts.block_callable(block)
    @quitButton = @builder.get_object('quit_menu_item')
    @closeListener = block

    closeWindow = Proc.new do
      kill
    end

    @screen.signal_connect('destroy') do
      closeWindow.call
    end

    @quitButton.signal_connect('activate') do
      closeWindow.call
    end
	end

  # @param [Datasource] datasource
	def update(board)
		#input_is_data_source(datasource)
    #TODO iterate over ds and draw tokens
    @gameBoard.update board
    playerID = board.current_player_id
    player = board.player1 if (board.player1.id == playerID)
    player = board.player2 if (board.player2.id == playerID)
    
    raiseDialog("Winner: #{board.winner.name}") if board.winner
    raiseDialog('No Winner.') if board.full?

    @playerTurnLabel.set_text(player.name)
  end

  def raiseDialog(message)
    dialog = Gtk::MessageDialog.new(nil, Gtk::Dialog::DESTROY_WITH_PARENT, 
      Gtk::MessageDialog::INFO, Gtk::MessageDialog::BUTTONS_OK, message)
    dialog.run
    dialog.destroy
    kill
  end

  def set_new_game_listener

  end

  private

  def set_up_game_board_events
    @gameBoard.connect_event_handlers
  end

  def set_about_handler
    @aboutButton = @builder.get_object('about_menu_button')
    @aboutButton.signal_connect('activate') do
      AboutScreen.new('Rules: \n')
    end
  end

  def add_token_selector
    tokenSelector = TokenSelector.new(0, 30, 'Select Token:')
    @mainLayout.put(tokenSelector.topView, tokenSelector.posX, tokenSelector.posY)
  end
end


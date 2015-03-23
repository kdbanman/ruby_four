require_relative '../resources/column_view.rb'
require_relative './game_screen_contracts.rb'
require_relative './game_board'
require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'
require_relative './/token_selector.rb'
require_relative '../view/new_game_dialog.rb'
require 'gtk2'

class GameScreen
  attr_reader :gameBoard

	include GameScreenContracts
	include GameBoardContracts

	public
  # @param [GameType] gametype
  # @param [DataSource] datasource
	def initialize(gametype, datasource)
		#pre
    #todo uncomment after connecting with backend
		# game_type_generates_tokens(gametype)
		# data_source_observable(datasource)
		# input_is_data_source(datasource)
    #TODO add self to datasource observers
    Gtk.init
    @builder = Gtk::Builder.new
    @builder.add_from_file('../resources/game_screen.glade')
    @screen = @builder.get_object('game_screen')
    @boardContainer = @builder.get_object('board_container')
    @mainLayout = @builder.get_object('main_layout')
    #TODO CHANGE THIS TO USE GAMETYPE
    @gameBoard = GameBoard.new(nil,15,15)
    @boardContainer.add(@gameBoard.boardView)
    #todo if gametype == :toot add_token_selector
    add_token_selector
    @screen.show_all()
    set_up_game_board_events
	end

	def start
    verify_column_selected @columnSelectedListener
    verify_game_closed_listener @closeListener
    verify_new_game_listener @newGameListener
    Gtk.main()
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
      @closeListener.call
      Gtk.main_quit
    end

    @screen.signal_connect('destroy') do
      closeWindow.call
    end

    @quitButton.signal_connect('activate') do
      closeWindow.call
    end
	end

	def set_new_game_listener(&block)
		CommonContracts.block_callable(block)
    @newGameButton = @builder.get_object('new_game_menu_item')
    @newGameListener = block
    @newGameButton.signal_connect('activate') do
      unless NewGameDialog.opened
        newGameDialog = NewGameDialog.new(@screen)
        newGameDialog.setup_ok_listener &block
        newGameDialog.start
      end
    end
	end

  # @param [Datasource] datasource
	def update(datasource)
		input_is_data_source(datasource)
    #TODO iterate over ds and draw tokens
  end

  private

  def set_up_game_board_events
    @gameBoard.connect_event_handlers
  end

  def add_token_selector
    tokenSelector = TokenSelector.new(0, 30, 'Select Token:')
    @mainLayout.put(tokenSelector.topView, tokenSelector.posX, tokenSelector.posY)
  end

end

h = GameScreen.new(1,2)
h.set_column_selected_listener {|col| puts "column click listener: clicked in col: #{col}"}
h.set_close_listener {puts 'game closed listener called'}
h.set_new_game_listener {puts 'NEW GAME'}
h.start

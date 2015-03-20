require_relative '../resources/column_view.rb'
require_relative './game_screen_contracts.rb'
require_relative './game_board'
require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'
require 'gtk2'

class GameScreen
  attr_reader :gameBoard

	include GameScreenContracts
	include GameBoardContracts

	public 
	def initialize(gametype, datasource)
		#pre
		# game_type_generates_tokens(gametype)
		# data_source_observable(datasource)
		# input_is_data_source(datasource)

    Gtk.init
    @builder = Gtk::Builder.new
    @builder.add_from_file('../resources/game_screen.glade')
    @screen = @builder.get_object('game_screen')
    @boardContainer = @builder.get_object('board_container')
    #TODO CHANGE THIS TO USE GAMETYPE
    @gameBoard = GameBoard.new(nil,15,15)
    @boardContainer.add(@gameBoard.boardView)
    @screen.show_all()
    Gtk.main()
    @screen.resize()

	end

	def setup
	end

	def set_column_selected_listener(&block)
		CommonContracts.block_callable(block)
	end

	def set_close_listener(&block)
		CommonContracts.block_callable(block)
	end

	def set_new_game_listener(&block)
		CommonContracts.block_callable(block)
	end

	def update(datasource)
		input_is_data_source(datasource)
	end
end

h = GameScreen.new(1,2)

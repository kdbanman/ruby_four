require_relative './game_screen_contracts.rb'
require './game_board_contracts.rb'
require '../util/common_contracts.rb'

class GameScreen
  attr_reader :gameBoard

	include GameScreenContracts
	include GameBoardContracts

	public 
	def initialize(gametype, datasource)
		#pre
		game_type_generates_tokens(gametype)
		data_source_observable(datasource)
		input_is_data_source(datasource)
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
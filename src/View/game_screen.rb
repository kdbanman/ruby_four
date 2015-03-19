require_relative './game_screen_contracts.rb'
require './game_board_contracts.rb'
require '../util/common_contracts.rb'
require '../util/common_contracts.rb'

class GameScreen

	include GameScreenContracts
	include GameBoardContracts

	private 
	@gameboard

	public 
	def initialize(gametype, datasource)
		#pre
		gameTypeGneratesTokens(gametype)
		datasource_observable(datasource)
		input_is_datasource(datasource)
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
		input_is_datasource(datasource)
	end
end
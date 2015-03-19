require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'

class GameBoard
	
	include GameBoard_Contracts

	private
	@columnClickListener
	@columns
	@@gametype

	public
	def initialize(gametype, size)
		gameTypeGneratesTokens(gametype)
	end

	def set_column_click_listener(&block)
		CommonContracts.block_callable(block)
	end

	private
	def setup
	end

	def draw_token(coordinate)
		CommonContracts.valid_coordinate(coordinate, @columns.size, @columns[0].size)
	end

	def draw_ghost(coordinate)
		CommonContracts.valid_coordinate(coordinate, @columns.size, @columns[0].size)
	end
	
	def column_hover_action
	end

	def handle_column_click
	end

	def handle_column_hover
	end

end
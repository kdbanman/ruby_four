require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'

class GameBoard

  attr_reader :columnClickListener
  attr_reader :columns
  attr_reader :gameType

	include GameBoardContracts

	public
	def initialize(gametype, size)
		game_type_generates_tokens(gametype)
	end

	def set_column_click_listener(&block)
		CommonContracts.block_callable(block)
	end

	private
	def setup
	end

	def draw_token(coordinate)
		CommonContracts.valid_coordinate(coordinate)
	end

	def draw_ghost(coordinate)
		CommonContracts.valid_coordinate(coordinate)
	end
	
	def column_hover_action
	end

	def handle_column_click
	end

	def handle_column_hover
	end

end
require_relative '../util/common_contracts.rb'
require_relative './column_contracts.rb'

class Column
	include ColumnContracts
  attr_reader :slots
  attr_reader :size

	def initialize(size)
	end

	def draw_token(coordinate)
		#pre
		valid_coordinate(coordinate, @size)

		#post
		slot_is_filled(@slots[coordinate.y])
	end

	def draw_ghost(coordinate)
		valid_coordinate(coordinate, @size)
	end

	def set_hover_listener(&block)
		CommonContracts.block_callable(block)
	end
end
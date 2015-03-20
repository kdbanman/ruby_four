require_relative '../util/common_contracts.rb'
require_relative '../resources/column_view.rb'
require_relative './column_contracts.rb'

class Column
	include ColumnContracts
  attr_reader :slots
  attr_reader :size
  attr_reader :colView

	def initialize(size)
    @slots = []
    size.times {slots << Slot.new}
    @colView = ColumnView.new(@slots.collect {|x| x.slotView})
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
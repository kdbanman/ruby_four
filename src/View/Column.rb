require './util/common_contracts.rb'
require './View/Column_Contracts.rb'

class Column
	include Column_Contracts

	private
	@size
	@slots

	public
	def initialize(size)
	end

	def drawToken(coordinate)
		#pre
		valid_coordinate(coordinate, @size)

		#post
		slot_is_filled(@slots[coordinate.y])
	end

	def drawGhost(coordinate)
		valid_coordinate(coordinate, @size)
	end

	def setHoverListener(&block)
		CommonContracts.block_callable(block)
	end
end
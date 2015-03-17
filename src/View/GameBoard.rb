require './View/GameBoard_Contracts.rb'
require './util/common_contracts.rb'

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

	def setColumnClickListener(&block)
		CommonContracts.block_callable(block)
	end

	private
	def setup
	end

	def drawToken(coordinate)
		CommonContracts.valid_coordinate(coordinate, @columns.size, @columns[0].size)
	end

	def drawGhost(coordinate)
		CommonContracts.valid_coordinate(coordinate, @columns.size, @columns[0].size)
	end
	
	def columnHoverAction
	end

	def handleColumnClick
	end

	def handleColumnHover
	end

end
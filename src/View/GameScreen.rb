require './View/GameScreen_Contracts.rb'
require './util/common_contracts.rb'
require './View/GameBoard_Contracts.rb'
require './util/common_contracts.rb'

class GameScreen

	include GameScreen_Contracts
	include GameBoard_Contracts

	private 
	@gameboard

	public 
	def initialize(gametype, datasource)
		#pre
		gameTypeGneratesTokens(gametype)
		datasource_observable(datasource)
	end

	def setup
	end

	def setColumnSelectedListener(&block)
		CommonContracts.block_callable(block)
	end

	def setCloseListener(&block)
		CommonContracts.block_callable(block)
	end

	def setNewGameListener(&block)
		CommonContracts.block_callable(block)
	end
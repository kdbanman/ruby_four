require './util/common_contracts.rb'

class GameMenu

	def initialize
	end

	def display
	end

	def addListener(&block)
		CommonContracts.block_callable
	end

end
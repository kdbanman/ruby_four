require_relative '../util/common_contracts.rb'

class GameMenu

	def initialize
	end

	def display
	end

	def add_listener(&block)
		CommonContracts.block_callable(block)
	end

end
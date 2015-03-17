require './util/common_contracts.rb'
require './View/Slot_Contracts.rb'

class Slot

	include Slot_contracts

	private
	@filled

	public

	def initialize
	end

	def fill
		#post
		filled?(filled)
	end

	def draw
	end

	def isFilled
	end

end
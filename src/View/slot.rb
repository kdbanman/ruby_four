require_relative '../util/common_contracts.rb'
require_relative './slot_contracts.rb'

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

	def is_filled
	end

end
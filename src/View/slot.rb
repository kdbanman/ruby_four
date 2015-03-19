require_relative '../util/common_contracts.rb'
require_relative './slot_contracts.rb'

class Slot
  attr_accessor :filled
	include SlotContracts


	public

	def initialize
	end

	def fill
		#post
		filled?(@filled)
	end

	def draw
	end

	def is_filled?
	end

end
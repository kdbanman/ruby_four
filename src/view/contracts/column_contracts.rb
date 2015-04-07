require_relative '../../util/contracted.rb'

module ColumnContracts
	def valid_coordinate(coordinate, col_size)
		raise ContractFailure, "invalid column coord" unless coordinate.y <= col_size && coordinate.y >= 0 
	end

	def slot_is_filled(slot)
		raise ContractFailure, "Slot should have been filled by draw opperation" unless slot.is_filled?
	end
end
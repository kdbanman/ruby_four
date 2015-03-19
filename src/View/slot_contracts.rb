require_relative '../util/contracted.rb'

module SlotContracts
	def filled?(slot)
		raise ContractFailure, "slot did not get filled" unless slot
	end
end
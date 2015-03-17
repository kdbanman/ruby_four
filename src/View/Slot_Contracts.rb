include './util/contracted.rb'

module Slot_Contracts
	def filled?(slot)
		raise ContractFailure, "slot did not get filled" unless slot
	end
end
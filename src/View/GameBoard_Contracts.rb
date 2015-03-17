include './util/contracted.rb'

module GameBoard_Contracts
	def gameTypeGneratesTokens(gametype)
		raise ContractFailure, "GameType can't generate tokens" unless gametype.respoonds_to? :new_token
	end

end
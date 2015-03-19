require_relative '../util/contracted.rb'

module GameBoardContracts
	def game_type_gnerates_tokens(gametype)
		raise ContractFailure, "GameType can't generate tokens" unless gametype.respond_to? :new_token
	end

end
require_relative '../../util/contracted.rb'

module GameBoardContracts

	def game_type_generates_tokens(gametype)
		raise ContractFailure, 'GameType can\'t generate tokens' unless gametype.respond_to? :new_token
  end

  def listener_not_nil(listener)
    raise ContractFailure, 'click listener must be set up' unless listener
  end

end
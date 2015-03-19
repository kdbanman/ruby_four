require_relative '../util/contracted'
require_relative '../util/common_contracts'
require_relative './token.rb'

module GameTypeContracts
	def is_a_token(*input)
		raise ContractFailure, "Must be a token" unless input.all? {|i| i.is_a?Token}
	end
end
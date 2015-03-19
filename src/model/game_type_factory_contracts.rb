require_relative '../util/contracted'
require_relative '../util/common_contracts'
require_relative './game_type.rb'

module GameTypeFactoryContracts
  def verify_type(gametype)
    unless gametype.is_a? GameType
      raise ContractFailure 'must pass a gametype'
    end
  end
end
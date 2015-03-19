require_relative './game_type_contracts'
require_relative '../util/common_contracts'

module GameType

  include GameTypeContracts

  public

  def GameType.new_token
  	
    #postconditions
    isAToken(out)
  end

  def GameType.win_condition(tokenList)
    CommonContracts.array(tokenList)
    isAToken(tokenList)
  end
end
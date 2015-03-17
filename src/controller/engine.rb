require './util/common_contracts.rb'

class Engine

  private

  @game_type
  @data_source

  public

  def initialize

  end

  def new_token_command(coordinate)
  	CommonContracts.valid_coordinate(coordinate)
  end

  def setupColumnClickListener
  end

  def setupNewGameListener
  end

  def setupCloseListener
  end

end
require './util/common_contracts'
require "./model/place_token_command_contracts.rb"

class PlaceTokenCommand
  private

  include PlaceTokenCommandContracts

  @coordinate

  public

  def initialize(coordinate)
    CommonContracts.valid_coordinate(coordinate)
  end

  def run(datasource)
    input_is_datasource(datasource)
  end

end
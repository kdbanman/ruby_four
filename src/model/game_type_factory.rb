require_relative '../util/common_contracts'
require_relative '../model/game_type_factory_contracts'
require_relative '../model/connect_game_type'
require_relative '../model/otto_game_type'
require_relative '../model/game_config'

module GameTypeFactory

  include GameTypeFactoryContracts

  # @param [GameConfig] config
  # @return [GameType]
  def GameTypeFactory.get_game_type(config)
    return ConnectGameType if config.type == "connect4"
    return OttoGameType if config.type == "otto"

    puts "Invalid game type passed: #{config}"
    nil
  end

end
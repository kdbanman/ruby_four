require_relative '../model/game_type_contracts'

module GameType

  include GameTypeContracts

  EXIT_PATTERN = /exit (\d)/

  def GameType.get_exiter(message)
    message[EXIT_PATTERN, 1].to_i
  end

  # TODO win condition helpers
end
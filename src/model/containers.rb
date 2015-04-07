require_relative '../util/common_contracts'

class SavedGame
  attr_reader :player_1_name, :player_2_name, :game_id

  def initialize(player1, player2, game_id)
    CommonContracts.strings player1, player2
    CommonContracts.integers game_id
    @player_1_name = player1
    @player_2_name = player2
    @game_id = game_id
  end

end

class GameStat
  attr_reader :game_type :player_name, :wins, :draws, :losses

  def initialize(game_type, player, wins, draws, losses)
    CommonContracts.strings player
    CommonContracts.integers wins, draws, losses
    CommonContracts.verify_type game_type
    @game_type = game_type
    @player_name = player
    @wins = wins
    @draws = draws
    @losses = losses
  end
end
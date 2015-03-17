require_relative '../model/game_config_contracts'

class GameConfig

  include GameConfigContracts

  attr_reader :type, :player1, :player2, :difficulty

  public

  def initialize(type, player1, player2, difficulty)
    @type = type
    @player1 = player1
    @player2 = player2
    @difficulty = difficulty

    verify_invariants
  end

  private

  def verify_invariants
    verify_type type
    verify_player player1
    verify_player player2
    verify_difficulty difficulty
  end

end
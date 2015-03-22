require_relative '../model/game_config_contracts'

# Object for game initialization.  Produced before any game model.
# Used to create game type and game model.
class GameConfig

  include GameConfigContracts

  attr_reader :type, :player1, :player2, :name1, :name2, :difficulty, :num_cols, :num_rows

  public

  def initialize(type, player1, player2, name1, name2, difficulty, cols, rows)
    @type = type
    @player1 = player1
    @player2 = player2
    @name1 = name1
    @name2 = name2
    @difficulty = difficulty

    @num_cols = cols
    @num_rows = rows

    verify_invariants
  end

  private

  def verify_invariants
    verify_type type
    verify_player player1
    verify_player player2
    verify_name name1
    verify_name name2
    verify_difficulty difficulty
  end

end

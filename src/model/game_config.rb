require_relative '../model/game_config_contracts'

# Object for game initialization.  Produced before any game model.
# Used to create game type and game model.
class GameConfig

  include GameConfigContracts

  attr_accessor :port
  attr_reader :type, :player1, :player2, :name1, :name2, :difficulty, :num_cols, :num_rows, :ip

  public

  def initialize(type, player1, player2, name1, name2, difficulty, cols, rows, port = 1024 + Random.rand(60000), ip = 'localhost')
    @type = type
    @player1 = player1
    @player2 = player2
    @name1 = name1
    @name2 = name2
    @difficulty = difficulty

    @num_cols = cols
    @num_rows = rows

    @port = port
    @ip = ip

    verify_invariants
  end

  def is_incomplete
    name1.nil? || name2.nil?
  end

  def is_complete
    !is_complete
  end

  private

  def verify_invariants
    verify_type type
    verify_player player1
    verify_player player2
    verify_name name1 unless name1.nil?
    verify_name name2 unless name2.nil?
    verify_difficulty difficulty
  end

end

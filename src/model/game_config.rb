require_relative '../model/game_config_contracts'
require 'xmlrpc/marshal'

# Object for game initialization.  Produced before any game model.
# Used to create game type and game model.

# For a game with a remote player, the player creating the game should be able to choose whether to be player
# 1 or player 2 (the win conditions are different for OTTO, so the choice is meaningful).
#
# A player creating a game already has a known name (the username they logged in with), they should not
# be able to change that in the new game screen.  If they want to play a local human vs human game, they
# should be able to give that player a name.
#
# As far as the GameConfig object is concerned, Symbols GameConfig.player1 and GameConfig.player2
# can be :human, :computer, *or :remote*.  A `nil` GameConfig.name1 or GameConfig.name2 means that
# the remote player is not yet joined.  That's how the UI should create the GameConfig object, but
# the GameScreen, DataSource, and Engine will always *receive* a completed GameConfig object.  For
# the creating player, the :remote player's name will be set accordingly.  For the joining player,
# the creating player will appear as the :remote player.

# EXAMPLE LIFECYCLE:
#
# On client, player logged into server 192.168.1.42 creates otto game (as player 1, necessarily) with remote player 2
#   config.type == :otto                # Won't change on any client
#   config.player1 == :player           # Won't change on this client, will be :remote for joining client
#   config.player2 == :remote           # Won't change on this client, will be :player for joining client
#   config.name1 == 'billy'             # Won't change on any client
#   config.name2 == nil                 # Won't change on any client
#   config.difficulty == <don't care>   # Won't change on any client
#   config.num_cols == 8                # Won't change on any client
#   config.num_rows == 8                # Won't change on any client
#   config.ip == '192.168.1.42'         # Won't change on any client
#
# Engine game creation callback is called with above config, Engine uses it to create
# GameType, DataSource, UI.  Only DataSource and UI care about changing player name.
#
# DataSource calls MasterServer.create_game(config, username)
#


class GameConfig

  include GameConfigContracts
  include XMLRPC::Marshallable

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

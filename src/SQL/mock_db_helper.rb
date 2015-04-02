
require_relative '../util/common_contracts'
require_relative '../model/game_stats'
class MockDbHelper

  @stats
  @users

  def initialize
    @stats = GameStats.new
    @users = Hash.new  # {<int_id>: { name: <str_name>, pass: <str_passwd>, id: <int_id>, saved_games: [<int_id>, ...] } }
    @games = Hash.new  # {<int_id>: <marshal_string>}
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_win(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    username = @users[player_id][:name]
    @stats.increment_stat username, game_type, :wins
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_loss(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    username = @users[player_id][:name]
    @stats.increment_stat username, game_type, :losses
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_draw(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    username = @users[player_id][:name]
    @stats.increment_stat username, game_type, :draws
  end

  # @param [String] data
  # @param [Integer] player1
  # @param [Integer] player2
  def add_saved_game(data, player1, player2)
    #pre
    CommonContracts.integers player1, player2
    CommonContracts.strings data

    #TODO shouldn't saved games have an id?
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] playerID
  def add_user(username, password)
    #pre
    CommonContracts.strings username, password
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] userID
  def get_user(username, password)
    #pre
    CommonContracts.strings username, password
  end

  # @param [String] username
  # @return [Boolean] exists
  def user_exists(username)
    #pre
    CommonContracts.strings username
  end

  # @param [Integer] id
  def get_saved_game(id)
    #pre
    CommonContracts.integers id
  end

  # @param [Integer] id
  # @param [Symbol] game_type either :connect4 or :otto
  # @return [Array] all stats
  def get_player_stats(id, game_type)
    #pre
    CommonContracts.integers id
    CommonContracts.verify_type game_type

  end

end
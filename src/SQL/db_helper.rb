require 'mysql'
require_relative '../util/common_contracts'
class DbHelper
  @conn

  def initialize

  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_win(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    #TODO game type!
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_loss(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    #TODO game type!
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_draw(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    #TODO game type!
  end

  # @param [String] data
  # @param [Integer] player1
  # @param [Integer] player2
  def add_saved_game(data, player1, player2)
    #pre
    CommonContracts.integers player1, player2
    CommonContracts.strings data
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
  # @return [Integer] userID  or nil if not found
  def get_user_id(username, password)
    #pre
    CommonContracts.strings username, password
  end

  # @param [Integer] id
  # @return [String] the users name, or nil if not found
  def get_user_name(id)
    #pre
    CommonContracts.integers id
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
  # @return [Array] all stats [<wins>, <lossses>, <draws>]
  def get_player_stats(id, game_type)
    #pre
    CommonContracts.integers id
    CommonContracts.verify_type game_type

    #TODO game_type!

    #return [<wins>, <lossses>, <draws>]
  end

  # @return [GameStats] all wins, losses, and draws for all players for both game types
  def get_all_stats

    # TODO ryan there is a GameStats object.  it has a method that should be good for adding row by row:
    # @param [String] username
    # @param [Symbol] gametype either :connect4 or :otto
    # @param [Integer] wins the total number of wins for the passed gametype, user
    # @param [Integer] losses the total number of losses for the passed gametype, user
    # @param [Integer] draws the total number of draws for the passed gametype, user
    #   def add_stat_row(username, gametype, wins, losses, draws)
    #
    # EX:  stats = GameStats.new
    #      stats.add_stat('bill',  :otto,     0, 17, 1)
    #      stats.add_stat('bill',  :connect4, 1, 93, 3)  # bill sucks
    #      stats.add_stat('steve', :otto,     9,  0, 0)

  end

  # @param [Integer] id
  def update_saved_game(id, data)
    #pre
    CommonContracts.integers id
  end

  # @param [Integer] id
  def delete_saved_game(id)
    #pre
    CommonContracts.integers id
  end

  private
  def get_connection
    begin
      @conn = Mysql.new('mysqlsrv.ece.ualberta.ca', 'ece421usr2', 'a421Psn101', 'ece421grp2', '13020')
    rescue Mysql::Error
      raise ContractFailure 'Could not connect to DataBase'
    end
  end

  def close_connection
    @conn.close if @conn
  end

end

module DBConstants

  USERS = 'Users'
  GAME_STATS = 'GameStats'
  SAVED_GAMES = 'SavedGames'
  USERNAME = 'admin'
  PASSWORD = 'admin'

end
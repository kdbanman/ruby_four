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

    #TODO game_type
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
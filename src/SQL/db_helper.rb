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

    runQuery build_game_stats_query(player_id, 'Wins', game_type)
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_loss(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    runQuery build_game_stats_query(player_id, 'Losses', game_type)
  end

  # @param [Integer] player_id
  # @param [Symbol] game_type either :connect4 or :otto
  def add_draw(player_id, game_type)
    #pre
    CommonContracts.integers player_id
    CommonContracts.verify_type game_type

    runQuery build_game_stats_query(player_id, 'Draws', game_type)
  end

  # @param [String] data
  # @param [Integer] player1
  # @param [Integer] player2
  # @param [String] id
  def add_saved_game(id, data, player1, player2)
    #pre
    CommonContracts.integers player1, player2
    CommonContracts.strings data
    runQuery "INSERT INTO #{DBConstants::SAVED_GAMES}(Game_id, Player1, Player2, data) VALUES('#{id}', #{player1}, #{player2}, '#{data}')"
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] playerID
  def add_user(username, password)
    #pre
    CommonContracts.strings username, password
    runQuery "INSERT INTO #{DBConstants::USERS}(Username, Password) VALUES('#{username}', '#{password}')"
    get_user_id(username, password)
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] userID  or nil if not found
  def get_user_id(username, password)
    #pre
    CommonContracts.strings username, password
    runQuery("SELECT Id FROM #{DBConstants::USERS} WHERE Username = '#{username}' AND Password = '#{password}'").each_hash &(Proc.new {|row| return row['Id'].to_i})
  end

  # @param [Integer] id
  # @return [String] the users name, or nil if not found
  def get_user_name(id)
    #pre
    CommonContracts.integers id
    runQuery("SELECT Username FROM #{DBConstants::USERS} WHERE Id = #{id}").each_hash &(Proc.new {|res| return res['Username']})
  end

  # @param [String] username
  # @return [Boolean] exists
  def user_exists(username)
    #pre
    CommonContracts.strings username
    out = Proc.new {}
    runQuery("SELECT * FROM #{DBConstants::USERS} WHERE Username = '#{username}'").each_hash &(Proc.new { |user| return true})
    return false
  end

  # @param [String] id
  def get_saved_game(id)
    #pre
    CommonContracts.strings id
    runQuery("SELECT data FROM #{DBConstants::SAVED_GAMES} WHERE Game_id = '#{id}'").each_hash &(Proc.new {|row| return row['data']})
  end

  # @param [Integer] id
  # @param [Symbol] game_type either :connect4 or :otto
  # @return [Array] all stats [<wins>, <lossses>, <draws>]
  def get_player_stats(id, game_type)
    #pre
    CommonContracts.integers id
    CommonContracts.verify_type game_type

    #TODO game_type!
    runQuery("SELECT Wins, Losses, Draws FROM #{DBConstants::GAME_STATS} WHERE Game_type = '#{game_type.to_s}' AND Id = #{id}").each_hash &(Proc.new {|row| return [row['Wins'].to_i, row['Losses'].to_i, row['Draws'].to_i]})
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
    users = {}
    runQuery("SELECT Id, Username FROM #{DBConstants::USERS}").each_hash { |row| users[row['Id']] = row['Username']}

    stats = GameStats.new
    runQuery("SELECT * FROM #{DBConstants::GAME_STATS}").each_hash { |row| stats.add_stat_row(users[row['Id']], row['Game_type'].to_sym, row['Wins'].to_i, row['Losses'].to_i, row['Draws'].to_i)}
    return stats
  end

  # @param [String] id
  def update_saved_game(id, data)
    #pre
    CommonContracts.strings id
    runQuery "UPDATE #{DBConstants::SAVED_GAMES} SET data='#{data}' WHERE Game_id = '#{id}'"
  end

  # @param [String] id
  def delete_saved_game(id)
    #pre
    CommonContracts.strings id
    runQuery "DELETE FROM #{DBConstants::SAVED_GAMES} WHERE Game_id = '#{id}'"
  end

  def delete_user(id)
    CommonContracts.integers id
    runQuery "DELETE FROM #{DBConstants::USERS} WHERE Id = #{id}"
  end

  private
  def get_connection
    begin
      @conn = Mysql.new('mysqlsrv.ece.ualberta.ca', 'ece421usr2', 'a421Psn101', 'ece421grp2', 13020)
    rescue Mysql::Error
      raise ContractFailure 'Could not connect to DataBase'
    end
  end

  def close_connection
    @conn.close if @conn
  end

  def runQuery(query)
    begin
      get_connection
      return @conn.query query
    rescue Mysql::Error => e
      puts "ERROR: Query *#{query}* did not complete for reason: #{e.error}"
      raise "Query *#{query}* did not complete for reason: #{e.error}"
    ensure
      close_connection
    end
  end

  def build_game_stats_query(id, field, game_type)
    "INSERT INTO #{DBConstants::GAME_STATS}(Id, Game_type, #{field}) VALUES(#{id},'#{game_type.to_s}' ,1) ON DUPLICATE KEY " +
        "UPDATE #{field}=#{field} + 1"
  end

end

module DBConstants

  USERS = 'Users'
  GAME_STATS = 'GameStats'
  SAVED_GAMES = 'SavedGames'
  USERNAME = 'admin'
  PASSWORD = 'admin'

end
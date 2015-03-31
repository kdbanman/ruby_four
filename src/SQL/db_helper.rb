require 'mysql'
require_relative '../util/common_contracts'
class DbHelper
  @conn

  def initialize

  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] userID
  def get_user(username, password)
    #pre
    CommonContracts.strings username, password
  end

  # @param [Integer] id
  def get_saved_game(id)
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

  Users = 'Users'
  GameStats = 'GameStats'
  SavedGames = 'SavedGames'
  Username = 'admin'
  Password = 'admin'

end
require_relative '../SQL/db_helper'
require_relative '../model/containers'

class MasterDataSource

  attr_reader :username

  @db_Helper
  @master_server
  @observers

  @user_id

  def initialize (master_server)
    @db_Helper = DbHelper.new
    @master_server = master_server

    @observers = []
  end

  # @param [String] username
  # @param [String] password
  # @return [bool]
  def login(username, password)
    db_operation('Could not login') do
      @user_id = @db_Helper.get_user_id(username, password)
      @username = username
      return true if @user_id
      return false
    end
  end

  def open_games
    make_server_communication('couldnt get open games') {Marshal.load(@master_server.get_waiting_games())}
  end

  def saved_games()
    make_server_communication('Could not get saved games') {@master_server.get_saved_games}
  end

  def start_saved_game(id)
    make_server_communication('Could not start saved game') {@master_server.start_saved_game(id)}
  end

  def get_stats()
    db_operation('Could not get stats') do
      game_stats = @db_Helper.get_all_stats
      out = game_stats.each_stat.collect {|username, gametype, outcome| GameStat.new(gametype, username, outcome[0], outcome[2], outcome[1])}
    end
  end

  def add_observer(obs)
    @observers << obs
  end

  private
  def update_observers
    @observers.each {|observer| observer.update}
  end

  def make_server_communication(msg, &block)
    begin
      block.call
    rescue Errno::ECONNREFUSED => e
      puts "ERROR: #{msg} : #{e.error}"
    end
  end

  def db_operation(msg)
    begin
      yield
    rescue RuntimeError => e
      puts "Error: #{msg} : #{e.error}"
    end
  end


end
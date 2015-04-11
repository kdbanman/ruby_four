require_relative '../SQL/db_helper'
require_relative '../model/containers'

class MasterDataSource
  @db_Helper
  @master_server
  @observers

  @user_id
  @username

  def initialize (master_server)
    @db_Helper = DbHelper.new
    @master_server = master_server

    @observers = []
  end

  # @param [String] username
  # @param [String] password
  # @return [bool]
  def login(username, password)
    begin
      @user_id = @db_Helper.get_user_id(username, password)
      @username = username
      return true if @user_id
      return false
    rescue RuntimeError => e
        puts "ERROR: Could not log in: #{e.error}"
    end
  end

  def open_games
    begin
      Marshal.load(@master_server.get_waiting_games())
    rescue Errno::ECONNREFUSED => e
      puts "Error Getting open games! : #{e.error}"
    end
  end

  def saved_games()

  end

  def start_saved_game(id)

  end

  def add_observer(obs)
    @observers << obs
  end

  private
  def update_observers
    @observers.each {|observer| observer.update}
  end




end
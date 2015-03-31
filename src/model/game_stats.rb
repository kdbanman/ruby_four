require 'xmlrpc/utils'

class GameStats

  include XMLRPC::Marshallable

  private

  @by_username

  public

  def initialize
    @by_username = Hash.new
  end

  # @param [String] username
  # @param [Symbol] gametype either :connect4 or :otto
  # @param [Symbol] outcome either :wins, :losses, or :draws
  # @param [Integer] number the number of passed outcomes for the passed gametype and user
  def add_stat(username, gametype, outcome, number)
    init_username username if @by_username[username].nil?

    @by_username[username][gametype][outcome] = number
  end

  private

  def init_username(username)
    @by_username[username] = Hash.new
    @by_username[username][:connect4] = Hash.new
    @by_username[username][:connect4][:wins] = 0
    @by_username[username][:connect4][:losses] = 0
    @by_username[username][:connect4][:draws] = 0
    @by_username[username][:otto] = Hash.new
    @by_username[username][:otto][:wins] = 0
    @by_username[username][:otto][:losses] = 0
    @by_username[username][:otto][:draws] = 0
  end

end
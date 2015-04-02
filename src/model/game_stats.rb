require 'xmlrpc/utils'
require_relative '../model/game_stats_contracts'

class GameStats

  include XMLRPC::Marshallable
  include GameStatsContracts

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
    # preconditions
    is_username username
    is_type gametype
    is_outcome outcome
    is_positive_int number

    init_username username if @by_username[username].nil?

    insert_outcome username, gametype, outcome, number
  end

  # @param [String] username
  # @param [Symbol] gametype either :connect4 or :otto
  # @param [Symbol] outcome either :wins, :losses, or :draws
  # @return [Integer] the number of passed outcomes for the passed gametype and user
  def get_stat(username, gametype, outcome)
    # preconditions
    is_username username
    is_type gametype
    is_outcome outcome

    user = @by_username[username]

    number = user.nil? ? 0 : user[gametype][outcome]

    # postconditions
    is_positive_int number

    number
  end

  # @param [String] username
  # @param [Symbol] gametype either :connect4 or :otto
  # @param [Symbol] outcome either :wins, :losses, or :draws
  def increment_stat(username, gametype, outcome)
    # preconditions
    is_username username
    is_type gametype
    is_outcome outcome

    old = @stats.get_stat username, gametype, outcome
    @stats.add_stat username, gametype, outcome, old + 1
  end

  # yields each |username, gametype, outcome, number|
  def each_stat
    @by_username.each_key do |username|
      [:connect4, :otto].each do |gametype|
        [:wins, :losses, :draws].each do |outcome|
          yield_stat(username,
                gametype,
                outcome,
                @by_username[username][gametype][outcome]) if block_given?
        end
      end
    end
  end

  private

  def yield_stat(username, gametype, outcome, number)
    # preconditions
    is_username username
    is_type gametype
    is_outcome outcome
    is_positive_int number

    yield username, gametype, outcome, number
  end

  def insert_outcome(username, gametype, outcome, number)
    # preconditions
    is_hash @by_username
    is_hash @by_username[username]
    is_hash @by_username[username][gametype]
    is_hash @by_username[username][gametype][outcome]

    @by_username[username][gametype][outcome] = number
  end

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
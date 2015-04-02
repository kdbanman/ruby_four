
require_relative '../util/common_contracts'
require_relative '../model/game_stats'

# this could be better designed, but it's just a testing stub
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
    new_id = @games.length
    @games[new_id] = data
    @users[player1][:saved_games].push(new_id)
    @users[player2][:saved_games].push(new_id)
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] playerID
  def add_user(username, password)
    #pre
    CommonContracts.strings username, password

    # {<int_id>: { name: <str_name>, pass: <str_passwd>, id: <int_id>, saved_games: [<int_id>, ...] } }
    new_id = @users.length
    user = @users[new_id] = Hash.new
    user[:name] = username
    user[:pass] = password
    user[:id] = new_id
    user[:saved_games] = Array.new
  end

  # @param [String] username
  # @param [String] password
  # @return [Integer] userID or nil if not found
  def get_user_id(username, password)
    #pre
    CommonContracts.strings username, password

    @users.each_pair { |id, user| return id if user[:name] == username && user[:pass] == password }
    nil
  end

  # @param [Integer] id
  # @return [String] the users name, or nil if not found
  def get_user_name(id)
    #pre
    CommonContracts.integers id
    user = @users[id]
    return user[:name] unless user.nil?
    nil
  end

  # @param [String] username
  # @return [Boolean] exists
  def user_exists(username)
    #pre
    CommonContracts.strings username
    @users.each_value { |user| return true if user[:name] == username }
    false
  end

  # @param [Integer] id
  def get_saved_game(id)
    #pre
    CommonContracts.integers id
    @games[id]
  end

  # @param [Integer] id
  # @param [Symbol] game_type either :connect4 or :otto
  # @return [Array] all stats [<wins>, <losses>, <draws>]
  def get_player_stats(id, game_type)
    #pre
    CommonContracts.integers id
    CommonContracts.verify_type game_type

    name = get_user_name(id)
    [@stats.get_wins(name, game_type), @stats.get_losses(name, game_type), @stats.get_draws(name, game_type)]
  end

  # @return [GameStats] all wins, losses, and draws for all players for both game types
  def get_all_stats
    @stats
  end

  # @param [Integer] id
  def update_saved_game(id, data)
    #pre
    CommonContracts.integers id

    @games[id] = data
  end

  # @param [Integer] id
  def delete_saved_game(id)
    #pre
    CommonContracts.integers id

    @games.delete id
  end

end
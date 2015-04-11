require 'securerandom'
require 'xmlrpc/server'
require_relative '../src/master_server_contracts'
require_relative '../src/SQL/db_helper'
require_relative '../src/rpc_game_server'
require_relative '../src/model/containers'
require_relative '../src/model/game_config'

# To start as a remote server, use as an XMLRPC Server Handler:
#   num_clients = 100
#   master = XMLRPC::Server.new 8080, 'localhost', num_clients
#   s.add_handler('master', MasterServer.new)
# Valid ports: 50500 50550
class MasterServer

  private

  @db

  @waiting      # Hash from game id (UUID string) to RPCGameServer
  @in_progress  # Same as above

  @game_server_listeners # Hash from game_ids to forked pids

  include MasterServerContracts

  public

  def initialize(dbhelper = DbHelper.new)
    @db = dbhelper

    @waiting = Hash.new
    @in_progress = Hash.new

    # set an XMLRPC handler with the game server mounted at the game id path returned from save
    @game_server_listeners = Hash.new

  end

  def shutdown
    # for each game server in progress, in waiting, shut down
    @waiting.each_value { |game| game.shutdown }
    @in_progress.each_value { |game| game.shutdown }

    # kill pids in game server listeners
    @game_server_listeners.each_value { |pid| Process.kill('INT', pid) }
  end

  ####
  # METHODS FOR CALL BY CLIENT MASTER DATA SOURCE OVER RPC
  ####

  def create_user(username, password)
    # preconditions
    is_username username
    is_passwd password

    if @db.user_exists username
      puts "User #{username} #{password} exists!"
      return false
    end

    puts "Creating#{username} #{password}";
    @db.add_user username, password

    # postconditions
    is_int @db.get_user_id(username, password)

    true
  end

  def auth_user(username, password)
    # preconditions
    is_username username
    is_passwd password

    id = @db.get_user_id username, password
    unless id.nil?
      puts "#{username} #{password} valid"
      return true
    end

    puts "#{username} #{password} invalid!"
    false
  end

  # @param [GameConfig] config
  def create_game(config, username)
    config = Marshal.load(config)
    # preconditions
    # config must have at least 1 non nil player
    at_least_one_player config
    # human user name(s) must be in users db
    is_true @db.user_exists(config.name1) if config.player1 == :human
    is_true @db.user_exists(config.name2) if config.player2 == :human
    # one human config name must match username
    one_matches config.name1, config.name2, username

    # initialize game server
    game = RPCGameServer.new self, config
    new_id = SecureRandom.uuid

    # config may not be complete, i.e. with 1 nil player
    if config.player2.nil?
      puts "Inserting new game #{new_id} into waiting."
      # if not complete, put the game in waiting games list and do not call server start_from_config
      @waiting[new_id] = game
    else
      # both players are defined - safe to save game
      initialize_game(game, new_id)

      puts "Adding saved game #{new_id}"

      @db.add_saved_game(new_id, Marshal.dump(game.board), config.name1, config.name2)
      # TODO if both players
    end

    create_game_server_listener(new_id, game)

    # postconditions

    new_id
  end

  def start_saved_game(game_id, username)

  end

  # note: a client *connects* with an in progress game by making RPC calls to the servlet at the game_id path, this
  # method just readies the server-side game object with the second player.
  # @param [Integer] wait_id the waiting game id.  not equal to the game id.
  def join_game(wait_id, username)
    # preconditions
    is_true !@waiting[wait_id].nil?

    # call server start_from config and put the game in progress, remove from waiting
    game = @waiting[wait_id]
    initialize_game game, wait_id
    @waiting.delete wait_id
    @in_progress[wait_id] = game

    @db.add_saved_game(new_id, Marshal.dump(game.board), game.config.name1, username)

    # postconditions
    is_true @waiting[wait_id].nil?
    is_true !@in_progress[wait_id].nil?
  end

  # Intended to be called from clients, who may use the list to choose a game and later call join_game(id, username)
  # @return [Serialized Array<OpenGame>]
  def get_waiting_games(username)
    waiting_list = @waiting.each_pair.collect {|game_id, board| OpenGame.new(game_id, board.player1.name, board.config.type)}

    Marshal.dump(waiting_list)
  end

  def get_game_stats(username)
    # return game stats object populated from database query results
    #TODO
  end

  ####
  #  METHODS FOR CALL BY GAME SERVER
  ####

  # saves an in progress game to the database
  # @param [String] game_id uuid
  # @param [Board] board
  def save_game(game_id, board)
    # preconditions
    CommonContracts.is_gameid game_id
    CommonContracts.is_board board

    @db.update_saved_game(game_id, Marshal.dump(board)) #TODO wrap serialization exception
  end

  def win_game(game_id)
    # win handler should delete saved and *should* unmount rpc handler, but is impossible with ruby's XMLRPC
    @db.delete_saved_game(game_id)
    destroy_game_server_listener game_id
  end

  def exit_game(game_id)
    # exit handler should remove from in progress, waiting, unmount rpc handler (last thing is impossible)
    @in_progress.delete game_id
    @waiting.delete game_id

    destroy_game_server_listener game_id
  end

  private

  # @param [RPCGameServer] game
  # @param [GameConfig] config
  # @param [String] new_id
  def initialize_game(game, new_id)
    puts "Starting game #{new_id}: #{game}"
    # if complete, call server start_from_config and put the game in in progress
    game.start_from_config new_id
  end

  def create_game_server_listener(new_id, game)

    puts "forking game listener for #{new_id}"
    pid = fork do
      # TODO try until no EADDRINUSE
      port = 50500 + Random.rand(50)
      puts "Starting game #{new_id} server listener on port #{port}"
      server = XMLRPC::Server.new(port, 'localhost', 2)
      server.add_handler("#{new_id}", game)
      Signal.trap('INT') { server.shutdown }
      server.serve
    end

    puts "registering pid #{pid} with game #{new_id}"
    @game_server_listeners[new_id] = pid
  end

  def destroy_game_server_listener(game_id)

  end

end
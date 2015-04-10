require 'securerandom'
require_relative '../src/master_server_contracts'
require_relative '../src/SQL/db_helper'
require_relative '../src/rpc_game_server'

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

  @game_server_listener # XMLRPC server with mounted handlers

  include MasterServerContracts

  def initialize(listen_port, dbhelper = DbHelper.new)
    # preconditions
    is_positive_int listen_port

    @db = dbhelper

    @waiting = Hash.new
    @in_progress = Hash.new

    # set an XMLRPC handler with the game server mounted at the game id path returned from save
    @game_server_listener = XMLRPC::Server.new listen_port, 'localhost', 100

  end

  ####
  # METHODS FOR CALL BY CLIENT MASTER DATA SOURCE OVER RPC
  ####

  def create_user(username, password)
    # preconditions
    is_username username
    is_passwd password

    @db.add_user username, password

    # postconditions
    is_int @db.get_user(username, password)
  end

  def auth_user(username, password)
    # preconditions
    is_username username
    is_passwd password

    id = @db.get_user_id username, password
    return true unless id.nil?
    false
  end

  # @param [GameConfig] config
  def create_game(config, username)
    # preconditions
    # config must have at least 1 non nil player
    at_least_one_player config
    # human user name(s) must be in users db
    is_true @db.user_exists(config.name1) if config.player1 == :human
    is_true @db.user_exists(config.name2) if config.player2 == :human
    # one human config name must match username
    one_matches config.name1, config.name2, username

    # initialize game server
    game = RPCGameServer.new config
    new_id = SecureRandom.uuid

    # config may not be complete, i.e. with 1 nil player
    if config.player2.nil?
      # if not complete, put the game in waiting games list and do not call server start_from_config
      @waiting[new_id] = game
    else
      initialize_game(game, new_id)
    end

    @game_server_listener.add_handler(new_id, game)

    # postconditions

    new_id
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

    # postconditions
    is_true @waiting[wait_id].nil?
    is_true !@in_progress[wait_id].nil?
  end

  # Intended to be called from clients, who may use the list to choose a game and later call join_game(id, username)
  # @return [Array<GameServer>]
  def get_waiting_games(username)
    #TODO
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
  end

  def exit_game(game_id)
    # exit handler should remove from in progress, waiting, unmount rpc handler (last thing is impossible)
    @in_progress.delete game_id
    @waiting.delete game_id
  end

  private

  # @param [RPCGameServer] game
  # @param [GameConfig] config
  # @param [String] new_id
  def initialize_game(game, new_id)
    # if complete, call server start_from_config and put the game in in progress
    game.start_from_config new_id

    # save game, and add handler to save game on change
    @db.add_saved_game(new_id, Marshal.dump(game.board))
    game.add_observer self, :save_game
  end

end
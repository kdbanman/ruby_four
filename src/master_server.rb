require_relative '../src/master_server_contracts'
require_relative '../src/SQL/db_helper'

# To start as a remote server, use as an XMLRPC Server Handler:
#   num_clients = 100
#   master = XMLRPC::Server.new 8080, 'localhost', num_clients
#   s.add_handler('master', MasterServer.new)
class MasterServer

  private

  @db

  @waiting
  @in_progress


  include MasterServerContracts

  def initialize(listen_port, dbhelper = DbHelper.new)
    # preconditions
    is_positive_int listen_port

    @db = dbhelper

    @waiting = Hash.new
    @in_progress = Hash.new

  end

  def create_user(username, password)
    # preconditions
    is_username username
    is_passwd password

    # postconditions
    is_int @db.get_user(username, password)
  end

  def auth_user(username, password)
    # preconditions
    is_username username
    is_passwd password

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
    # add handlers to save game or clean resources on certain client actions
    # save the game
    # set game_id using returned save id

    # config may not be complete, i.e. with 1 nil player
    # if not complete, put the game in waiting games list and do not call server start_from_config
    # if complete, call server start_from_config and put the game in in progress

    # start an XMLRPC servlet with the game server handler and mount it at the game id path returned from save

    # postconditions

    # return the game id
  end

  def wait_on_game(game_id, username)

  end

  # note: a client *connects* with an in progress game by making RPC calls to the servlet at the game_id path, this
  # method just readies the server-side game object with the second player.
  def join_game(game_id, username)
    # preconditions
    is_true !@waiting[game_id].nil?

    # fill in game config
    # call server start_from config and put the game in progress, remove from waiting

    # save game

    # postconditions
    is_true @waiting[game_id].nil?
    is_true !@in_progress[game_id].nil?
  end

  def add_handlers(game_server)
    # add token placement and exit handlers to save game, clean up rpc servlets, etc
  end

  # saves an in progress game to the database
  def save_game(game_server, username, game_id = nil)
    # preconditions

    # serialize and save to the database (at game_id row if not nil), store local save_id for postcondition

    # return save_id
  end

  # Intended to be called from clients, who may use the list to choose a game and later call join_game(id, username)
  # @return [Array<GameServer>]
  def get_waiting_games(username)

  end

  def get_game_stats(username)
    # return game stats object populated from database query results
  end

end
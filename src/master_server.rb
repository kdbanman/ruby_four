class MasterServer

  def initialize(listen_port)

  end

  def create_user(username, password)

  end

  def auth_user(username, password)

  end

  def create_game(config, username)
    # preconditions
    # TODO config must have at least 1 non nil player
    # TODO human user name(s) must be in users db

    # initialize game server
    # add handlers to save game or clean resources on certain client actions
    # save the game
    # set game_id using returned save id

    # config may not be complete, i.e. with 1 nil player
    # if not complete, put the game in waiting games list and do not call server start_from_config
    # if complete, call server start_from_config and put the game in in progress

    # start an XMLRPC servlet with the game server handler and mount it at the game id path returned from save

    # postconditions
    # TODO servlet started

    # return the game id
  end

  def wait_on_game(game_id, username)

  end

  # note: a client *connects* with an in progress game by making RPC calls to the servlet at the game_id path, this
  # method just readies the server-side game object with the second player.
  def join_game(game_id, username)
    # preconditions
    # TODO game in waiting list
    # TODO game config has a nil player slot

    # fill in game config
    # call server start_from config and put the game in progress, remove from waiting

    # save game

    # postconditions
    # TODO no longer in waiting
    # TODO in progress
    # TODO servelet still exists
  end

  def add_handlers(game_server)
    # add token placement and exit handlers to save game, clean up rpc servlets, etc
  end

  # saves an in progress game to the database
  def save_game(game_server, username, game_id = nil)
    # preconditions

    # serialize and save to the database (at game_id row if not nil), store local save_id for postcondition

    # postconditions
    # TODO save_id must equal game_id if not nil

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
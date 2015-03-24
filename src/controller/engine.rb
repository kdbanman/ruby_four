require 'thread'

require_relative '../game_server'

require_relative '../util/common_contracts'

require_relative '../view/new_game_dialog'
require_relative '../view/game_screen'

require_relative '../model/game_config'
require_relative '../model/game_type_factory'
require_relative '../model/data_source'

class Engine

  private

  @game_type
  @data_source

  @game_screen

  public

  def initialize(port)
    new_game = NewGameDialog.new
    new_game.setup_ok_listener do |game_config|
      game_config.port = port
      set_game_model game_config
      start_game_screen game_config

      attempt_ai_player @data_source.board
    end
    new_game.start
  end

  # @param [GameConfig] game_config
  def set_game_model(game_config)
    puts "Creating game with config: #{game_config}"
    @game_type = GameTypeFactory.get_game_type game_config
    @data_source = DataSource.new game_config
    @data_source.add_observer self
  end

  # @param [GameConfig] game_config
  def start_game_screen(game_config)
    @game_screen = GameScreen.new @game_type, @data_source, game_config

    @game_screen.set_column_selected_listener do |col|
      current_player_id = @data_source.board.current_player_id
      @data_source.place_token(current_player_id,
                               col,
                               @game_type.get_player_token_type(current_player_id))
    end

    @game_screen.set_close_listener { @data_source.exit_game(@data_source.board.current_player_id) }

    @game_screen.set_new_game_listener do |game_config|
      #@game_screen.kill
      # restart the game (server)
      new_server_sync do
        set_game_model game_config
        start_game_screen game_config
      end
    end

    @game_screen.start
  end

  def new_token_command(coordinate)
    CommonContracts.valid_coordinate(coordinate)
  end

  # @param [Board] board
  def update(board)
    #TODO is a board
    attempt_ai_player board
  end

  # @param [Board] board
  def attempt_ai_player(board)
    unless board.winner
      current_player_id = @data_source.board.current_player_id
      opponent_id = 1 + current_player_id % 2
      ai_player = @data_source.board.get_player(current_player_id)
      ai_column = ai_player.get_column(@data_source.board,
                                       @game_type.get_win_pattern(current_player_id),
                                       @game_type.get_win_pattern(opponent_id))
      unless ai_column.nil?
        @game_screen.update board
        puts "ENGINE: AI player #{current_player_id} placing in column #{ai_column}"
        @data_source.place_token(current_player_id,
                                 ai_column,
                                 @game_type.get_player_token_type(current_player_id))
      end
    end
  end

  def setupColumnClickListener
  end

  def setupNewGameListener
  end

  def setupCloseListener
  end

  def startNewGameMenu
  end

  def startNewGameScreen
  end

end
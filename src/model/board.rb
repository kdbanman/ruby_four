require 'xmlrpc/marshal'
require_relative '../model/abstract_board'
require_relative '../controller/human_player'
require_relative '../controller/easy_computer_player'
require_relative '../controller/hard_computer_player'
require_relative '../model/board_dimensions'
require_relative '../model/game_config'

class Board < AbstractBoard

  include XMLRPC::Marshallable

  attr_reader :player1, :player2, :current_player_id, :winner, :game_id, :config

  private

  @config
  @game_type
  @game_id

  @board
  @tokens
  @token_count
  @most_recent_token

  @player1
  @player2
  @current_player_id
  @winner

  public

  # @param [GameConfig] config
  # @param [GameType] game_type
  # @param [Integer] game_id
  def initialize(config, game_type, game_id)
    @config = config
    @game_type = game_type
    @game_id = game_id

    @board = BoardDimensions.new(config.num_cols, config.num_rows)
    @tokens = Hash.new
    @token_count = 0

    player_token_count = (config.num_rows * config.num_cols / 2.0).ceil

    # TODO this should use a player factory initialized with token count, game type.
    @player1 = build_player(player_token_count, game_type, config.player1, config.name1, 1, config.difficulty)
    @player2 = build_player(player_token_count, game_type, config.player2, config.name2, 2, config.difficulty)

    @current_player_id = 1
  end

  # @param [Integer] token_count
  # @param [GameType] game_type
  # @param [Symbol] type either "human" or "computer"
  # @param [String] name
  # @param [Integer] id either 1 or 2
  # @param [Symbol] difficulty either "easy" or "hard"
  def build_player(token_count, game_type, type, name, id, difficulty = "easy")
    return HumanPlayer.new(name, game_type.make_initial_tokens(id, token_count), id) if (type == "human")

    return EasyComputerPlayer.new(name, game_type.make_initial_tokens(id, token_count), id) if (difficulty == "easy")
    HardComputerPlayer.new(name, game_type.make_initial_tokens(id, token_count), id, game_type)
  end

  # @return [Player] player 1 or player 2
  def get_player(id)
    #preconditions
    #TODO id is 1 or 2
    if id == 1
      @player1
    else
      @player2
    end
  end

  def switch_player
    @current_player_id = 1 + @current_player_id % 2
  end

  def current_player
    return @player1 if @current_player_id == 1
    return @player2 if @current_player_id == 2
  end

  # @param [Integer] id
  def is_current_player(id)
    id == @current_player_id
  end

  # @param [Integer] player_id either 1 or 2
  def set_winner(player_id)
    # make sure winner is only set once
    if @winner.nil?
      @winner = player1 if player_id == 1
      @winner = player2 if player_id == 2
    end
  end

end
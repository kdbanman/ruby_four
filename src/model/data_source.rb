require 'observer'
require_relative '../model/data_source_contracts'

class DataSource

  include Observable
  include DataSourceContracts

  private

  @players
  @board

  public

  def initialize

    @players = Array.new
    @players[1] = Player.new 'default'
    @players[2] = Player.new 'default'

    @board = BoardDimensions.new 6, 7

    verify_invariants
  end

  def execute(placeTokenCommand)

  end

  private

  def verify_invariants
    two_players @players
    has_board @board
  end

end
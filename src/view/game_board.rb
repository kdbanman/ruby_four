require_relative './game_board_contracts.rb'
require_relative '../util/common_contracts.rb'
require_relative './column.rb'
require_relative '../resources/board_view.rb'
require_relative './slot.rb'
class GameBoard

  attr_reader :columnClickListener
  attr_reader :columns
  attr_reader :gameType
  attr_reader :boardView

	include GameBoardContracts

	public
	def initialize(gametype, width, height)
		#game_type_generates_tokens(gametype)
    #TODO change this to use gametype
    Slot.initializeTokens 'a', 'b'
    @columns = []
    width.times {@columns << Column.new(height)}
    @boardView = BoardView.new
    #TODO x.event box should be replaced with x.topWindow or something like that
    @boardView.addColumn @columns.collect {|x| x.eventBox}
	end

	def set_column_click_listener(&block)
		CommonContracts.block_callable(block)
	end

  def connect_event_handlers
    @columns.each {|col| col.connect_events}
  end

	private
	def draw_token(coordinate)
		CommonContracts.valid_coordinate(coordinate)
	end

	def draw_ghost(coordinate)
		CommonContracts.valid_coordinate(coordinate)
	end

	def handle_column_click
	end

	def handle_column_hover
  end


end
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
    #TODO uncomment this contract
		#game_type_generates_tokens(gametype)
    #TODO change this to use gametype
    Slot.initializeTokens 'a', 'b'
    @columns = []
    width.times {@columns << Column.new(height)}
    @boardView = BoardView.new
    @boardView.addColumn @columns.collect {|x| x.topView}
	end

	def set_column_click_listener(&block)
    CommonContracts.block_callable(block)
    @columnClickListener = block
    columns.length.times do |i|
      column = @columns[i]
      column.set_on_click_listener {handle_column_click i}
    end
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

	def handle_column_click (colNumber)
    @columnClickListener.call colNumber
	end

	def handle_column_hover

  end


end
require_relative '../util/common_contracts.rb'
require_relative '../resources/column_view.rb'
require_relative './column_contracts.rb'

class Column
	include ColumnContracts
  attr_reader :slots
  attr_reader :size
  attr_reader :colView
  attr_reader :eventBox


	def initialize(size)
    @slots = []
    size.times {slots << Slot.new}
    @colView = ColumnView.new(@slots.collect {|x| x.slotView})
    setup_event_box
  end

	def draw_token(coordinate)
		#pre
		valid_coordinate(coordinate, @size)

		#post
		slot_is_filled(@slots[coordinate.y])
	end

	def draw_ghost(coordinate)
		valid_coordinate(coordinate, @size)
	end

	def set_hover_listener(&block)
		CommonContracts.block_callable(block)
  end

  def setup_event_box
    @eventBox = Gtk::EventBox.new
    @eventBox.set_events([Gdk::Event::ENTER_NOTIFY_MASK, Gdk::Event::LEAVE_NOTIFY_MASK, Gdk::Event::BUTTON_RELEASE_MASK])
    @eventBox.add(@colView)
  end

  def set_on_click_listener(&block)
    @eventBox.signal_connect('button_release_event') do
      yield
    end
  end

  def connect_events
    @eventBox.realize

    @eventBox.signal_connect('enter_notify_event') do
      @slots.each do |slot|
        unless slot.is_filled?
          slot.draw_ghost
          break
        end
      end
    end

    @eventBox.signal_connect('leave_notify_event') do
      @slots.each do |slot|
        slot.clear_ghost
      end
    end
  end

  def topView
    @eventBox
  end
end
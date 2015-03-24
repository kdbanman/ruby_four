require_relative '../util/common_contracts.rb'
require_relative './slot_contracts.rb'
require_relative '../resources/slot_view.rb'
require 'gtk2'

class Slot
  public
  #TODO could use to cache 
  #@@player1Token
  #@@player2Token
  @@ghost
  @@empty
  attr_reader :slotView
  attr_reader :filled
  attr_reader :ghosted

	include SlotContracts


  def Slot.initializeTokens(p1, p2)
    #TODO replace with pixbufs
    # @@player1Token = p1
    # @@player2Token = p2

    @@ghost = Gdk::Pixbuf.new  File.dirname(__FILE__) + '/../resources/ghostSlot.png'
    @@empty = Gdk::Pixbuf.new File.dirname(__FILE__) + '/../resources/emptySlot.png'

  end

	def initialize
    #pre
    class_variables_not_null @@ghost, @@empty
    @slotView = SlotView.new(@@empty)
    @filled = FALSE
    @ghosted = FALSE
  end

	def fill(imgpath)
    clear_ghost
    slotView.fill(Gtk::Pixbuf.new imgpath)
    @filled = true
		#post
		filled?(@filled)
  end

  def draw_ghost
    unless @ghosted
      @slotView.fill(@@ghost)
      @ghosted = TRUE
    end
  end

  def clear_ghost
    if @ghosted
      @slotView.fill(@@empty)
      @ghosted = FALSE
    end
  end

	def draw
	end

	def is_filled?
    @filled
	end

end
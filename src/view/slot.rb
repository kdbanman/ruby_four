require_relative '../util/common_contracts.rb'
require_relative './slot_contracts.rb'
require_relative '../resources/slot_view.rb'

class Slot
  public
  @@player1Token
  @@player2Token
  @@ghost
  @@empty
  attr_reader :slotView
  attr_reader :filled
  attr_reader :ghosted

	include SlotContracts

  def Slot.initializeTokens(p1, p2)
    @@player1Token = p1
    @@player2Token = p2
    @@ghost = File.dirname(__FILE__) + '/../resources/ghostSlot.png'
    @@empty = File.dirname(__FILE__) + '/../resources/emptySlot.png'
    @filled = FALSE
    @ghosted = FALSE
  end

	def initialize
    #pre
    class_variables_not_null @@player1Token, @@player2Token
    @slotView = SlotView.new(@@empty)
  end

	def fill
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
require_relative '../util/common_contracts.rb'
require_relative './slot_contracts.rb'
require_relative '../resources/slot_view.rb'

class Slot
  public
  @@player1Token
  @@player2Token
  attr_reader :slotView
  attr_reader :filled

	include SlotContracts

  def Slot.initializeTokens(p1, p2)
    @@player1Token = p1
    @@player2Token = p2
  end

	def initialize
    #pre
    class_variables_not_null @@player1Token, @@player2Token
    @slotView = SlotView
  end

	def fill
		#post
		filled?(@filled)
	end

	def draw
	end

	def is_filled?
	end

end
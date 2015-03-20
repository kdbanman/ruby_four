require 'gtk2'

class SlotView < Gtk::Image

  @empty_slot = File.dirname(__FILE__) + '/emptySlot.png'

  def initialize
    super(@empty_slot)
  end

  def fill(filename)
    self.image = filename
  end

  def fillGhost(player)
    #TODO set the alpha somehow
  end

end
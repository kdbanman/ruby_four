require 'gtk2'

class SlotView < Gtk::Image

  @empty_slot = File.dirname(__FILE__) + 'emptySlot.png'

  def initialize
    super(File.dirname(__FILE__) + '/emptySlot.png')
  end

  def fill(filename)
    self.image = filename
  end

  def fillGhost(player)
    #TODO set the alpha somehow
  end

end
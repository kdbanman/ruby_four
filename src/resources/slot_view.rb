require 'gtk2'

class SlotView < Gtk::Image


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
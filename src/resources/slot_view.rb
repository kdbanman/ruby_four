require 'gtk2'

class SlotView < Gtk::Image


  def initialize (filename)
    super(filename)
  end

  def fill(filename)
    self.set_file filename
  end

  def fillGhost(player)
    #TODO set the alpha somehow
  end

end
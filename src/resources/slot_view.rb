require 'gtk2'

class SlotView < Gtk::Image

  # @param [String] filename
  def initialize (filename)
    super(filename)
  end

  # @param [String] filename
  def fill(filename)
    self.set_pixbuf filename
  end

end
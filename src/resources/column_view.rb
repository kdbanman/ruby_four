require 'gtk2'

class ColumnView < Gtk::VBox
  def initialize(slotViews)
    super(true, 10)
    slotViews.each {|slot| pack_start(slot, true, true, 0)}
  end
end
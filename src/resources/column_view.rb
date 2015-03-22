require 'gtk2'

class ColumnView < Gtk::VBox

  # @param [Array] slotViews
  def initialize(slotViews)
    super(true, 5)
    slotViews.each {|slot| pack_end(slot, true, true, 0)}
  end
end
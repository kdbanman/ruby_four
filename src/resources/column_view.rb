require 'gtk2'

class ColumnView < Gtk::VBox
  def initialize(slotViews)
    super(true)
    slotViews.each {|slot| pack_start(Gtk::Button.new 'hey')}
  end
end
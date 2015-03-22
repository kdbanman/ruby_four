require 'gtk2'

class BoardView < Gtk::HBox

  def initialize()
    super(true, 5)
    @colViews = []
  end

  def addColumn(columnViews)
    pack_start(Gtk::VSeparator.new, true, true, 0)
    columnViews.each do |view|
      pack_start(view, true, true, 0)
    end
  end

end
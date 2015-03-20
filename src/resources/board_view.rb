require 'gtk2'

class BoardView < Gtk::HBox

  def initialize()
    super(true, 10)
    @colViews = []
  end

  def addColumn(columnViews)
    columnViews.each do |view|
      pack_start(view)
    end
  end

end
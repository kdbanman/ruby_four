require 'gtk2'

class TextEntry
  attr_reader :name

  def initialize(view, nameIn)
    @view = view
    @name = nameIn
  end

  def text
    @view.text
  end

  def valid?
    raise 'TextEntry must be subclassed'
  end

  def raise_invalid_dialog(msg)
    #TODO change to raise dialog
    dialog = Gtk::MessageDialog.new(nil, Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::WARNING, Gtk::MessageDialog::BUTTONS_OK, msg)
    dialog.run
    dialog.destroy
  end
end
require_relative '../util/text_entry.rb'

class NameEntry < TextEntry

  def initialize(view, nameIn)
    super(view, nameIn)
  end

  def valid?
    @view.text.match(/^[A-Za-z0-9]+$/)
  end

end
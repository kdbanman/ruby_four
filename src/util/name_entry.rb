require_relative '../util/text_entry.rb'

class NameEntry < TextEntry

  def initialize(view, nameIn)
    super(view, nameIn)
  end

  def valid?
    unless @view.text.match(/^[A-Za-z0-9]+$/)
      raise_invalid_dialog 'Names must only contain alpha numeric chars'
      return false
    end
    return true
  end

  def text
    out = super
    if out.length == 0
      return 'computer'
    end
    return out
  end

end
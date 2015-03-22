require_relative '../util/text_entry.rb'

class SizeEntry < TextEntry
  def initialize(view, name)
    super(view, name)
  end

  def valid?
    if text.match(/^\d+$/)
      return TRUE if text.to_i > 0 and text.to_i <= 10
    end
    return FALSE
  end
end
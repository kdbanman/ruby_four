require_relative '../util/text_entry.rb'

class SizeEntry < TextEntry
  def initialize(view, name)
    super(view, name)
  end

  def valid?
    if text.match(/^\d+$/)
      if text.to_i > 0 and text.to_i <= 10
        return true
      end
    end
    raise_invalid_dialog 'Sizes must be greater than 0 and less than 11'
    return false
  end

  def value
    text.to_i
  end
end
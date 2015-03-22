require_relative '../util/text_entry.rb'

class SizeEntry < TextEntry
  MINSIZE = 4
  MAXSIZE = 10

  def initialize(view, name)
    super(view, name)
  end

  def valid?
    if text.match(/^\d+$/)
      if text.to_i > MINSIZE and text.to_i <= MAXSIZE
        return true
      end
    end
    raise_invalid_dialog "Sizes must be greater than #{MINSIZE} and less than #{MAXSIZE}"
    return false
  end

  def value
    text.to_i
  end
end
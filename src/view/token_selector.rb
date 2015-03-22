require 'gtk2'

class TokenSelector
  attr_reader :topView, :posX, :posY

  def initialize(posX, posY, name)
    @posX = posX
    @posY = posY
    @topView = Gtk::VBox.new
    @title = name
    build_selector
  end

  def get_token
    @group.each do |button|
      return button.get_value if button.get_value
    end
  end

  private
  def build_selector
    @topView.add(Gtk::Label.new(@title))
    @tButton = get_radio_button(:T, 'T')
    @group = @tButton.view
    @oButton = get_radio_button(:O, 'O', @group)
    @topView.add(@tButton.view)
    @topView.add(@oButton.view)
  end

  def get_radio_button (value, name, group=nil)
    Button.new(value, name, group)
  end
end

class Button
  attr_reader :view
  @value

  def initialize(value, name, group = nil)
    @view = Gtk::RadioButton.new(name)
    @view.set_group group if group
    @value = value
  end

  def get_value
    if @view.active?
      return @value
    else
      return nil
    end
  end


  def group
    @view.group
  end

end
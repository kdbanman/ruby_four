require_relative '../util/common_contracts'
require_relative '../view/window'

require 'gtk2'

class LoginScreen
  include Window

  @screen
  @builder

  @username
  @password
  @ip_address

  def initialize
    @builder = Gtk::Builder.new
    @builder.add_from_file(File.dirname(__FILE__) + '/../resources/login_screen.glade')
    @screen = @builder.get_object('LoginScreen')

    @username = @builder.get_object('username_entry')
    @password = @builder.get_object('password_entry')
    @ip_address = @builder.get_object('ip_entry')
    
  end

  def set_on_destroy(&block)
    CommonContracts.block_callable block
    @screen.signal_connect('destroy') { block.call }
  end

  def start
    @screen.show_all

    #post
    CommonContracts.is_visible @screen
  end

  def kill
    @screen.destroy
  end

  def set_sign_in_listener(&block)
    CommonContracts.block_callable block
    @builder.get_object('sign_in_button').signal_connect('released') do
      block.call(@username.text, @password.text, @ip_address.text) if non_empty_fields?
    end
  end

  private

  def non_empty_fields?
    @username.text.length > 0 && @password.text.length > 0 && @ip_address.text.length > 0
  end

end
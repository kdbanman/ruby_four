require 'hamster/deque'
require 'gtk2'

require_relative '../util/common_contracts'

class WindowManager

  @windows
  @on_quit_listener


  def initialize
    @windows = Hamster::Deque.empty
    Gtk.main
  end

  def open_window(window)
    window.set_on_destroy{window_destroyed}
    @windows.push(window)
    window.start
  end

  def close_all_windows
    #TODO needs exception handling
    @windows.each {|window| window.kill}
  end

  def set_on_quit_listener(&block)
    CommonContracts.block_callable block
    @on_quit_listener = block
  end

  def kill
    close_all_windows
    exit_gracefully
  end

  private
  def window_destroyed
    @windows = @windows.pop
    exit_gracefully if @windows.size == 0
  end

  def stop_main_loop
    Gtk.main_quit
  end

  def exit_gracefully
    @on_quit_listener.call if @on_quit_listener
    stop_main_loop
  end

end
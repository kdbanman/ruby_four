require 'hamster/deque'
require 'gtk2'

require_relative '../util/common_contracts'
require_relative '../controller/window_manager_contracts'

class WindowManager

  attr_reader :started

  @windows
  @on_quit_listener


  def initialize
    @windows = Hamster::Deque.empty
    @started = false
  end

  def start
    puts 'GTK main starting...'
    @started = true
    Gtk.main
  end

  def push_information_dialog(msg)
    CommonContracts.strings msg
    dialog = Gtk::MessageDialog.new(nil, Gtk::Dialog::DESTROY_WITH_PARENT,
                                    Gtk::MessageDialog::INFO, Gtk::MessageDialog::BUTTONS_OK, msg)
    dialog.run
    dialog.destroy
  end

  def open_window(window)
    WindowManagerContracts.is_window(window)
    begginning = @windows.size
    window.set_on_destroy{window_destroyed}
    @windows = @windows.push(window)
    window.start

    #post
    WindowManagerContracts.windows_incremented begginning, @windows.size
  end

  def replace_current_window(window)
    WindowManagerContracts.is_window window
    current_window = @windows.last
    beggining = @windows.size

    window.set_on_destroy {window_destroyed}
    @windows = @windows.pop.push(window).push(current_window)
    @windows.last.kill

    window.start
  end

  def set_head_and_kill_rest(window)
    WindowManagerContracts.is_window(window)
    @windows = @windows.unshift(window)
    window.set_on_destroy {window_destroyed}
    while @windows.size > 1
      @windows.last.kill
    end
    window.start
  end

  def close_all_windows
    #TODO needs exception handling
    @windows.each {|window| window.kill}

    #post
    WindowManagerContracts.all_windows_closed @windows
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
    beggining_size = @windows.size

    @windows = @windows.pop
    exit_gracefully if @windows.size == 0

    #post
    WindowManagerContracts.windows_decremented beggining_size, @windows.size
  end

  def stop_main_loop
    puts 'DEBUG: qutting gtk main loop'
    Gtk.main_quit
  end

  def exit_gracefully
    #pre
    WindowManagerContracts.all_windows_closed @windows

    @on_quit_listener.call if @on_quit_listener
    stop_main_loop
  end

end
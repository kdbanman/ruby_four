require 'gtk'
require 'hamster/deque'
require_relative '../view/contracts/window_manager_contracts'
require_relative '../util/common_contracts'

class WindowManager

  include WindowManagerContracts
  @windows = Hamster::deque.empty

  def start
    verify_quit_match_listener @quit_match_listener
    verify_quit_game_listener @quit_game_listener
    verify_new_game_listener @new_game_listener
    verify_get_stats_listener @get_Stats_listener
    verify_load_game_listener @load_game_listener
    Gtk.main()
  end

  def set_new_game_listener(&block)
    CommonContracts.block_callable block
    @new_game_listener = block
  end

  def set_get_stats_listener(&block)
    CommonContracts.block_callable block
    @get_Stats_listener = block
  end

  def set_quit_match_listener(&block)
    CommonContracts.block_callable block
    @quit_match_listener = block
  end

  def set_quit_game_listener(&block)
    CommonContracts.block_callable block
    @quit_game_listener = block
  end

  def set_load_game_listener(&block)
    CommonContracts.block_callable block
    @load_game_listener = block
  end

  def push_stats_window(stats)
    CommonContracts.array stats
  end

  def push_load_game_window(saved_games)
    CommonContracts.array saved_games
  end

  def push_game_screen(gametype, datasource, gameconfig)

    #post
    windowStackSize(1, @windows.size)
  end

  private
  def push_window
    oldStack = @windows.size

    #post
    windowStackIncremented(oldStack, @windows.size)
  end

  def pop_window
    oldStack = @windows.size

    #post
    windowStackDecremented(oldStack, @windows.size)
  end

  def kill_Stack

  end

end
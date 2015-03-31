require_relative '../../../src/util/contracted'

class WindowManagerContracts
  def not_nil(item, msg)
    failure msg if item == nil
  end

  def verify_quit_match_listener(item)
    not_nil item, 'You must set up a quit match listener before starting window manager'
  end

  def verify_new_game_listener(item)
    not_nil item, 'You must set up a new game listener before starting window manager'
  end

  def verify_quit_game_listener(item)
    not_nil item, 'You must set up a quit game listener before starting window manager'
  end

  def verify_get_stats_listener(item)
    not_nil item, 'You must set up a get stats listener before starting window manager'
  end


  def verify_load_game_listener(item)
    not_nil item, 'You must set up a load game listener before starting window manager'
  end

  def windowStackIncremented(oldSize, newSize)
    failure 'windowStack should have incremented' unless oldSize + 1 == newSize
  end

  def windowStackDecremented(oldSize, newSize)
    failure 'windowStack should have decremented' unless oldSize - 1 == newSize
  end

  def windowStackSize(expected, actual)
    failure "window size should be #{expected}" unless expected == actual
  end
end
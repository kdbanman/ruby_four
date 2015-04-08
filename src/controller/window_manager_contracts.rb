require_relative '../util/contracted'
require_relative '../view/window'

class WindowManagerContracts

  def WindowManagerContracts.is_window (input)
    failure 'Must pass a window' unless input.is_a? Window
  end

  def WindowManagerContracts.all_windows_closed(windows)
    failure 'All windows did not close' unless windows.size == 0
  end

  def WindowManagerContracts.windows_incremented(beg, after)
    failure 'Windows did not increment' unless beg+1 == after
  end

  def WindowManagerContracts.windows_decremented(beg, after)
    failure 'Windows did not decrement' unless after + 1 == beg
  end

end
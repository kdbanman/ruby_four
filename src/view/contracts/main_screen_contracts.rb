require_relative '../../util/contracted'

class MainScreenContracts

  def MainScreenContracts.listener_not_null(listener, listener_name)
    fail "Must connect #{listener_name} listener before starting!" unless listener
  end
end
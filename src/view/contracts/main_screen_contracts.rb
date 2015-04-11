require_relative '../../util/contracted'

class MainScreenContracts

  def MainScreenContracts.listener_not_null(listener, listener_name)
    fail "Must connect #{listener_name} listener before starting!" unless listener
  end

  def MainScreenContracts.datasource_correct(ds)
    fail "Datasource must provide open games and allow observers" unless ds.respond_to? :open_games and ds.respond_to? :add_observer
  end
end
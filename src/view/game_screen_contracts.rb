require_relative '../util/contracted.rb'
require_relative '../model/data_source.rb'

module GameScreenContracts
	def data_source_observable(ds)
		raise ContractFailure, "Datasource cannot be observed" unless ds.respoonds_to? :addObserver
	end

	def input_is_data_source(input)
		raise ContractFailure, "Input is not a datasource" unless input.is_a? DataSource
  end

  def not_nil(item, msg)
    raise ContractFailure, msg if item == nil
  end

  def verify_column_selected(item)
    not_nil item, 'You must set up a column selected listener before starting the screen'
  end

  def verify_new_game_listener(item)
    not_nil item, 'You must set up a new game listener before starting the screen'
  end

  def verify_game_closed_listener(item)
    not_nil item, 'You must set up a game closed listener before starting the screen'
  end
end	
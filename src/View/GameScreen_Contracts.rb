require './util/contracted.rb'
require './model/data_source.rb'

module GameScreen_Contracts
	def datasource_observable(ds)
		raise ContractFailure, "Datasource cannot be observed" unless ds.respoonds_to? :addObserver
	end

	def input_is_datasource(input)
		raise ContractFailure, "Input is not a datasource" unless input.is_a? DataSource
	end
end	
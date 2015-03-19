require_relative '../util/contracted.rb'
require_relative '../model/data_source.rb'

module GameScreenContracts
	def data_source_observable(ds)
		raise ContractFailure, "Datasource cannot be observed" unless ds.respoonds_to? :addObserver
	end

	def input_is_data_source(input)
		raise ContractFailure, "Input is not a datasource" unless input.is_a? DataSource
	end
end	
require './util/contracted.rb'


module GameScreen_Contracts
	def datasource_observable(ds)
		raise ContractFailure, "Datasource cannot be observed" unless ds.respoonds_to? :addObserver
	end
end	
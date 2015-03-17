require './util/contracted'

class PlaceTokenCommandContracts
	def input_is_datasource(input)
			raise ContractFailure, "Input is not a datasource" unless input.is_a? DataSource
	end
end
require_relative '../util/contracted.rb'

module SlotContracts
	def filled?(slot)
		raise ContractFailure, "slot did not get filled" unless slot
  end

  def class_variables_not_null(*input)
    input.each {|x| raise ContractFailure, 'must initalize player tokens before creating slot objects' if x.nil?}
  end
end
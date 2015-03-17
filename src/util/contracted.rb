class ContractFailure < StandardError

  attr_reader :msg

  def initialize(msg)
    super "\nContractFailure:  " + msg + "\n"
    @msg = msg
  end

end

def failure(msg)
  raise ContractFailure, msg
end
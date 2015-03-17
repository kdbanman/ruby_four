require_relative '../util/contracted'
require_relative '../util/common_contracts'

module ComputerPlayerContracts

  def integer_result(result)
    unless result.is_a?(Integer) && result >= 0
      failure "Computer player must decide positive integer column."
    end
  end

end

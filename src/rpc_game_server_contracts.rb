require_relative '../src/util/contracted'
require_relative '../src/util/common_contracts'

module  RPCGameServerContracts

  include CommonContracts

  def is_true(bool, msg = 'Must be true')
    failure msg unless bool
  end

  def is_int(*args)
    CommonContracts.integers *args
  end

  # @param [Board] board
  def token_delta_one(board)
    unless true
      failure 'TODO: players token list must be different by 1 or 0'
    end
  end
end
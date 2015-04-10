require_relative '../src/util/contracted'
require_relative '../src/util/common_contracts'

module  RPCGameServerContracts

  include CommonContracts

  def is_true(bool, msg = 'Must be true')
    failure msg unless bool
  end

  def is_gameid(*args)
    CommonContracts.is_gameid *args
  end

  def is_board(board)
    failure 'must be passed a Board' unless board.is_a? Board
  end

  def is_ip(ip)
    unless ip.is_a?(String) && ip =~ /\d+\.\d+\.\d+\.\d+/
      failure "#{ip} is not an ip"
    end
  end

  # @param [Board] board
  def token_delta_one(board)
    unless true
      failure 'TODO: players token list must be different by 1 or 0'
    end
  end
end
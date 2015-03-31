require_relative './contracted'
require_relative '../model/coord'
require_relative '../model/board'

module CommonContracts

  def CommonContracts.array(arg)
    unless arg.is_a? Array
      failure 'Parameter must be array.'
    end
  end

  def CommonContracts.integers(*args)
    unless args.each.all? { |param| param.is_a?(Integer) }
      failure 'Parameters must be integers.'
    end
  end

  def CommonContracts.strings(*args)
    failure 'inputs should be strings' unless args.all? {|i| i.is_a? :String}
  end

  def CommonContracts.positive_integers(*args)
    CommonContracts.integers(*args)

    unless args.each.all? { |param| param.is_a?(Integer) && param >= 0 }
      failure 'Parameters must be positive integers.'
    end
  end

  def CommonContracts.nonzero_positive_integers(*args)
    CommonContracts.integers(*args)

    unless args.each.all? { |param| param.is_a?(Integer) && param > 0 }
      failure 'Parameters must be positive integers greater than 0.'
    end
  end

  def CommonContracts.valid_coordinate(coordinate)

    unless coordinate.is_a? Coord
      failure 'Parameter must a Coordinate'
    end

    unless [coordinate.x, coordinate.y].each.all? { |param| param.is_a?(Integer) }
      raise ContractFailure, 'Parameter must a Coordinate of positive integers.'
    end
  end

  def CommonContracts.is_board(obj)
    unless obj.is_a? Board
      failure 'Parameter must be a Board'
    end
  end

  def CommonContracts.verify_type(type)
    unless type == :otto || type == :connect4
      failure 'Type must either be :otto or :connect4'
    end
  end

  def CommonContracts.valid_token_type(type)
    unless type == :O || type == :T || type == 1 || type == 2
      failure 'Type must either be :O or :T or 1 or 2'
    end
  end

  def CommonContracts.block_callable(block)
    raise ContractFailure, 'Block not callable' unless block.respond_to? :call
  end

  def CommonContracts.is_ip_addr(ip)
    unless ip.is_a?(String) && (ip =~ /\d*\.\d*\.\d*\.\d*/) == 0
      failure 'Param must be an ip address'
    end
  end
end

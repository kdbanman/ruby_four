require_relative './contracted'

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

  def CommonContracts.verify_type(type)
    unless type == :otto || type == :connect4
      failure 'Type must either be :otto or :connect4'
    end
  end

  def CommonContracts.block_callable(block)
    raise ContractFailure, 'Block not callable' unless block.respond_to? :call
  end
end

require_relative './contracted'

module CommonContracts

  def CommonContracts.integers(*args)
    msg = 'Parameters must be integers.'
    unless args.each.all? { |param| param.is_a?(Integer) }
      raise ContractFailure, msg
    end
  end

  def CommonContracts.positive_integers(*args)
    CommonContracts.integers(*args)

    msg = 'Parameters must be positive integers.'
    unless args.each.all? { |param| param.is_a?(Integer) && param >= 0 }
      raise ContractFailure, msg
    end
  end

  def CommonContracts.nonzero_positive_integers(*args)
    CommonContracts.integers(*args)

    msg = 'Parameters must be positive integers greater than 0.'
    unless args.each.all? { |param| param.is_a?(Integer) && param > 0 }
      raise ContractFailure, msg
    end
  end

  def CommonContracts.valid_coordinate(coordinate, col_count, col_height)
    msg = 'Parameter must a Coordinate of positive integers within board bounds.'
    unless coordinate.is_a? Coord
      raise ContractFailure, msg
    end

    unless [coordinate.x, coordinate.y].each.all? { |param| param.is_a?(Integer) && param >= 0 }
      raise ContractFailure, msg
    end

    unless coordinate.x < col_count && coordinate.y < col_height
      raise ContractFailure, msg
    end
  end
end
class AbstractBoard

  attr_reader :board, :tokens, :token_count, :most_recent_token

  # @param [Token] token
  def add_token(token)

    @token_count += 1
    @most_recent_token = tokens[token.coord] = token
  end

  # @param [Integer] column
  def get_col_height(column)
    height = -1
    @tokens.each_key { |coord| height = [height, coord.height].max if coord.column == column }
    height
  end

  def full?
    @tokens.length == @board.col_count * @board.col_height
  end

  # @param [Coord] coord
  # @yieldparam [Array<Symbol> or Array<Integer>] line of token types colinear coordinate. nils possible!
  def each_colinear(coord)

    # top-left to bottom-right lines
    each_colinear_in_direction(-1, 1, coord) { |line| yield line }

    # left to right lines intersecting coord
    each_colinear_in_direction(-1, 0, coord) { |line| yield line }

    # bottom-left to top-right lines
    each_colinear_in_direction(-1, -1, coord) { |line| yield line }

    # bottom to top lines
    each_colinear_in_direction(0, -1, coord) { |line| yield line }

  end

  # @param [Integer] x either -1, 0, or 1
  # @param [Integer] y either -1, 0, or 1
  def each_colinear_in_direction(x, y, coord)
    (0...4).each do |line_offset|
      line = (0...4).collect do |element_offset|
        offset = Coord.new(x * (line_offset - element_offset),
                           y * (line_offset - element_offset))
        @tokens[coord + offset].type unless @tokens[coord + offset].nil?
      end
      yield line
    end
  end

end
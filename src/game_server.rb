require 'socket'
require_relative '../src/util/net_protocol'

require_relative '../src/model/game_config'
require_relative '../src/model/model'
require_relative '../src/model/game_type_factory'

class GameServer

  include NetProtocol

  private

  @client_socket

  @config
  @model
  @game_type


  public

  def initialize(listen_port = 4242)
    server = TCPServer.new listen_port


    yield if block_given?

    puts "Waiting on client connection on port #{listen_port}..."
    @client_socket = server.accept
    puts "Client connection accepted: #{@client_socket.addr[-1]}:#{@client_socket.addr[1]}"

    puts 'Waiting on game config...'
    config_str = recv_str(@client_socket)
    puts 'Config string received: '
    puts config_str

    begin
      @config = Marshal.load(config_str) { |parsed| raise TypeError, 'Not a GameConfig object!' unless parsed.is_a? GameConfig }
    rescue TypeError => msg
      puts 'Client sent unexpected data:'
      puts msg
      exit 1
    end

    puts "Initializing game with config:\n#{@config}"
    @game_type = GameTypeFactory.get_game_type(@config)
    @model = Model.new(@config)
    send_str(Marshal.dump(@model), @client_socket)

    # New Game Sequence now complete, enter game loop.

    puts 'Listening for client messages...'
    loop do
      break if @client_socket.closed?

      message = recv_str(@client_socket)

      process_message(message)
    end
  end

  # @param [String] message
  def process_message(message)
    exit_pattern = /exit (\d)/
    token_pattern = /token (\d) (\d) ?([TO])?/

    puts "Message received from client: #{message}"

    if message =~ exit_pattern
      exit_game(message[exit_pattern, 1].to_i)
    elsif message =~ token_pattern
      id = message[token_pattern, 1].to_i
      col = message[token_pattern, 2].to_i
      side = message[token_pattern, 3].to_sym unless message[token_pattern, 3].nil?
      place_token(col, id, side)
    else
      $stderr.puts 'Invalid command syntax!'
    end
  end

  # @param [Integer] playerID
  def exit_game(playerID)
    # TODO part 5, save game, broadcast exit to both clients, close both sockets
    send_str("exit #{playerID}", @client_socket)
    @client_socket.close
  end

  # @param [Integer] column
  # @param [Integer] playerID
  # @param [Symbol] side :T :O or nil
  def place_token(column, playerID, side = nil)
    # Make sure current player is placing
    return unless @model.is_current_player playerID

    # Make sure column is in bounds [0, col_count - 1], column has at least 1 space
    return unless column >= 0 && column < @model.board.col_count
    return unless (height = @model.get_col_height(column)) < @model.board.col_height - 1

    # Create token at column, stack height + 1
    token = @game_type.new_token(Coord.new(column, height + 1), side)

    # Add token to current player's list
    @model.current_player.tokens.push token

    # Check win condition
    @game_type.is_winner(@model.current_player.tokens)

    # Update current player
    @model.switch_player

    # Send model to clients
    send_str(Marshal.dump(@model), @client_socket)
  end

end
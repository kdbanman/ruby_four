require 'socket'
require_relative '../src/util/net_protocol'

require_relative '../src/model/game_config'
require_relative '../src/model/board'
require_relative '../src/model/game_type_factory'

class GameServer

  include NetProtocol

  private

  @client_socket

  @config
  @model
  @game_type

  @out
  @err


  public

  def initialize(listen_port = 4242, out_file = nil, err_file = nil)

    server = init_io listen_port, out_file, err_file

    yield if block_given?

    @client_socket = get_client_blocking listen_port, server

    @config = get_config_blocking
    @game_type, @model = create_game_objects(@config)

    # New Game Sequence now complete, enter game loop.

    run_game
  end

  private

  # @param [Integer] listen_port
  # @param [String] out_file
  # @param [String] err_file
  # @return [TCPServer]
  def init_io(listen_port, out_file, err_file)
    @out = out_file == nil ? $stdout : File.open(out_file, 'w')
    @err = err_file == nil ? @out : File.open(err_file, 'w')

    TCPServer.new listen_port
  end

  # @param [Integer] listen_port
  # @param [TCPServer] server
  # @return [TCPSocket]
  def get_client_blocking(listen_port, server)
    @out.puts "Waiting on client connection on port #{listen_port}..."
    client_socket = server.accept
    @out.puts "Client connection accepted: #{client_socket.addr[-1]}:#{client_socket.addr[1]}"
    client_socket
  end

  # @return [GameConfig]
  def get_config_blocking
    @out.puts 'Waiting on game config...'
    config_str = recv_str(@client_socket)
    @out.puts 'Config string received: '
    @out.puts config_str

    begin
      Marshal.load(config_str) { |parsed| raise TypeError, 'Not a GameConfig object!' unless parsed.is_a? GameConfig }
    rescue TypeError => msg
      @err.puts 'Client sent unexpected data:'
      @err.puts msg
      exit 1
    end
  end

  # @param [GameConfig] config
  # @return [Array] Multiple return [GameType, Board]
  def create_game_objects(config)
    @out.puts "Initializing game with config:\n#{@config}"
    game_type = GameTypeFactory.get_game_type(@config)
    model = Board.new(@config)
    send_str(Marshal.dump(@model), @client_socket, @err)
    [game_type, model]
  end

  def send_model
    @out.puts 'Sending model to clients...'
    send_str(Marshal.dump(@model), @client_socket, @err)
    @out.puts 'Model sent'
  end

  def run_game
    @out.puts 'Listening for client messages...'
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

    @out.puts "Message received from client: #{message}"

    if message =~ exit_pattern
      exit_game(message[exit_pattern, 1].to_i)
      return
    elsif message =~ token_pattern
      id = message[token_pattern, 1].to_i
      col = message[token_pattern, 2].to_i
      side = message[token_pattern, 3].to_sym unless message[token_pattern, 3].nil? || @config.type == :connect4
      place_token(col, id, side)
    else
      @err.puts 'Invalid command syntax!'
    end

    if @game_type.is_winner(@model.player1.tokens)
      @out.puts 'Player 1 wins'
      send_str('win 1', @client_socket, @err)
    elsif @game_type.is_winner(@model.player2.tokens)
      @out.puts 'Player 2 wins'
      send_str('win 2', @client_socket, @err)
    end

    # Send model to clients
    send_model
  end

  # @param [Integer] playerID
  def exit_game(playerID)
    # TODO part 5, save game, broadcast exit to both clients, close both sockets
    send_str("exit #{playerID}", @client_socket, @err)
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
    return unless (height = @model.get_col_height(column)) < @model.board.col_height

    # Create token at column, stack height + 1
    token = @game_type.new_token(Coord.new(column, height + 1), side)

    # Add token to current player's list
    @model.current_player.tokens.push token

    # Update current player
    @model.switch_player
  end

end
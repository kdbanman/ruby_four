require 'socket'
require_relative '../src/util/net_protocol'
require_relative '../src/controller/place_token_command'
require_relative '../src/model/game_config'
require_relative '../src/model/board'
require_relative '../src/model/game_type_factory'

class GameServer

  include NetProtocol

  private

  @client_socket

  @config
  @board
  @game_type

  @out
  @err


  public

  def initialize(listen_port = 4242, out_file = nil, err_file = nil)

    server_sock = init_io listen_port, out_file, err_file

    yield if block_given?

    @client_socket = get_client_blocking listen_port, server_sock

    @config = get_config_blocking
    @game_type, @board = create_game_objects(@config)

    send_board

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
    @out.puts "Initializing game with config:\n#{config}"
    game_type = GameTypeFactory.get_game_type(config)
    model = Board.new(config, game_type)
    [game_type, model]
  end

  def send_board
    @out.puts 'Sending model to clients...'
    send_str(Marshal.dump(@board), @client_socket, @err)
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
    @out.puts "Message received from client: #{message}"

    if message =~ @game_type::EXIT_PATTERN
      exit_game(@game_type.get_exiter(message))
      return
    elsif message =~ @game_type::TOKEN_PATTERN
      check_winner if PlaceTokenCommand.new(message, @game_type).run(@board)
    else
      @err.puts 'Invalid command syntax!'
    end

    # Send model to clients
    send_board
  end

  # @param [Integer] playerID
  def exit_game(playerID)
    # TODO part 5, save game, broadcast exit to both clients, close both sockets
    send_str("exit #{playerID}", @client_socket, @err)
    @client_socket.close
  end

  def check_winner
    puts @board.most_recent_token

    if (winner = @game_type.get_winner(@board))
      @out.puts "Player #{winner} wins"
      send_str("win #{winner}", @client_socket, @err)
    end
  end

end
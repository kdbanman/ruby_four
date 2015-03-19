require 'socket'
require_relative '../src/util/net_protocol'

require_relative '../src/model/game_config'
require_relative '../src/model/model'
require_relative '../src/model/game_type'
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
    puts "Client connection accepted: #{@client_socket}"

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

    puts 'Listening for client messages...'
    loop do
      message = recv_str(@client_socket)

      process_message(message)
    end
  end

  # @param [String] message
  def process_message(message)

    puts "Message received from client: #{message}"
    #TODO do gamey stuff, tell client about gamey stuff
  end

end
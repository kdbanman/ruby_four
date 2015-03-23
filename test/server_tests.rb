gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require_relative '../src/game_server'
require_relative '../src/util/contracted'
require_relative '../src/model/board_dimensions'
require_relative '../src/model/coord'
require_relative '../src/model/data_source'
require_relative '../src/model/game_type_factory'
require_relative '../src/model/player'
require_relative '../src/model/token'
require_relative '../src/model/game_config'

class ServerTests < Minitest::Test

  include NetProtocol

  def wrapped_server(default_port = nil)
    port = default_port || 1024 + Random.rand(60000)
    pid = nil
    GameServer.new(port) do
      sock = TCPSocket.new('localhost', port) if default_port.nil?
      pid = fork do
        yield sock
      end
    end
    Process.waitpid pid
  end

  def test_config
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy, 6, 7))
      send_str(config_str, sock)

      puts 'receiving model...'
      model = Marshal.load(recv_str(sock))

      assert_equal('steve', model.player1.name)
      assert_equal('john', model.player2.name)

      send_str("exit #{model.current_player_id}", sock)

      assert_equal('exit 1', recv_str(sock))
      sock.close
    end
  end

  def test_exit_1
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy, 10, 9))
      send_str(config_str, sock)

      model = Marshal.load(recv_str(sock))

      send_str("exit #{model.current_player_id}", sock)

      assert_equal('exit 1', recv_str(sock))
      sock.close
    end
  end

  def test_exit_2
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy, 4, 4))
      send_str(config_str, sock)

      model = Marshal.load(recv_str(sock))

      # send token command
      send_str("token #{model.current_player_id} 3", sock)

      # receive new model
      model = Marshal.load(recv_str(sock))

      # exit current player
      send_str("exit #{model.current_player_id}", sock)

      assert_equal('exit 2', recv_str(sock))
      sock.close
    end
  end


  def test_all_the_tokens
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:otto, :human, :human, 'steve', 'john', :easy, 8, 8))
      send_str(config_str, sock)

      model = Marshal.load(recv_str(sock))

      500.times do
        # send token command
        send_str("token #{model.current_player_id} #{Random.rand(8)} #{model.current_player_id == 1 ? 'T' : 'O'}", sock)

        # receive new model
        msg = recv_str(sock)
        msg = recv_str(sock) if msg =~ /win \d/
        model = Marshal.load(msg)
      end

      assert(model.player1.remaining_tokens.all? { |type| type == :O})
      assert(model.player2.remaining_tokens.all? { |type| type == :T})

      puts model.tokens

      # exit current player
      send_str('exit 2', sock)

      assert_equal('exit 2', recv_str(sock))
      sock.close
    end
  end


  def test_datasource
    config = GameConfig.new(:otto, :human, :human, 'steve', 'john', :easy, 8, 8)
    wrapped_server(config.port) do
      ds = DataSource.new config
      50.times do
        ds.place_token(ds.board.current_player_id, Random.rand(8), Random.rand(2) == 0? :T : :O)
        puts(ds.board.tokens)
      end

      assert(ds.board.player1.remaining_tokens.all? { |type| type == :O})
      assert(ds.board.player2.remaining_tokens.all? { |type| type == :T})

      # exit current player
      ds.exit_game 2
    end
  end

end
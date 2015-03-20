gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require_relative '../src/game_server'
require_relative '../src/util/contracted'
require_relative '../src/model/board'
require_relative '../src/model/coord'
require_relative '../src/model/data_source'
require_relative '../src/model/game_type_factory'
require_relative '../src/model/player'
require_relative '../src/model/token'
require_relative '../src/model/game_config'

class ServerTests < Minitest::Test

  include NetProtocol

  def wrapped_server
    port = 1024 + Random.rand(60000)
    pid = nil
    GameServer.new(port) do
      sock = TCPSocket.new('localhost', port)
      pid = fork do
        yield sock
      end
    end
    Process.waitpid pid
  end

  def test_config
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy))
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
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy))
      send_str(config_str, sock)

      model = Marshal.load(recv_str(sock))

      send_str("exit #{model.current_player_id}", sock)

      assert_equal('exit 1', recv_str(sock))
      sock.close
    end
  end

  def test_exit_2
    wrapped_server do |sock|
      config_str = Marshal.dump(GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy))
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

end
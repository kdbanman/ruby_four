gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require_relative '../src/rpc_game_server'
require_relative '../src/master_server'
require_relative '../src/SQL/mock_db_helper'
require_relative '../src/util/contracted'
require_relative '../src/model/board_dimensions'
require_relative '../src/model/coord'
require_relative '../src/model/data_source'
require_relative '../src/model/game_type_factory'
require_relative '../src/model/player'
require_relative '../src/model/token'
require_relative '../src/model/game_config'

class GameServerTests < Minitest::Test

  def wrapped_server(default_port = nil)
    port = default_port || 1024 + Random.rand(60000)
    pid = nil
    MasterServer.new(port, MockDbHelper.new) do
      sock = TCPSocket.new('localhost', port) if default_port.nil?
      pid = fork do
        yield sock
      end
    end
    Process.waitpid pid
  end

  def test_local
      config = GameConfig.new(:connect4, :human, :human, 'steve', 'john', :easy, 6, 7)


      puts 'receiving model...'

      assert_equal('steve', model.player1.name)
      assert_equal('john', model.player2.name)
  end

end
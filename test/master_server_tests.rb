gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require_relative '../src/rpc_game_server'
require_relative '../src/master_server'
require_relative '../src/SQL/mock_db_helper'

class MasterServerTests <  Minitest::Test

  def setup
    @conf_local = GameConfig.new(:connect4, :human, :human, 'bill', 'john', :easy, 6, 7)
    @conf_cpu = GameConfig.new(:connect4, :human, :computer, 'bill', 'john', :easy, 6, 7)
    @conf_remote = GameConfig.new(:connect4, :human, :remote, 'bill', nil, :easy, 6, 7)
  end

  def test_client_norpc

    master = MasterServer.new(50543, MockDbHelper.new)

    assert(master.create_user('bill', 'pass'))
    assert(master.auth_user('bill', 'pass'))
    assert(!master.auth_user('bill', 'pass2'))

    assert(!master.auth_user('john', 'pass3'))
    assert(master.create_user('john', 'pass3'))

    assert(!master.create_user('bill', 'pass2'))

    game_id = master.create_game(@conf_local, 'bill')
    assert_kind_of String, game_id


    master.shutdown
  end

end
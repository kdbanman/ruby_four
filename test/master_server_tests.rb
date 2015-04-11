gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require_relative '../src/rpc_game_server'
require_relative '../src/master_server'
require_relative '../src/SQL/mock_db_helper'

class MasterServerTests <  Minitest::Test

  def test_client_norpc
    master = MasterServer.new(50543, MockDbHelper.new)

    assert(master.create_user('bill', 'pass'))
    assert(master.auth_user('bill', 'pass'))
    assert(!master.auth_user('bill', 'pass2'))
    assert(!master.auth_user('john', 'pass'))
    assert(!master.create_user('bill', 'pass2'))
  end

end
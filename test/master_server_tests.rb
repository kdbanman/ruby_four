gem 'minitest'
require 'minitest/autorun'
require 'timeout'
require 'xmlrpc/client'
require 'xmlrpc/config'

require_relative '../src/rpc_game_server'
require_relative '../src/master_server'
require_relative '../src/SQL/mock_db_helper'
require_relative '../src/model/game_config'

PORT =  50543

class MasterServerTests <  Minitest::Test

  def setup

    @conf_local = GameConfig.new(:connect4, :human, :human, 'bill', 'john', :easy, 6, 7)
    @conf_cpu = GameConfig.new(:connect4, :human, :computer, 'bill', 'john', :easy, 6, 7)
    @conf_remote = GameConfig.new(:connect4, :human, :remote, 'bill', nil, :easy, 6, 7)
  end

  def test_client_norpc

    server = XMLRPC::Client.new( 'localhost', '/', PORT)
    master = server.proxy('master')


    game_id = master.create_game(@conf_local, 'bill')

    puts "Got game id #{game_id}"
  end

end
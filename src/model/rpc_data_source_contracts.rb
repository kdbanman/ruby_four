require 'xmlrpc/server'
require_relative '../util/contracted'
require_relative '../util/common_contracts'

module RPCDataSourceContracts

  include CommonContracts

  def is_rpc_server(obj)
    unless obj.is_a?(XMLRPC::Server)
      failure 'Object must be an rpc server'
    end
  end

  def is_rpc_proxy(obj)
    unless obj.is_a?(XMLRPC::Client::Proxy)
      failure 'Object must be an rpc proxy'
    end
  end

  def is_integers(*args)
  CommonContracts.integers(*args)
  end

  def is_token_type(type)
    CommonContracts.valid_token_type(type)
  end

  def is_ip(ip)
    CommonContracts.is_ip_addr ip
  end

  def is_board(obj)
    CommonContracts.is_board obj
  end
end
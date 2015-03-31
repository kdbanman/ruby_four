require_relative '../util/contracted'

module DbHelperContracts
  # @param [Mysql] conn
  def self.connection_not_null(conn)
     failure 'db connection must not be nil' unless conn.client_info
  end

end
require 'mysql'
require_relative '../SQL/db_helper'

conn = Mysql.new('mysqlsrv.ece.ualberta.ca', 'ece421usr2', 'a421Psn101', 'ece421grp2', 13020)

begin
  puts 'Building Datbase'

  conn.query "DROP TABLE IF EXISTS #{DBConstants::USERS}"

  conn.query "CREATE TABLE #{DBConstants::USERS}(Id INT PRIMARY KEY AUTO_INCREMENT," +
       ' Username VARCHAR(50) UNIQUE,' +
       ' Password VARCHAR(50))'

  conn.query "DROP TABLE IF EXISTS #{DBConstants::GAME_STATS}"
  conn.query "CREATE TABLE #{DBConstants::GAME_STATS}(Id INT," +
      ' Game_type varchar(15), ' +
      ' Wins INT,' +
      ' Losses INT,' +
      ' Draws INT,' +
      ' PRIMARY KEY (Id, Game_type),' +
      " FOREIGN KEY (Id) REFERENCES #{DBConstants::USERS}(Id))"

  conn.query "DROP TABLE IF EXISTS #{DBConstants::SAVED_GAMES}"
  conn.query "CREATE TABLE #{DBConstants::SAVED_GAMES}(Id INT PRIMARY KEY AUTO_INCREMENT, Game_id varchar(36), Player1 INT, Player2 INT," +
      ' data BLOB,' +
       " FOREIGN KEY (Player1) REFERENCES #{DBConstants::USERS}(Id)," +
       " FOREIGN KEY (Player2) REFERENCES #{DBConstants::USERS}(Id))"

  conn.query "INSERT INTO #{DBConstants::USERS}(Username, Password)" +
      " VALUES ('#{DBConstants::USERNAME}', '#{DBConstants::PASSWORD}')"

   puts 'Data Base built. 1 User:'
   puts "username: #{DBConstants::USERNAME}"
   puts "password: #{DBConstants::PASSWORD}"

    conn.close
rescue Mysql::Error => e
  puts e
ensure
  conn.close if conn
end
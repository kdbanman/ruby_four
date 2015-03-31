require 'mysql'
require_relative '../SQL/db_helper'

conn = Mysql.new('127.0.0.1', 'ece421usr2', 'a421Psn101', 'ece421grp2', 13020)

begin
  puts 'Building Datbase'

  conn.query "DROP TABLE IF EXISTS #{DBConstants::Users}"

  conn.query "CREATE TABLE #{DBConstants::Users}(Id INT PRIMARY KEY AUTO_INCREMENT," +
       ' Username VARCHAR(50) UNIQUE,' +
       ' Password VARCHAR(50))'

  conn.query "DROP TABLE IF EXISTS #{DBConstants::GameStats}"
  conn.query "CREATE TABLE #{DBConstants::GameStats}(Id INT," +
      ' Wins INT,' +
      ' Losses INT,' +
      ' Draws INT,' +
      ' PRIMARY KEY (Id),' +
      " FOREIGN KEY (Id) REFERENCES #{DBConstants::Users}(Id))"

  conn.query "DROP TABLE IF EXISTS #{DBConstants::SavedGames}"
  conn.query "CREATE TABLE #{DBConstants::SavedGames}(Id INT PRIMARY KEY AUTO_INCREMENT," +
      ' data BLOB)'

  conn.query "INSERT INTO #{DBConstants::Users}(Username, Password)" +
      " VALUES ('#{DBConstants::Username}', '#{DBConstants::Password}')"

   puts 'Data Base built. 1 User:'
   puts "username: #{DBConstants::Username}"
   puts "password: #{DBConstants::Password}"
rescue Mysql::Error => e
  puts e
ensure
  conn.close if conn
end
require 'mysql'

conn = Mysql.new('127.0.0.1', 'ece421usr2', 'a421Psn101', 'ece421grp2', 13020)

begin
  puts 'Building Datbase'

  Users = 'Users'
  GameStats = 'GameStats'
  SavedGames = 'SavedGames'
  Username = 'admin'
  Password = 'admin'

  conn.query "DROP TABLE IF EXISTS #{Users}"

  conn.query "CREATE TABLE #{Users}(Id INT PRIMARY KEY AUTO_INCREMENT," +
       ' Username VARCHAR(50) UNIQUE,' +
       ' Password VARCHAR(50))'

  conn.query "DROP TABLE IF EXISTS #{GameStats}"
  conn.query "CREATE TABLE #{GameStats}(Id INT," +
      ' Wins INT,' +
      ' Losses INT,' +
      ' Draws INT,' +
      ' PRIMARY KEY (Id),' +
      " FOREIGN KEY (Id) REFERENCES #{Users}(Id))"

  conn.query "DROP TABLE IF EXISTS #{SavedGames}"
  conn.query "CREATE TABLE #{SavedGames}(Id INT PRIMARY KEY AUTO_INCREMENT," +
      ' data BLOB)'

  conn.query "INSERT INTO #{Users}(Username, Password)" +
      " VALUES ('#{Username}', '#{Password}')"

   puts 'Data Base built. 1 User:'
   puts "username: #{Username}"
   puts "password: #{Password}"
rescue Mysql::Error => e
  puts e
ensure
  conn.close if conn
end
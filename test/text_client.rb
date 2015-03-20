require_relative '../src/model/model'
require_relative '../src/util/net_protocol'
require_relative '../src/game_server'
require_relative '../src/model/game_config'

include NetProtocol

PORT = 1024 + Random.rand(60000)

# Wait for game server to open server socket, then fork a client process
# to connect to the server.
GameServer.new(PORT, 'out.txt') do

  fork do
    sock = TCPSocket.new('localhost', PORT)

    puts "CLIENT: connected to server at #{sock}"

    type = :otto
    p1 = :human
    name1 = 'steve'
    p2 = :human
    name2 = 'othersteve'
    diff = :easy

    config_str = ''
    while config_str == ''
      puts 'game type? connect4 or otto'
      inp = gets.strip
      type = inp.to_sym unless inp == ''
      puts type
      puts 'player 1 human or computer?'
      inp = gets.strip
      p1 = inp.to_sym unless inp == ''
      puts p1
      puts 'player 1 name?'
      inp = gets.strip
      name1 = inp unless inp == ''
      puts name1
      puts 'player 2 human or computer?'
      inp = gets.strip
      p2 = inp.to_sym unless inp == ''
      puts p2
      puts 'player 2 name?'
      inp = gets.strip
      name2 = inp unless inp == ''
      puts name2
      puts 'difficulty easy or hard?'
      inp = gets.strip
      diff = inp.to_sym unless inp == ''
      puts diff

      begin
        config_str = Marshal.dump(GameConfig.new(type, p1, p2, name1, name2, diff))
      rescue ContractFailure => msg
        $stderr.puts msg
      end
    end

    puts ''
    send_str(config_str, sock)

    loop do
      recvd = recv_str(sock)

      if recvd =~ /exit.*/
        puts recvd
        exit 0
      elsif recvd =~ /win.*/
        puts "Player #{recvd[/win (\d)/, 1]} wins! 'exit 1' or 'exit 2' to quit."
        recvd = recv_str(sock)
      end

      begin
        model = Marshal.load(recvd)
      rescue ArgumentError => msg
        warn "ERROR: did not receive Model marshal.  Got:\n#{recvd}"
        exit 1
      end

      puts 'player 1 tokens:'
      model.player1.tokens.each { |token| puts "  #{token}" }
      puts 'player 2 tokens:'
      model.player2.tokens.each { |token| puts "  #{token}" }

      puts "current player: #{model.current_player_id}"
      puts 'command?'
      send_str(gets, sock)

      puts ''
    end

  end

end
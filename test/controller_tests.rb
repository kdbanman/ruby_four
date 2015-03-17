gem 'minitest'
require 'minitest/autorun'
require '../src/util/contracted'
require '../src/controller/computer_player'
require '../src/controller/human_player'
require '../src/controller/engine'
require '../src/controller/place_token_command'

class ControllerTests < Minitest::Test

  def test_cpu
    p = ComputerPlayer.new
  end

  def test_human
    p = HumanPlayer.new
  end

  def test_engine
    e = Engine.new
  end

  def test_token_command
    tc = PlaceTokenCommand.new
  end

end
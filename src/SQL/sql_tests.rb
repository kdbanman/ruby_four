gem 'minitest'
require 'minitest/autorun'
require_relative '../SQL/db_helper'
require_relative '../model/game_stats'

class SQLTests < Minitest::Test

  @db_helper
  @user

  def setup
    system('ruby ' + File.dirname(__FILE__) + '/./rebuild_db_schema.rb')
    @db_helper = DbHelper.new
    @user = 'Ryan'
  end

  def test_add_user
    user = 'Ryan'
    @db_helper.add_user(user, user)
    assert_equal(true, @db_helper.user_exists(user))
    user_id = @db_helper.get_user_id(user, user)
    @db_helper.delete_user user_id
    assert_equal(false, @db_helper.user_exists(user))
  end

  def test_add_win
    @db_helper.add_user(@user, @user)
    user_id = @db_helper.get_user_id(@user, @user)
    @db_helper.add_win(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(1, player_stats[0])

    @db_helper.add_win(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(2, player_stats[0])
  end

  def test_add_loss
    @db_helper.add_user(@user, @user)
    user_id = @db_helper.get_user_id(@user, @user)
    @db_helper.add_loss(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(1, player_stats[1])

    @db_helper.add_loss(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(2, player_stats[1])
  end

  def test_add_draw
    @db_helper.add_user(@user, @user)
    user_id = @db_helper.get_user_id(@user, @user)
    @db_helper.add_draw(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(1, player_stats[2])

    @db_helper.add_draw(user_id, "connect4")
    player_stats = @db_helper.get_player_stats(user_id, "connect4")
    assert_equal(2, player_stats[2])
  end

  def test_add_save_game
    user2 = 'Bob'
    game_id = '1234'
    @db_helper.add_user(@user, @user)
    user_id1 = @db_helper.get_user_id(@user, @user)

    @db_helper.add_user(user2, user2)
    user_id2 = @db_helper.get_user_id(user2, user2)

    my_obj = {'a' => 100, 'b' => 200}
    @db_helper.add_saved_game(game_id, Marshal.dump(my_obj), user_id1, user_id2)

    ret_obj = Marshal.load(@db_helper.get_saved_game(game_id))

    assert_equal(my_obj, ret_obj)
  end

  def test_get_user_name
    @db_helper.add_user(@user, @user)
    user_id = @db_helper.get_user_id(@user, @user)
    assert_equal(@user, @db_helper.get_user_name(user_id))
  end

  def test_get_all_stats
    user2 = 'Bob'
    @db_helper.add_user(@user, @user)
    user_id1 = @db_helper.get_user_id(@user, @user)

    @db_helper.add_user(user2, user2)
    user_id2 = @db_helper.get_user_id(user2, user2)

    @db_helper.add_win(user_id1, "connect4")
    @db_helper.add_win(user_id2, "otto")

    game_stat = @db_helper.get_all_stats

    assert_equal(1, game_stat.get_wins(@user, "connect4"))
    assert_equal(1, game_stat.get_wins(user2, "otto"))

  end

  def test_update_saved_game
    user2 = 'Bob'
    game_id = '1234'
    @db_helper.add_user(@user, @user)
    user_id1 = @db_helper.get_user_id(@user, @user)

    @db_helper.add_user(user2, user2)
    user_id2 = @db_helper.get_user_id(user2, user2)

    my_obj = {'a' => 100, 'b' => 200}
    @db_helper.add_saved_game(game_id, Marshal.dump(my_obj), user_id1, user_id2)

    ret_obj = Marshal.load(@db_helper.get_saved_game(game_id))

    assert_equal(my_obj, ret_obj)

    my_obj = {'a' => 200, 'b' => 200}
    @db_helper.update_saved_game(game_id, Marshal.dump(my_obj))

    ret_obj = Marshal.load(@db_helper.get_saved_game(game_id))
    assert_equal(my_obj, ret_obj)

  end

  def test_delete_saved_game
    user2 = 'Bob'
    game_id = '1234'
    @db_helper.add_user(@user, @user)
    user_id1 = @db_helper.get_user_id(@user, @user)

    @db_helper.add_user(user2, user2)
    user_id2 = @db_helper.get_user_id(user2, user2)

    my_obj = {'a' => 100, 'b' => 200}
    @db_helper.add_saved_game(game_id, Marshal.dump(my_obj), user_id1, user_id2)

    @db_helper.delete_saved_game game_id

    begin
      ret_obj = Marshal.load(@db_helper.get_saved_game(game_id))
      assert_equal(my_obj, ret_obj)
      failure
    rescue
      #passed
    end
  end

end
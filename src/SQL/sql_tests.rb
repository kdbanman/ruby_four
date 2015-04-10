gem 'minitest'
require 'minitest/autorun'
require_relative '../SQL/db_helper'

class SQLTests < Minitest::Test

  @db_helper

  def setup
    @db_helper = DbHelper.new
  end

  def test_add_user
    user = 'Ryan'
    #@db_helper.add_user(user, user)
    assert_equal(true, @db_helper.user_exists(user))
  end

  def test_add_win

  end


end
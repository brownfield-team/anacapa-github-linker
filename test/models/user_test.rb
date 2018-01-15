require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "user count" do
    assert_equal 2, User.count
  end   
end

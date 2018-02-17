require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    # @course = courses(:course1)
    # @roster_student = roster_students(:roster1)
    @user = users(:wes)
    @user.add_role(:admin)
    @user2 = users(:tim)
    @user2.add_role(:user)
    # sign_in @user
  end

  # test "the truth" do
  #   assert true
  # end
  test "user count" do
    assert_equal 2, User.count
  end

  test "get role" do
    assert_equal "admin", @user.get_role
  end

  test "reassign role, promote Tim from a user -> instructor" do
    @user2.reassign_role("instructor")
    assert_equal "instructor", @user2.get_role
  end
end

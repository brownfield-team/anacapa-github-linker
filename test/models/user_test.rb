require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    # @course = courses(:course1)
    # @roster_student = roster_students(:roster1)
    @user = users(:wes)
    @user.add_role(:admin)
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
end

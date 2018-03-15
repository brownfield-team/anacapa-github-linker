require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @course = courses(:course1)
    @course2 = courses(:course2)
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
    assert_equal 3, User.count
  end

  test "if user is admin, change_admin_status should remove admin role" do
    @user.change_admin_status
    assert_not (@user.has_role? :admin)
  end

  test "if user is not admin, change_admin_status should add admin role" do
    @user2.change_admin_status
    assert (@user.has_role? :admin)
  end

  test "if user is ta, change_ta_status should remove ta role" do
    @user.add_role :ta, @course
    @user.change_ta_status(@course)
    assert_not (@user.has_role? :ta, @course)
  end

  test "if user is not ta, change_ta_status should add ta role" do
    @user.change_ta_status(@course)
    assert (@user.has_role? :ta, @course)
  end

  test "A TA for one course should not be a TA for a different one" do
    @user.add_role :ta, @course
    assert (@user.has_role? :ta, @course) 
    assert_not (@user.has_role? :ta, courses(:course2))

  end

  test "if user is instructor, change_instructor_status should remove instructor role" do
    @user.add_role :instructor
    @user.change_instructor_status
    assert_not (@user.has_role? :instructor)
  end

  test "if user is not instructor, change_instructor_status should add instructor role" do
    @user.change_instructor_status
    assert (@user.has_role? :instructor)
  end


  test "a user should still have TA status if still a TA of at least one class" do
    @user.add_role :ta, @course
    @user.add_role :ta, @course2
    @user.change_ta_status(@course2)

    assert @user.has_role? :ta, @course
    assert_not @user.has_role? :ta, @course2
  end

  test "A user should no longer be a TA if he is not a TA of any course" do
    @user.add_role :ta, @course
    @user.change_ta_status(@course)

    assert_not @user.has_role? :ta, @course
  end

end

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

  # test "the truth" do
  #   assert true
  # end

  setup do
    @user = users(:wes)
    @user.add_role(:admin)
    @user2 = users(:tim)
    @user2.add_role(:user)
    users(:julie).add_role(:user)
    sign_in @user
  end

  test "access granted for users index" do
  	get users_url
  	assert_response :success
  end

  test "should update users by making user an admin" do
  	patch user_url(@user2), params: {commit: "Admin"}
    assert @user2.has_role? :admin
    assert_redirected_to users_url

  end

  test "should update users by making user an instructor" do
    patch user_url(@user2), params: {commit: "Instructor"}
    assert @user2.has_role? :instructor
    assert_redirected_to users_url

  end

  test "access denied for users index" do 
  	sign_in @user2
  	get users_url
  	assert_redirected_to root_path
  end
end

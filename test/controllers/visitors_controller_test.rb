require 'test_helper'

class VisitorsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  include Devise::Test::IntegrationHelpers
  
  test "homepage should return 200 success" do
    get root_url
    assert_response :success
  end

  test "courses page requires login" do
    get courses_url
    assert_redirected_to new_user_session_url
  end

  test "when you are logged in you can see the courses page" do
    # sign in here
    @user = users(:tim)
    @user.add_role(:admin)
    sign_in @user
    get courses_url
    assert_response :success
  end

end

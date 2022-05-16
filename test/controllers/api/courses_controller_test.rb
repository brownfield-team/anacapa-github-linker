require 'test_helper'
require 'helpers/octokit_stub_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include OctokitStubHelper

  setup do
    @course = courses(:course1)
    @course2 = courses(:course2)
    @user = users(:tim)
    @roster_student = roster_students(:roster2)
    sign_in @user
  end

#   test "should get index for student" do
#     @user.remove_role(:admin)
#     @user.add_role(:student)
#     get "/api/courses/"
#     assert_response :success
#     assert_equal @course, @response.body
#   end

#   test "should get index for student instructor" do
#     @user.add_role(:student)
#     @user.add_role(:instructor)
#     get "/api/courses/"
#     assert_response :success
#     assert_equal @course, @response.body
#   end

  test "should get index for admin" do
    @user.add_role(:admin)
    get "/api/courses"
    assert_response :success
    assert_equal [@course, @course2].to_json, @response.body
  end

end
# require 'test_helper'

# class AssignmentsControllerTest < ActionDispatch::IntegrationTest
#   include Devise::Test::IntegrationHelpers

#   setup do
#     @assignment = assignments(:one)
#     @course = courses(:course1)
#     @user = users(:wes)
#     @user.add_role(:admin)
#     sign_in @user
#   end

#   test "should get index" do
#     get course_assignments_url(@course)
#     assert_response :success
#   end

#   test "should get new" do
#     get new_course_assignment_url(@course)
#     assert_response :success
#   end

#   # test "should create assignment" do
#   #   assert_difference('Assignment.count') do
#   #     post course_assignments_url, params: { assignment: { course_id: @assignment.course_id, name: @assignment.name } }
#   #   end

#   #   assert_redirected_to course_assignment_url(Assignment.last)
#   # end

#   # test "should show assignment" do
#   #   get course_assignment_url(@assignment)
#   #   assert_response :success
#   # end

#   # test "should get edit" do
#   #   get edit_course_assignment_url(@assignment)
#   #   assert_response :success
#   # end

#   # test "should update assignment" do
#   #   patch course_assignment_url(@assignment), params: { assignment: { course_id: @assignment.course_id, name: @assignment.name } }
#   #   assert_redirected_to course_assignment_url(@assignment)
#   # end

#   # test "should destroy assignment" do
#   #   assert_difference('Assignment.count', -1) do
#   #     delete course_assignment_url(@assignment)
#   #   end

#   #   assert_redirected_to course_assignments_url
#   # end
# end

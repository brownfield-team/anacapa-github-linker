require 'test_helper'

class SprintsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @course = courses(:course1)
    @sprint = sprints(:sprint1)
    @admin = users(:wes)
    @admin.add_role(:admin)
    @instructor = users(:tim)
    @instructor.add_role(:julie)
    @nopriv = users(:julie)
  end

  test "should get index" do
    sign_in @instructor
    get course_sprints_url(@course)
    assert_response :success
  end

  test "should not get index" do
    sign_in @nopriv
    get course_sprints_url(@course)
    assert_redirected_to root_path
  end

  test "should get new" do
    sign_in @instructor
    get new_course_sprint_url(@course)
    assert_response :success
  end

  test "should create sprint" do
    sign_in @instructor
    assert_difference('Sprint.count') do
      post course_sprints_url(@course), params: { sprint: { course_id: @sprint.course_id, end_date: @sprint.end_date, name: @sprint.name, start_date: @sprint.start_date } }
    end

    assert_redirected_to edit_course_url(@course)
  end

  test "should show sprint" do
    sign_in @instructor
    get course_sprint_url(@course, @sprint)
    assert_response :success
  end

  test "should get edit" do
    sign_in @instructor
    get edit_course_sprint_url(@course, @sprint)
    assert_response :success
  end

  test "should update sprint" do
    sign_in @instructor
    patch course_sprint_url(@course, @sprint), params: { sprint: { course_id: @sprint.course_id, end_date: @sprint.end_date, name: @sprint.name, start_date: @sprint.start_date } }
    assert_response :success
  end

  test "should destroy sprint" do
    sign_in @instructor
    assert_difference('Sprint.count', -1) do
      delete course_sprint_url(@course, @sprint)
    end

    assert_redirected_to edit_course_url(@course)
  end
end

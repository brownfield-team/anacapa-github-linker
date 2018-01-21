require 'test_helper'

class RosterStudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roster_student = roster_students(:roster1)
  end

  test "should get index" do
    get :index, :course_id=>1
    assert_response :success
  end

  test "should get new" do
    get new_roster_student_url
    assert_response :success
  end

  test "should create roster_student" do
    assert_difference('RosterStudent.count') do
      post roster_students_url, params: { roster_student: { email: @roster_student.email, first_name: @roster_student.first_name, last_name: @roster_student.last_name, perm: @roster_student.perm } }
    end

    assert_redirected_to roster_student_url(RosterStudent.last)
  end

  test "should show roster_student" do
    get roster_student_url(@roster_student)
    assert_response :success
  end

  test "should get edit" do
    get edit_roster_student_url(@roster_student)
    assert_response :success
  end

  test "should update roster_student" do
    patch roster_student_url(@roster_student), params: { roster_student: { email: @roster_student.email, first_name: @roster_student.first_name, last_name: @roster_student.last_name, perm: @roster_student.perm } }
    assert_redirected_to roster_student_url(@roster_student)
  end

  test "should destroy roster_student" do
    assert_difference('RosterStudent.count', -1) do
      delete roster_student_url(@roster_student)
    end

    assert_redirected_to roster_students_url
  end
end

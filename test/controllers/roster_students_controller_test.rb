require 'test_helper'

class RosterStudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @roster_student = roster_students(:roster1)
  end

  # test "should get index" do
  #   get :index ,:course_id=> 1
  #   assert_response :success
  # end

  test "should get new" do
    get new_course_roster_student_path(:course_id=> 1) 
    assert_response :success
  end

  test "should create roster_student" do
    assert_difference('RosterStudent.count') do
      post course_roster_students_path(:course_id=>1, params: { roster_student: { email: @roster_student.email, first_name: @roster_student.first_name, last_name: @roster_student.last_name, perm: @roster_student.perm } })
    end

    assert_redirected_to course_roster_student_path(RosterStudent.last)
  end

  test "should show roster_student" do
    get course_roster_student_path(:course_id=> @roster_student.course_id, :id=> @roster_student.id)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_roster_student_path(:course_id=> @roster_student.course_id, :id=> @roster_student.id)
    assert_response :success
  end

  test "should update roster_student" do
    patch course_roster_student_path(:course_id=> @roster_student.course_id, :id=> @roster_student.id, params: { roster_student: { email: @roster_student.email, first_name: @roster_student.first_name, last_name: @roster_student.last_name, perm: @roster_student.perm } })
    assert_redirected_to course_roster_student_path(:course_id=> @roster_student.course_id, :id=> @roster_student.id)
  end

  test "should destroy roster_student" do
    assert_difference('RosterStudent.count', -1) do
      course_roster_student_path(:course_id=> @roster_student.course_id, :id=> @roster_student.id, method: :delete)
    end

    assert_redirected_to roster_students_url
  end
end

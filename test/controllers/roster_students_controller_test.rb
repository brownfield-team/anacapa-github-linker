require 'test_helper'

class RosterStudentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @course = courses(:course1)
    @roster_student = roster_students(:roster1)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user
  end

  test "should get new" do
    get new_course_roster_student_path(:course_id=> @course.id)
    assert_response :success
  end

  test "should create roster_student" do
    assert_difference('RosterStudent.count',1) do
      post course_roster_students_path(
        course_id: @course.id,
        params: {
          roster_student: {
            email: @roster_student.email,
            first_name: @roster_student.first_name,
            last_name: @roster_student.last_name,
            perm: @roster_student.perm
          }
        }
      )
    end

    assert_redirected_to course_path(@course)
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
    patch course_roster_student_path(
      :course_id=> @roster_student.course_id,
      :id=> @roster_student.id,
      params: {
        roster_student: {
          email: @roster_student.email,
          first_name: @roster_student.first_name,
          last_name: @roster_student.last_name,
          perm: @roster_student.perm
        }
      }
    )
    assert_redirected_to course_path(@roster_student.course_id)
  end

  test "should destroy roster_student" do
    assert_difference('RosterStudent.count', -1) do
      delete course_roster_student_path(@roster_student.course_id, @roster_student.id)
    end

    assert_redirected_to course_path(@roster_student.course_id)
  end
end

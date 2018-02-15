require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @course = courses(:course1)
    @course2 = courses(:course2)
    @student_user = users(:tim)
    @roster_student = roster_students(:roster_student_tim)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    skip "Work in progress (Github integration)"
    assert_difference('Course.count') do
      post courses_url, params: { course: { name: "test course", course_organization: "test org" } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    skip "Work in progress (Github integration)"
    patch course_url(@course), params: { course: { name: @course.name } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end


  test "user can join class if roster student exists" do
    skip "Can't figure out how to call join method on controller via route"
    sign_in @student_user
    puts "roster student count (of class): #{@course.roster_students.count}"
    puts "#{@student_user.email}"
    puts "#{@roster_student.email}"
    # assert_difference('@student_user.roster_students.count', 1) do
    #   # post course_join_url, params: { course: { course_id: @course.course_id}  }
    #   post course_join_url(:course_id=> @course.id)
    #   # @student_user.roster_students << @roster_student
    # end
    post course_join_url(:course_id=> @course.id)
    assert_redirected_to courses_url
    assert_equal "You were successfully enrolled in #{@course.name}!", flash[:notice]
  end

  test "roster student can NOT join class if NOT on class roster" do
    skip "Can't figure out how to call join method on controller via route"
  end

  test "roster student can leave class" do
    skip "Can't figure out how to call join method on controller via route"
  end
end

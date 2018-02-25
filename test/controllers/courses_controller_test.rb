require 'test_helper'
require 'helpers/octokit_stub_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include OctokitStubHelper
  
  setup do
    @org = "test-org-name"
    @course = courses(:course1)
    @course2 = courses(:course2)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user
    stub_organization_membership_admin_in_org(@org, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(@org)
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
    # skip "Work in progress (Github integration)"
    
    assert_difference('Course.count', 1) do
      post courses_url, params: { course: { name: "blah", course_organization: "#{@org}" } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "if org doesn't exist course should not be created and show why" do 
    skip "work in progress"
    fake_org_name = "not-a-real-org"
    stub_organization_does_not_exist(fake_org_name)
    assert_difference('Course.count', 0) do
      post courses_url, params: { course: { name: "blah", course_organization: fake_org_name } }
    end

    assert_redirected_to courses_url
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
    stub_organization_membership_admin_in_org(@course.course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(@course.course_organization)
    patch course_url(@course), params: { course: { name: "patched_course_name" } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end


  test "user can join class if roster student exists" do

    assert_difference('@user.roster_students.count', 1) do
      post course_join_path(course_id: @course.id)

    end
    assert_redirected_to courses_url
    assert_equal "You were successfully enrolled in #{@course.name}!", flash[:notice]
  end

  test "roster student can NOT join class if NOT on class roster" do
    user_julie = users(:julie)
    sign_in user_julie
    user_julie.add_role(:user)

    assert_difference('user_julie.roster_students.count', 0) do
      post course_join_path(course_id: @course.id)
    end

    assert_redirected_to courses_url
    assert_equal "Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verrified your email address. ", flash[:alert]

  end

  test "roster student can leave class" do
    
    @course.roster_students.push(roster_students(:roster1))
    @user.roster_students.push(roster_students(:roster1))

    assert_difference('@user.roster_students.count', -1) do
        post course_leave_path(course_id: @course.id)
    end

    assert_redirected_to courses_url
  end
end

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
    @roster_student = roster_students(:roster1)
    sign_in @user
    stub_organization_membership_admin_in_org(@org, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(@org)
    @enroll_success_flash_notice = %Q[You were successfully enrolled in #{@course.name}! View you invitation <a href="https://github.com/orgs/#{@course.course_organization}/invitation">here</a>.]
  end

  test "should get index" do

    get courses_url
    assert_response :success
  end

  test "should get view_ta" do
    get course_view_ta_path(@course)
    assert_response :success
  end

  test "update_ta should update ta status of user" do
    user_julie = users(:julie)
    user_julie.add_role(:user)

    post course_update_ta_path(@course, user_id: user_julie.id )
    assert user_julie.has_role? :ta, @course
    assert_redirected_to course_view_ta_path(@course)
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    stub_updating_org_membership("#{@org}")
    assert_difference('Course.count', 1) do
      post courses_url, params: { course: { name: "blah", course_organization: "#{@org}" } }
    end

    assert_redirected_to course_url(Course.last)
  end


  test "if org doesn't exist course should not be created and show why" do 
    fake_org_name = "not-a-real-org"
    stub_organization_does_not_exist(fake_org_name)
    assert_difference('Course.count', 0) do
      post courses_url, params: { course: { name: "blah", course_organization: fake_org_name } }
    end

    assert_response :ok
    assert_select 'div#error_explanation li', "You must create a github organization with the name of your class and add #{ENV['MACHINE_USER_NAME']} as an owner of that organization."
  end

  test "if org exists but machine user is not admin, should not be created and show why" do
    org_name = "real-org"
    stub_organization_is_an_org(org_name)
    stub_organization_exists_but_not_admin_in_org(org_name)
    assert_difference('Course.count', 0) do
      post courses_url, params: {course: { name: "name", course_organization: org_name}}
    end

    assert_response :ok
    assert_select 'div#error_explanation li', "You must add #{ENV['MACHINE_USER_NAME']} to your organization before you can proceed."

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

  test "user will not be reinvited if already in org" do
    stub_find_user_in_org(@user.username, @course.course_organization, true)
    assert_difference('@user.roster_students.count', 1) do
      post course_join_path(course_id: @course.id)

    end
    assert_redirected_to courses_url
    assert_equal @enroll_success_flash_notice, flash[:notice]
  end

  test "user can join class if roster student exists" do
    stub_find_user_in_org(@user.username, @course.course_organization, false)
    stub_invite_user_to_org(@user.username, @course.course_organization)
    assert_difference('@user.roster_students.count', 1) do
      post course_join_path(course_id: @course.id)
    end
    assert_redirected_to courses_url
    assert_equal @enroll_success_flash_notice, flash[:notice]
  end

  test "roster student can NOT join class if NOT on class roster" do
    user_julie = users(:julie)
    sign_in user_julie
    user_julie.add_role(:user)

    assert_difference('@course.roster_students.count', 0) do
      assert_difference('user_julie.roster_students.count', 0) do
        post course_join_path(course_id: @course.id)
      end
    end

    assert_redirected_to courses_url
    assert_equal "Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verrified your email address. ", flash[:alert]

  end

  test "roster student can leave class" do
    
    @course.roster_students.push(roster_students(:roster1))
    @user.roster_students.push(roster_students(:roster1))

    assert_difference('@user.roster_students.count', 0) do
      assert_difference('@course.roster_students.count', 0) do
        assert_difference('@course.roster_students.where(enrolled: true).count',-1) do
          post course_leave_path(course_id: @course.id)
        end
      end
    end

    assert_redirected_to courses_url
  end

  test "instructors should be able to create courses" do
    user = users(:julie)
    user.add_role(:instructor)
    sign_in user

    stub_updating_org_membership("#{@org}")
    assert_difference('Course.count', 1) do
      post courses_url, params: { course: { name: "blah", course_organization: "#{@org}" } }
    end

    assert_redirected_to course_url(Course.last)

  end

  test "instructors should be able to update courses that they created" do
    user = users(:julie)
    user.add_role(:instructor)
    sign_in user

    stub_updating_org_membership("#{@org}")
    assert_difference('Course.count', 1) do
      post courses_url, params: { course: { name: "blah", course_organization: "#{@org}" } }
    end

    course = Course.where(name: "blah").first

    stub_organization_membership_admin_in_org(@course.course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(@course.course_organization)
    patch course_url(course), params: { course: { name: "patched_course_name" } }
    
    assert_redirected_to course_url(course)
    assert_equal "patched_course_name", Course.where(course_organization: "#{@org}").first.name

  end

  test "instructors should not be able to update other instructors courses" do
    @user = users(:julie)
    @user.add_role(:instructor, @course2)
    sign_in @user

    stub_organization_membership_admin_in_org(@course.course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(@course.course_organization)
    patch course_url(@course), params: { course: { name: "patched_course_name" } }
    assert_redirected_to root_url


  end

  test "TAs should not be able to create new roster_students" do
    @user = users(:julie)
    @user.add_role :ta, @course
    sign_in @user

    post course_roster_students_path(
        course_id: @course.id,
        params: {
          roster_student: {
            email: "email@test.email.com",
            first_name: "Jon",
            last_name: "Snow",
            perm: 293847823795
          }
        }
      )
    assert_redirected_to root_url
  end

  test "TAs should not be allowed to delete roster_students" do
    @user = users(:julie)
    @user.add_role :ta, @course
    sign_in @user

    assert_difference('RosterStudent.count', 0) do
      delete course_roster_student_path(@roster_student.course_id, @roster_student.id)
    end

    assert_redirected_to root_url
  end

  test "TAs should not be able to view other courses they are not the TA of " do
    @user = users(:julie)
    @user.add_role :ta, @course
    sign_in @user
    

    get course_url(@course)
    assert_redirected_to root_url
  end

  test "TAs should not have access to the Manage TAs page" do
    @user = users(:julie)
    @user.add_role :ta, @course
    sign_in @user

    get course_view_ta_path(@course)
    assert_redirected_to root_url

  end



end

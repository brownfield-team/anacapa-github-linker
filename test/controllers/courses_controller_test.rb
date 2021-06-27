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
    @enroll_success_flash_notice = %Q[You were successfully invited to #{@course.name}! View and accept your invitation <a href="https://github.com/orgs/#{@course.course_organization}/invitation">here</a>.]
  end

  test "should get index" do

    get courses_url
    assert_response :success
  end

  test "should get show jobs" do
    get course_jobs_path(@course)
    assert_response :success
  end

  test "instructors should be able to see the add course button" do
    users(:tim).add_role(:instructor)
    sign_in users(:tim)

    get courses_url
    assert_response :success
    assert_select 'p.js-new-course a[href=?]', new_course_path
  end

  test "noninstructors should not be able to see the add course button" do
    users(:tim).add_role(:user)
    sign_in users(:tim)

    get courses_url
    assert_response :success
    assert_select 'p.js-new-course a[href=?]', new_course_path, count:0
  end

  test "update_ta should update ta status of user" do
    user_julie = users(:julie)
    user_julie.add_role(:user)
    student_julie = RosterStudent.create(user: user_julie, course: @course, perm: 0, email: "julie@example.com")
    post course_update_ta_path(@course, student_id: student_julie.id )
    assert user_julie.has_role? :ta, @course
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    stub_updating_org_membership("#{@org}")
    assert_difference('Course.count', 1) do
      post courses_url, params: { course: { name: "blah", term: "blah_term", course_organization: "#{@org}" } }
    end

    assert_redirected_to course_url(Course.last)
    assert_equal Course.last.name, "blah" 
    assert_equal Course.last.term, "blah_term" 
    assert_equal Course.last.course_organization, "#{@org}" 
  end


  test "if org doesn't exist, course should not be created and show why" do
    fake_org_name = "not-a-real-org"
    stub_organization_does_not_exist(fake_org_name)
    assert_difference('Course.count', 0) do
      post courses_url, params: { course: { name: "blah", term: "term", course_organization: fake_org_name } }
    end

    assert_response :ok
    assert_select 'div#error_explanation li', "You must create a github organization with the name of your class and add #{ENV['MACHINE_USER_NAME']} as an owner of that organization."
  end

  test "if org exists but machine user is not admin, should not be created and show why" do
    org_name = "real-org"
    stub_organization_is_an_org(org_name)
    stub_organization_exists_but_not_admin_in_org(org_name)
    assert_difference('Course.count', 0) do
      post courses_url, params: {course: { name: "name", term: "term", course_organization: org_name}}
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

  test "should update course name" do
    new_course_name = 'new_course_name'
    course_organization = "course_org"

    stub_organization_membership_admin_in_org(course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(course_organization)

    course = Course.create(name: "old course name", term: "old course term", course_organization: course_organization, hidden: false)
    assert_nil Course.find_by(name: new_course_name)

    patch course_url(course), params: { course: { name: new_course_name } }

    assert_not_nil Course.find_by(name: new_course_name)
    assert_redirected_to course_url(course)
  end

  test "should update course term" do
    new_course_term = 'new_course_term'
    course_organization = "course_org"

    stub_organization_membership_admin_in_org(course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(course_organization)

    course = Course.create(name: "old course name", term: "old course term", course_organization: course_organization, hidden: false)
    assert_nil Course.find_by(term: new_course_term)

    patch course_url(course), params: { course: { term: new_course_term } }

    assert_not_nil Course.find_by(term: new_course_term)
    assert_redirected_to course_url(course)
  end

  test "should update course start and end dates" do
    new_course_start_date = '2021-09-23'
    new_course_end_date = '2021-12-20'
    course_organization = "course_org"

    stub_organization_membership_admin_in_org(course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(course_organization)

    course = Course.create(name: "old course name", term: "old course term", course_organization: course_organization, start_date: "2021-08-23", end_date: "2021-12-10", hidden: false)
    assert_nil Course.find_by(start_date: new_course_start_date, end_date: new_course_end_date)

    patch course_url(course), params: { course: { start_date: new_course_start_date, end_date: new_course_end_date } }

    assert_not_nil Course.find_by(start_date: new_course_start_date, end_date: new_course_end_date)
    assert_redirected_to course_url(course)
  end

  def test_update_should_hide_course
    course_name = 'fake course_name'
    course_organization = "course_org"

    stub_organization_membership_admin_in_org(course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(course_organization)

    assert_nil Course.find_by(name: course_name)
    course = Course.create(name: course_name, course_organization: course_organization, hidden: false)

    patch course_url(course), params: { course: { hidden: 1 } }

    after = Course.find_by(name: course_name)
    assert_not_nil after
    assert after.hidden

    get courses_url
    assert_response :ok
  end

  def test_update_should_unhide_course
    course_name = 'fake course_name'
    course_organization = "course_org"

    stub_organization_membership_admin_in_org(course_organization, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(course_organization)

    assert_nil Course.find_by(name: course_name)
    course = Course.create(name: course_name, course_organization: course_organization, hidden: false)

    patch course_url(course), params: { course: { hidden: 0 } }

    after = Course.find_by(name: course_name)
    assert_not_nil after
    refute after.hidden

    get root_url
    assert_response :ok
    assert response.body.scan(course_name).count > 0
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end

  test "user will not be reinvited if already in org" do

    stub_find_user_in_org(@user.username, @course.course_organization, true)
    stub_check_user_emails(@user.email)
    assert_difference('@user.roster_students.count', 1) do
      post course_join_path(course_id: @course.id)

    end
    assert_redirected_to courses_url
    assert_equal @enroll_success_flash_notice, flash[:notice]
  end

  test "user can join class if roster student exists" do

    stub_find_user_in_org(@user.username, @course.course_organization, false)
    stub_invite_user_to_org(@user.username, @course.course_organization)
    stub_check_user_emails(@user.email)
    assert_difference('@user.roster_students.count', 1) do
      post course_join_path(course_id: @course.id)
    end
    assert_redirected_to courses_url
    assert_equal @enroll_success_flash_notice, flash[:notice]
  end


  test "user can join class even if case of email doesn't match" do

    user = @user
    sign_in user
    course = courses(:course2)

    stub_find_user_in_org(user.username, course.course_organization, false)
    stub_invite_user_to_org(user.username, course.course_organization)
    stub_check_user_emails(user.email)
    assert_difference('user.roster_students.count', 1) do
      post course_join_path(course_id: course.id)
    end
    assert_redirected_to courses_url
    enroll_success_flash_notice = %Q[You were successfully invited to #{course.name}! View and accept your invitation <a href="https://github.com/orgs/#{course.course_organization}/invitation">here</a>.]
    assert_equal enroll_success_flash_notice, flash[:notice]
  end

  test "roster student can NOT join class if NOT on class roster" do

    user_julie = users(:julie)
    sign_in user_julie
    user_julie.add_role(:user)
    stub_check_user_emails(user_julie.email)
    assert_difference('@course.roster_students.count', 0) do
      assert_difference('user_julie.roster_students.count', 0) do
        post course_join_path(course_id: @course.id)
      end
    end

    assert_redirected_to courses_url
    assert_equal "Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verified your email address. ", flash[:alert]

  end


  test "an instructor should be able to promote a roster student to a TA" do
    user_julie = users(:julie)
    user_julie.add_role(:user)
    student_julie = RosterStudent.create(user: user_julie, course: @course, perm: 0, email: "julie@example.com")

    user = users(:tim)
    user.add_role(:instructor)
    user.add_role(:instructor, @course)
    sign_in user

    post course_update_ta_path(@course, student_id: student_julie.id )
    assert user_julie.has_role? :ta, @course
  end

  test "an instructor cannot promote a roster student to TA if the student is from a different course" do
    user_julie = users(:julie)
    user_julie.add_role(:user)
    student_julie = RosterStudent.create(user: user_julie, course: @course, perm: 0, email: "julie@example.com")

    user = users(:tim)
    user.add_role(:instructor)
    user.add_role(:instructor, @course2)
    sign_in user

    post course_update_ta_path(@course, student_id: student_julie.id )
    assert_not user_julie.has_role? :ta, @course
    assert_redirected_to root_url
  end

  test "an instructor should be able to remove TA status from a roster student" do
    user_julie = users(:julie)
    user_julie.add_role(:user)
    user_julie.add_role(:ta, @course)
    student_julie = RosterStudent.create(user: user_julie, course: @course, perm: 0, email: "julie@example.com")

    user = users(:tim)
    user.add_role(:instructor)
    user.add_role(:instructor, @course)
    sign_in user

    post course_update_ta_path(@course, student_id: student_julie.id )
    assert_not user_julie.has_role? :ta, @course
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

  test "instructors should be allowed to delete their own courses" do
    @user = users(:julie)
    @user.add_role(:user)
    @user.add_role(:instructor)
    @user.add_role(:instructor, @course2)
    sign_in @user

    assert_difference('Course.count', -1) do
      delete course_url(@course2)
    end

    assert_redirected_to courses_url
  end

  test "instructors should not be able to delete other instructors courses" do
    @user = users(:julie)
    @user.add_role(:instructor, @course2)
    sign_in @user

    assert_difference('Course.count', 0) do
      delete course_url(@course)
    end

    assert_redirected_to root_url
  end

  test "users should not be able to delete any courses" do
    @user = users(:julie)
    @user.add_role(:user)
    sign_in @user

    assert_difference('Course.count', 0) do
      delete course_url(@course)
    end

    assert_redirected_to root_url
  end


  test "TAs should be able to view courses that they are TA of" do
    @user = users(:julie)
    @user.add_role :user
    @user.add_role :ta, @course
    sign_in @user

    get course_path(@course)
    assert_response :success
  end

  test "TAs should not be able to view other courses they are not the TA of " do
    @user = users(:julie)
    @user.add_role :user
    @user.add_role :ta, @course
    sign_in @user

    get course_url(@course2)
    assert_redirected_to root_url
  end

  test "TAs should not be able to promote a roster student to a TA" do
    @user = users(:julie)
    @user.add_role :user
    @user.add_role :ta, @course
    sign_in @user

    tim = users(:tim)
    tim.add_role(:user)

    post course_update_ta_path(@course, user_id: tim.id )
    assert_not tim.has_role? :ta, @course
    assert_redirected_to root_url

  end

  test "TAs should not be allowed to delete courses" do
    @user = users(:julie)
    @user.add_role :user
    @user.add_role :ta, @course
    sign_in @user

    assert_difference('Course.count', 0) do
      delete course_url(@course)
    end

    assert_redirected_to root_url
  end



end

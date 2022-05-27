require 'test_helper'
require 'helpers/octokit_stub_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include OctokitStubHelper

  setup do
    @course = courses(:course1)
    @course2 = courses(:course2)
  end

  test "should get index for student" do
    studentUser = FactoryBot.create(:user, :student)
    instructor = FactoryBot.create(:user, :instructor)
    sign_in studentUser
    newCourse = FactoryBot.create(:course, instructor: instructor)
    FactoryBot.create(:roster_student, course: newCourse, user: studentUser)
    get "/api/courses/"
    assert_response :success
    assert_equal newCourse.id, JSON.parse(response.body)[0]["id"]
    assert_equal false, JSON.parse(response.body)[0]["can_control"]
    assert_equal 1, JSON.parse(response.body).length
  end

  test "should get index for instructor" do
    instructor = FactoryBot.create(:user, :instructor)
    sign_in instructor
    newCourse = FactoryBot.create(:course, instructor: instructor)
    get "/api/courses/"
    assert_response :success
    assert_equal newCourse.id, JSON.parse(response.body)[0]["id"]
    assert_equal true, JSON.parse(response.body)[0]["can_control"]
    assert_equal 1, JSON.parse(response.body).length
  end

  test "should get index for student instructor" do
    instructor = FactoryBot.create(:user, :instructor)
    instructor2 = FactoryBot.create(:user, :instructor)
    sign_in instructor
    newCourse = FactoryBot.create(:course, instructor: instructor)
    newCourse2 = FactoryBot.create(:course, instructor: instructor2)
    FactoryBot.create(:roster_student, course: newCourse2, user: instructor)
    get "/api/courses/"
    assert_response :success
    assert_equal newCourse2.id, JSON.parse(response.body)[0]["id"]
    assert_equal false, JSON.parse(response.body)[0]["can_control"]
    assert_equal newCourse.id, JSON.parse(response.body)[1]["id"]
    assert_equal true, JSON.parse(response.body)[1]["can_control"]
    assert_equal 2, JSON.parse(response.body).length
  end

  test "should get index for admin" do
    adminUser = FactoryBot.create(:user, :admin)
    instructor = FactoryBot.create(:user, :instructor)
    sign_in adminUser 
    FactoryBot.create(:role, resource_id: @course.id, users: [adminUser])
    FactoryBot.create(:role, resource_id: @course2.id, users: [instructor])
    get "/api/courses/"
    assert_response :success
    assert_equal @course.id, JSON.parse(response.body)[0]["id"]
    assert_equal true, JSON.parse(response.body)[1]["can_control"]
    assert_equal @course2.id, JSON.parse(response.body)[1]["id"]
    assert_equal true, JSON.parse(response.body)[1]["can_control"]
    assert_equal 2, JSON.parse(response.body).length
  end

end
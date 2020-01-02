require 'test_helper'
require 'helpers/octokit_stub_helper'

class CourseJobsTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers
  include OctokitStubHelper

  setup do
    @course = courses(:course1)
    @course2 = courses(:course2)
    @roster_student = roster_students(:roster1)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user

    @user2 = User.create!(
        name: 'Chris',
        username: 'cgaucho',
        uid: 1234567,
        provider: 'GitHub',
        email: 'cgaucho@example.edu',
        password: 'a9sd8ua98fu9as'
    )
    @roster_student_with_github = RosterStudent.create!(
        perm: 1234,
        first_name: 'Chris',
        last_name: 'Gaucho',
        email: 'cgaucho@example.edu',
        course: @course2,
        enrolled: false,
        user: @user2
    )
    @roster_student_with_no_github = RosterStudent.create!(
        perm: 5678,
        first_name: 'Lyn',
        last_name: 'DelPlaya',
        email: 'ldelplaya@example.edu',
        course: @course2,
        enrolled: false,
        user: nil
    )
  end


  test "should return org member statuses from repo users table" do

  end

end

require 'test_helper'
require 'helpers/octokit_stub_helper'

class VisitorsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  include Devise::Test::IntegrationHelpers
  include OctokitStubHelper

  test "homepage should return 200 success" do
    get root_url
    assert_response :success
  end

  test "courses page requires login" do
    get courses_url
    assert_redirected_to new_user_session_url
  end

  test "when you are logged in you can see the courses page" do
    # sign in here
    @user = users(:tim)
    @user.add_role(:admin)
    sign_in @user
    get courses_url
    assert_response :success
  end

  test "user is redirected to github sign in" do
    @user = users(:tim)
    @user.add_role(:admin)
    # sign_in @user
    post user_github_omniauth_authorize_path
    #For some reason, this generates this print statement when testing:
    #I, [2018-02-16T16:54:53.885865 #1938]  INFO -- omniauth: (github) Request phase initiated.
    assert path.include?('github')
  end

  test "user can sign out" do
    @user = users(:tim)
    sign_in @user
    get signout_path
    assert_redirected_to root_url
  end

  private

  def stub_course_organization(org)
    stub_organization_membership_admin_in_org(org, ENV["MACHINE_USER_NAME"])
    stub_organization_is_an_org(org)
    stub_updating_org_membership(org)
  end

end

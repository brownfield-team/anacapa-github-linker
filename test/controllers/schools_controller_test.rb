require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @school = schools(:ucsb)
    @admin_user = users(:wes)
    @admin_user.add_role(:admin)
    @user = users(:tim)
    @instructor_user = users(:julie)
    @instructor_user.add_role(:instructor)

    sign_in @admin_user
  end

  test "should ge schools index" do
    get schools_url
    assert_response :success
  end

  test "access denied for schools index" do
    sign_in @user
    get schools_url
    assert_redirected_to root_path
  end

  test "access denied to instructors for schools index" do
    sign_in @instructor_user
    get schools_url
    assert_redirected_to root_path
  end

  test "access denied for schools new" do
    sign_in @user
    get new_school_url
    assert_redirected_to root_path
  end

  test "should get new" do
    get new_school_url
    assert_response :success
  end

  test "should create school" do
    assert_difference('School.count') do
      post schools_url, params: { school: { abbreviation: @school.abbreviation, name: @school.name } }
    end

    assert_redirected_to school_url(School.last)
  end

  test "should not create school without name" do
    assert_difference('School.count', 0) do
      post schools_url, params: { school: { abbreviation: @school.abbreviation} }
    end

    assert_response :ok
    assert_select 'div#error_explanation li', "Name can't be blank"
  end

  test "should not create school without abbreviation" do
    assert_difference('School.count', 0) do
      post schools_url, params: { school: { name: @school.name } }
    end

    assert_response :ok
    assert_select 'div#error_explanation li', "Abbreviation can't be blank"
  end

  test "should show school" do
    get school_url(@school)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_url(@school)
    assert_response :success
  end

  test "should update school" do
    patch school_url(@school), params: { school: { abbreviation: @school.abbreviation, name: @school.name } }
    assert_redirected_to school_url(@school)
  end

  test "should destroy school" do
    assert_difference('School.count', -1) do
      delete school_url(@school)
    end

    assert_redirected_to schools_url
  end
end

require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course2 = courses(:course2)
    visit "/test_hooks/login_admin"
  end

  test "visiting the index" do
    visit courses_url
  
    assert_selector "h1", text: "Course"
  end

end

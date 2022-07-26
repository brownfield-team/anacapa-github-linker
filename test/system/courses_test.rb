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

  test "instructors can download student roster as CSV" do
    visit course_path(@course2)

    click_on "Download Roster (CSV)"
    sleep 1
    
    csv_name = "#{@course2.name.parameterize}-students-#{Date.today}.csv"

    full_path = DOWNLOAD_PATH+"/"+csv_name

    assert File.exist?(full_path)
    actual_headers = CSV.open(full_path, 'r') { |csv| csv.first.to_s }

    assert_equal("[\"student_id\", \"email\", \"first_name\", \"last_name\", \"enrolled\", \"section\", \"github_username\", \"slack_uid\", \"slack_username\", \"slack_display_name\", \"org_status\", \"teams\"]",actual_headers,"Header does not match")
  end
end

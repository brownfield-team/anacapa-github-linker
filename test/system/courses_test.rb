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
    
    csv_name = "#{@course2.name.parameterize}-students-#{Date.today}.csv"
    
    full_path = DOWNLOAD_PATH+"/"+csv_name
    
    File.delete(full_path) if File.exist?(full_path)
      
    click_on "Download Roster (CSV)"
    sleep 1
    
    assert File.exist?(full_path)
    actual_headers = CSV.open(full_path, 'r') { |csv| csv.first.to_s }

    assert_equal("[\"student_id\", \"email\", \"first_name\", \"last_name\", \"enrolled\", \"section\", \"github_username\", \"slack_uid\", \"slack_username\", \"slack_display_name\", \"org_status\", \"teams\"]",actual_headers,"Header does not match")
  end

  test "instructors can download student roster as JSON" do
    visit course_path(@course2)
    
    json_name = "#{@course2.name.parameterize}-students-#{Date.today}.json"
    
    full_path = DOWNLOAD_PATH+"/"+json_name

    File.delete(full_path) if File.exist?(full_path)

    click_on "Download Roster (JSON)"
    sleep 1

    assert File.exist?(full_path)

    loaded = File.read(full_path)
    data_hash = JSON.parse(loaded)[0]

    actual_headers = data_hash.keys

    assert_equal(["perm", "email", "first_name", "last_name", "enrolled", "section", "username", "slack_uid", "slack_username", "slack_display_name", "org_member_status", "teams"],actual_headers,"Header does not match")
  end
end

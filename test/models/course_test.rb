require 'test_helper'
require 'csv'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  include Devise::Test::IntegrationHelpers    
  
  test "course_name" do
    assert_equal "course1", courses(:course1).name
  end

  setup do
    @course = courses(:course1)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user
  end

  test "calling import_students should import students from csv" do

    csv_file = fixture_file_upload('files/students.csv')

    csv_header_map = "student_id,email,first_name,last_name"
    assert_difference('@course.roster_students.count', 4) do
      @course.import_students(csv_file,csv_header_map,false)
    end

  end

  test "download to csv" do
    csv = @course.export_students_to_csv

    #NOTE: The roster_students do not yet have a github username but the exported csv provides a column for it
    expected_csv = "perm,email,first_name,last_name,github_username\n12345678,wes@email.com,Wes,P,\n21345678,tim@email.com,Tim,H,\n"
    puts "CSV: #{csv}"
    assert_equal csv, expected_csv
  end

end

require 'test_helper'

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

  test "calling unenroll_all_students should set enrolled to false" do
    enrolled_count = @course.roster_students.where(enrolled: true).count
    assert enrolled_count > 0

    @course.unenroll_all_students
    assert_equal 0, @course.roster_students.where(enrolled: true).count
  end

  test "calling import_students should import students from csv WITHOUT header" do

    csv_file = fixture_file_upload('files/students.csv')

    csv_header_map = ["perm","email","first_name","last_name"]
    assert_difference('@course.roster_students.where(enrolled: true).count', 2) do

      @course.import_students(csv_file,csv_header_map,false)
    end

  end

  test "calling import_students should import students from csv WITH header" do

    csv_file = fixture_file_upload('files/students.csv')

    csv_header_map = ["perm","email","first_name","last_name"]

    assert_difference('@course.roster_students.where(enrolled: true).count', 1) do
      @course.import_students(csv_file,csv_header_map,true)
    end

  end

  test "download to csv" do
    csv = @course.export_students_to_csv

    #NOTE: The roster_students do not yet have a github username but the exported csv provides a column for it
    expected_csv = "studentId,email,first_name,last_name,github_username,enrolled\n12345678,wes@email.com,Wes,P,,true\n21345678,tim@email.com,Tim,H,,true\n"
    assert_equal csv, expected_csv
  end

  test "importing a csv should not add duplicate students" do
    csv_file1 = fixture_file_upload('files/students.csv')
    csv_file2 = fixture_file_upload('files/students2.csv')

    csv_header_map = ["perm","email","first_name","last_name"]
    @course.import_students(csv_file1,csv_header_map,true)


    assert_difference('@course.roster_students.where(enrolled: true).count', 0) do
      @course.import_students(csv_file2,csv_header_map,true)
    end

  end

  test "roster_students emails for a course should be unique" do
    csv_file = fixture_file_upload("files/duplicate_email.csv")
    csv_header_map = ["perm","email","first_name","last_name"]

    assert_difference('@course.roster_students.where(enrolled: true).count', -1) do
      @course.import_students(csv_file,csv_header_map,true)
    end

  end

  test "roster_students perms for a course should be unique" do
    csv_file = fixture_file_upload("files/duplicate_perm.csv")
    csv_header_map = ["perm","email","first_name","last_name"]

    assert_difference('@course.roster_students.where(enrolled: true).count', -1) do
      @course.import_students(csv_file,csv_header_map,true)
    end

  end


end

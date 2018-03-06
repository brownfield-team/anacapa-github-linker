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

  test "calling import_students should import students from csv WITHOUT header" do

    csv_file = fixture_file_upload('files/students.csv')

    csv_header_map = ["perm","email","first_name","last_name"]
    assert_difference('@course.roster_students.count', 2) do
      @course.import_students(csv_file,csv_header_map,false)
    end

  end

  test "calling import_students should import students from csv WITH header" do

    csv_file = fixture_file_upload('files/students.csv')

    csv_header_map = ["perm","email","first_name","last_name"]
    assert_difference('@course.roster_students.count', 1) do
      @course.import_students(csv_file,csv_header_map,true)
    end

  end

  test "download to csv" do
    csv = @course.export_students_to_csv

    #NOTE: The roster_students do not yet have a github username but the exported csv provides a column for it
    expected_csv = "perm,email,first_name,last_name,github_username\n12345678,wes@email.com,Wes,P,\n21345678,tim@email.com,Tim,H,\n"
    assert_equal csv, expected_csv
  end

  test "importing a csv should not add duplicate students" do
    csv_file1 = fixture_file_upload('files/students.csv')
    csv_file2 = fixture_file_upload('files/students2.csv')

    csv_header_map = ["perm","email","first_name","last_name"]
    @course.import_students(csv_file1,csv_header_map,true)


    assert_difference('@course.roster_students.count', 0) do
      @course.import_students(csv_file2,csv_header_map,true)
    end

  end

  test "roster_students emails for a course should be unique" do
    csv_file = fixture_file_upload("files/duplicate_email.csv")
    csv_header_map = ["perm","email","first_name","last_name"]

    assert_difference('@course.roster_students.count', -1) do
      @course.import_students(csv_file,csv_header_map,true)
    end

  end

  test "roster_students perms for a course should be unique" do
    csv_file = fixture_file_upload("files/duplicate_perm.csv")
    csv_header_map = ["perm","email","first_name","last_name"]

    assert_difference('@course.roster_students.count', -1) do
      @course.import_students(csv_file,csv_header_map,true)
    end
  
  end

  test "sort perms into hash works" do
    csv_file = fixture_file_upload("files/students.csv")
    spreadsheet = Roo::Spreadsheet.open(csv_file, extension: 'csv')
    csv_header_map = ["perm","email","first_name","last_name"]
    header_map_index = csv_header_map.index("perm")

    perms = @course.sort_perms_into_hash(spreadsheet, true, header_map_index)
    assert_equal perms, {"123"=>"123", "8425"=>"8425", "1234"=>"1234"}
  end

  test "delete students from course that are not in the csv" do
    csv_file = fixture_file_upload("files/students.csv")
    spreadsheet = Roo::Spreadsheet.open(csv_file, extension: 'csv')
    csv_header_map = ["perm","email","first_name","last_name"]
    header_map_index = csv_header_map.index("perm")

    roster_student = RosterStudent.new(email: "email@test.email.com",
                                      first_name: "Jon",
                                      last_name: "Snow",
                                      perm: 8425)
    @course.roster_students.push(roster_student)
    
    assert_difference('@course.roster_students.count', -2) do
      @course.delete_roster_students(spreadsheet, true, header_map_index)
    end

    assert_equal "8425", @course.roster_students.first.perm
  end

end

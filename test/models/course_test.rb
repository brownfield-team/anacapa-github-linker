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
    skip "This test is a work in progress"
    csv_file = ["1234", "email@email.com", "tim", "G"].to_csv
    csv_header_map = "student_id,email,first_name,last_name"
    assert_difference('@course.roster_students.count', -1) do
      @course.import_students(csv_file,csv_header_map,false)
    end

  end

  test "download to csv" do 
  end

end

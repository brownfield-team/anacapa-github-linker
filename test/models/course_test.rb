require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "course_name" do
    assert_equal "course1", courses(:course1).name
  end
end

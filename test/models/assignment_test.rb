require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
 
  # See: https://johnmosesman.com/post/testing-a-rails-api/
  test "fixture is valid" do
    assert assignments(:one).valid?
  end

  # # See: https://johnmosesman.com/post/testing-a-rails-api/
  test "cannot create valid new object" do
    refute Assignment.new.valid?
  end

end

# spec/models/course.rb

require 'rails_helper'

RSpec.describe Course, :type => :model do
  it "is not valid without a name" do
    course = Course.new(name: nil)
    expect(course).to_not be_valid
  end
end
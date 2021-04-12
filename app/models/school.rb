class School < ApplicationRecord
  has_many :courses, :join_table => :courses_school
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true
end

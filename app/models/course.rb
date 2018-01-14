class Course < ApplicationRecord
  # validates :name,  presence: true,
  #                   length: { minimum: 3 }
  validates :name, presence: true, length: {minimum: 3}, uniqueness: true
  validates :course_organization, presence: true, length: {minimum: 3}, uniqueness: true
  has_and_belongs_to_many :users
  has_many :roster_students
  resourcify
end

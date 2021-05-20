class School < ApplicationRecord
  validates :name, presence: true
  validates :abbreviation, presence: true
  has_many :courses, dependent: :nullify
end

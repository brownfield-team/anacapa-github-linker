class SlackWorkspace < ApplicationRecord
  belongs_to :course
  has_many :slack_users, dependent: :destroy
end
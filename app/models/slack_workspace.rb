class SlackWorkspace < ApplicationRecord
  has_one :course, dependent: :nullify
end
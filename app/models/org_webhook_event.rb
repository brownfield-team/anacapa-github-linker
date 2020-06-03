class OrgWebhookEvent < ApplicationRecord
  belongs_to :course
  belongs_to :roster_student
  belongs_to :github_repo
end
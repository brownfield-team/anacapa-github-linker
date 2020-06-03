class OrgWebhookEvent < ApplicationRecord
  belongs_to :course
  belongs_to :roster_student, optional: true
  belongs_to :github_repo, optional: true
end
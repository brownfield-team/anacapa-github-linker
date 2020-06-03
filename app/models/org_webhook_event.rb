class OrgWebhookEvent < ApplicationRecord
  belongs_to :course
  belongs_to :roster_student, optional: true
  belongs_to :github_repo, optional: true

  def self.to_csv
    attributes = %w{id event_type payload roster_student_id github_repo_id }

    CSV.generate(headers: true) do |csv|
      csv << attributes + ['student_name', 'repo_name']

      all.each do |event|
        csv_row = attributes.map{ |attr| event.send(attr) }
        if event.roster_student.present?
          csv_row << event.roster_student.full_name
        else
          csv_row << ''
        end
        if event.github_repo.present?
          csv_row << event.github_repo.name
        else
          csv_row << ''
        end
        csv << csv_row
      end
    end
  end
end
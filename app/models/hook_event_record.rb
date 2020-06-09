class HookEventRecord < ApplicationRecord
  self.abstract_class = true
  belongs_to :github_repo, optional: true
  belongs_to :roster_student

  def as_json(options = {})
    super(options.merge(:include => {
        :github_repo => {},
        :roster_student => {}
    }))
  end
end
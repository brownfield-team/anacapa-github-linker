class HookEventRecord < ApplicationRecord
  self.abstract_class = true
  belongs_to :github_repo, optional: true
  belongs_to :roster_student

  def event_type
    self.class.name
  end

  def as_json(options = {})
    super(options.merge(:include => {
        :github_repo => {},
        :roster_student => {}
    }, :methods => [:event_type]))
  end
end
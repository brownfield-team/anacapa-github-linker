class SlackUser < ApplicationRecord
  belongs_to :roster_student
  belongs_to :slack_workspace

  def slack_url
    "slack://user?team=#{slack_workspace.team_id}&id=#{uid}"
  end
end
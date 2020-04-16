class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def github_machine_user
    Octokit_Wrapper::Octokit_Wrapper.machine_user
  end
end

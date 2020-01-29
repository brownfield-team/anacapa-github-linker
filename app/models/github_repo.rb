class GithubRepo < ApplicationRecord
  belongs_to :course
  has_many :repo_contributors
  has_many :users, through: :repo_contributors
end

class PopulateExternalColumn < ActiveRecord::Migration[5.2]
  def change
    GithubRepo.all.includes(:course).each do |repo|
      if repo.course.course_organization != repo.organization
        repo.external = true
      else
        repo.external = false
      end
      repo.save
    end
  end
end

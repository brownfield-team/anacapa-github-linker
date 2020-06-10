class Courses::GithubWebhooksController
  class RepositoryHook
    def self.process_hook(course, payload)
      repo_info = payload[:repository]
      existing_repo = GithubRepo.where(course: course, repo_id: repo_info[:id]).first
      case payload[:action]
      when "created"
        existing_repo.try(:destroy)
        repo_visibility = repo_info[:private] ? "private" : "public"
        GithubRepo.create(course: course, name: repo_info[:name], full_name: repo_info[:full_name], url: repo_info[:html_url], repo_id: repo_info[:id], visibility: repo_visibility)
      when "deleted"
        existing_repo.try(:destroy)
      when "edited"
        # Nothing to do here for now
      when "renamed"
        return if existing_repo.nil?
        existing_repo.name = payload[:repository][:name]
        existing_repo.full_name = payload[:repository][:full_name]
        existing_repo.save
      when "publicized"
        return if existing_repo.nil?
        existing_repo.visibility = "public"
        existing_repo.save
      when "privatized"
        return if existing_repo.nil?
        existing_repo.visibility = "private"
        existing_repo.save
      else
        return
      end
    end
  end
end
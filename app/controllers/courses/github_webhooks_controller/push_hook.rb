class Courses::GithubWebhooksController
  class PushHook
    def self.process_hook(course, payload)
      repo = GithubRepo.find_by_repo_id(payload[:repository][:id])
      branch = /refs\/heads\/(.*)/.match(payload[:ref])[1]
      student = course.student_for_uid(payload[:sender][:id])
      payload[:commits].each do |payload_commit|
        unless payload_commit[:distinct]
          next
        end
        commit = RepoCommitEvent.new
        commit.files_changed = payload_commit[:added].union(payload_commit[:removed], payload_commit[:modified]).size
        commit.message = payload_commit[:message]
        commit.commit_hash = payload_commit[:id]
        commit.url = payload_commit[:url]
        commit.commit_timestamp = payload_commit[:timestamp]
        commit.github_repo = repo
        commit.branch = branch
        commit.roster_student = student
        commit.save
      end
    end
  end
end
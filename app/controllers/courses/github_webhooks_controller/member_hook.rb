class Courses::GithubWebhooksController
  class MemberHook
    def self.process_hook(course, payload)
      user = User.where(uid: payload[:member][:id]).first
      repository = GithubRepo.where(repo_id: payload[:repository][:id]).first
      return if user.nil? || repository.nil?
      existing_contributor_record = RepoContributor.where(github_repo: repository, user: user).first
      case payload[:action]
        # GitHub's API has some kind of hilarious prank where this webhook won't give you the user's permission on the repository.
        # The kicker? When you change a user's repo permission it sends a webhook. But that webhook only contains
        # the OLD permission. Meaning: if you change a user's permission from read to write, it'll send you a webhook that basically says
        # "that user used to have read permission".
      when "added"
        existing_contributor_record.try(:destroy)
        permission_level = get_user_repo_permission(course, payload[:repository][:name], user.uid)
        RepoContributor.create(user: user, github_repo: repository, permission_level: permission_level)
      when "edited"
        return if existing_contributor_record.nil?
        existing_contributor_record.permission_level = get_user_repo_permission(course, payload[:repository][:name], user.uid)
        existing_contributor_record.save
      when "removed"
        existing_contributor_record.try(:destroy)
      else
        return
      end
    end

    def self.get_user_repo_permission(course, repo_name, user_id)
      response = github_machine_user.post '/graphql', { query: user_repo_permission_query(course, repo_name) }.to_json
      collaborators = response.data.repository.collaborators.edges
      user_collaborator = collaborators.find { |c| c.node.databaseId == user_id }
      return nil if user_collaborator.nil?
      user_collaborator.permission.capitalize
    end

    def self.user_repo_permission_query(course, repo_name)
      <<-GRAPHQL
        query { 
          repository(owner:"#{course.course_organization}",name:"#{repo_name}") {
            collaborators {
              edges {
                permission
                node {
                  databaseId
        } } } } }
      GRAPHQL
    end
  end
end
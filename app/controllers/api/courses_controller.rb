module Api
  class CoursesController < ApplicationController
    respond_to :json
    load_and_authorize_resource
    before_action :set_authorized_courses, only: [:index]
    include Response

    def index
      if !current_user.has_role?(:admin)
        @courses = Course.all.where(roster_students: current_user.roster_students)
        if current_user.has_role?(:instructor)
          @courses = [@courses.all, Course.with_role(:instructor, user=current_user).all].flatten.uniq
        end
      else
        @courses = Course.all
      end  
    end

    def graphql
      @course = Course.find(params[:course_id])
      query = params[:query]
      accept = params[:accept]
      results = perform_graphql_query(query,accept)
      json_response(results.to_hash)
    end

    def commits
      @course = Course.find(params[:course_id])
      json_response(@course.commits)
    end
    
    def orphans
      @course = Course.find(params[:course_id])
      orphan_author_emails = @course.orphan_author_emails.map{ |k,v| {email: k, count: v} }
      orphan_author_names = @course.orphan_author_names.map{ |k,v| {name: k, count: v} }
      response = { course: @course, orphan_author_emails: orphan_author_emails, orphan_author_names: orphan_author_names }
      json_response(response)
    end
  

    private

    def set_authorized_courses
      if current_user.has_role? :admin
        @authorized_courses = @courses
      else
        @authorized_courses = []
        @courses.each { |course|
          if RosterStudent.where(course_id: course.id, email: current_user.email).count > 0
            @authorized_courses.push(course)
          end
        }
        
        Course.with_role(:instructor, current_user).each { |course|
          @authorized_courses.push(course)
        }
      end
    end

    def perform_graphql_query(graphql_query_string, accept)
      puts("perform graphqlquery")
      data = {
          :query => graphql_query_string
      }.to_json
      options = accept ?  {
          :headers => {
          :accept => accept
          }
        } : {}
      result = github_machine_user.send :request, :post, '/graphql', data, options
      result
    end

    def github_machine_user
      Octokit_Wrapper::Octokit_Wrapper.machine_user
    end

  end
end

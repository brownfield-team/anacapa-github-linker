require 'Octokit_Wrapper'
require 'action_view'
include ActionView::Helpers::DateHelper

class AdminController < ApplicationController

    def dashboard
      authorize! :manage, :all
    end

    def flipper_features
      Flipper.features.map{|f| {name: f.name, enabled: Flipper.enabled?(f.name.to_sym,current_user)} }
    end
    helper_method :flipper_features

    # This is an intricate bit of code that formats the results of this really messed up SQL query into a dictionary
    # of table names and their corresponding row counts.
    # Source of query: https://stackoverflow.com/a/42121447/3950780
    def table_row_pairs
      raw_row_counts = ActiveRecord::Base.connection.tables.map { |t| {t=>
                    ActiveRecord::Base.connection.execute("select count(*) from #{t}")[0]} }
      total_rows_in_db = 0
      sanitized_row_counts = Hash.new
      raw_row_counts.each do |table_row_dict|
        table_row_hash = table_row_dict.first
        table_name = table_row_hash[0]
        row_count = table_row_hash[1]["count"]
        sanitized_row_counts[table_name] = row_count
        total_rows_in_db += row_count
      end
      sanitized_row_counts["Total"] = total_rows_in_db
      sanitized_row_counts
    end
    helper_method :table_row_pairs

    def admin_job_list
      [PurgeCompletedJobsJob, PurgeUnusedUsersJob]
    end
    helper_method :admin_job_list

    # List of jobs to make available to run
    def admin_job_info_list
      jobs = admin_job_list
      jobs_info = jobs.map { |j|
        j.instance_values.merge({
            "last_run" => j.itself.last_run,
            "job_description" => j.itself.job_description
         })
      }
      jobs_info
    end
    helper_method :admin_job_info_list

    def run_admin_job
      job_name = params[:job_name]
      job = admin_job_list.find { |job| job.job_short_name == job_name }
      job.perform_async
      redirect_to dashboard_admin_path
    end

    def rate_limits
      rate_limits = Hash.new
      rate_limits["GitHub v3 API (REST)"] = github_v3_rate_limit
      rate_limits["GitHub v4 API (GraphQL)"] = github_v4_rate_limit
      rate_limits
    end
    helper_method :rate_limits

  private
    def github_v3_rate_limit
      limit_response = github_machine_user.rate_limit
      if limit_response.respond_to? :limit
        reset_time = Time.at(limit_response.resets_at)
        return {"remaining": limit_response.remaining, "limit": limit_response.limit, "reset": reset_time,
                "until_reset": distance_of_time_in_words_to_now(reset_time), "info": "GitHub Machine User: " +
                ENV['MACHINE_USER_NAME']}
      end
      {"error": "Rate limit API request failed. Try refreshing the page."}
    end

    def github_v4_rate_limit
      limit_response = github_machine_user.post '/graphql', { query: rate_limit_graphql_query }.to_json
      if limit_response.respond_to? :data
        rateLimitInfo = limit_response.data.rateLimit
        reset_time = Time.parse(rateLimitInfo.resetAt)
        return {"remaining": rateLimitInfo.remaining, "limit": rateLimitInfo.limit, "reset": reset_time,
                "until_reset": distance_of_time_in_words_to_now(reset_time), "info": "GitHub Machine User: " +
                limit_response.data.viewer.login}
      end
      {"error": "Rate limit API request failed. Try refreshing the page."}
    end

    def rate_limit_graphql_query
      <<-GRAPHQL
        query {
          viewer {
            login
          }
          rateLimit {
            remaining
            limit
            resetAt
          }
        }
      GRAPHQL
    end
end
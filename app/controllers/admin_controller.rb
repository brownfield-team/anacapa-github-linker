class AdminController < ApplicationController

  def dashboard
    authorize! :dashboard, :admin
  end

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

  def run_admin_job
    job_name = params[:job_name]
    job = admin_job_list.find { |job| job.job_short_name == job_name }
    job.perform_async
    redirect_to admin_dashboard_path
  end

end
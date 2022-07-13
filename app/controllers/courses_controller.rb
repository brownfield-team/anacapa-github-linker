require 'Octokit_Wrapper'

class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  layout 'courses', except: :index

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @default_member_permission = @course.github_org_default_member_permission
  end

  # # GET /courses/new
  # def new
  #   @course = Course.new
  # end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        add_instructor(@course.id)
        @course.accept_invite_to_course_org
        if @course.github_webhooks_enabled
          @course.add_webhook_to_course_org
        end
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    # Allows the webhook handler in the model to get the full url path. Kind of a hack, we can maybe accomplish this better using env variables
    Rails.application.routes.default_url_options[:host] = request.base_url
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_ta
    @course = Course.find(params[:course_id])
    authorize! :update_ta, @course
    @roster_student = RosterStudent.find(params[:student_id])
    user = @roster_student.user
    return redirect_to course_roster_student_path(@course, @roster_student), notice: "Could not find user for that student." if user.nil?
    user.change_ta_status(@course)
    redirect_to course_roster_student_path(@course, @roster_student), notice: "Successfully modified #{@roster_student.first_name}'s TA status"
  end

  def join
    @course = Course.find(params[:course_id])
    # roster_student = course.roster_students.find_by(email: current_user.email)
    roster_student = cross_check_user_emails_with_class(@course)
    if roster_student.nil?
      message = 'Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verified your email address. '
      return redirect_to root_path, alert: message
    end

    begin
       @course.invite_user_to_course_org(current_user)
       roster_student.update_attribute(:enrolled, true)
       current_user.roster_students.push(roster_student)
    rescue Exception => e
      message = "Unable to invite #{current_user.username} to #{course.course_organization}; check whether #{ENV['MACHINE_USER_NAME']} has admin permission on that org.   Error: #{e.message}"
      redirect_to root_path, alert: message
    end
  end

  def jobs
    @course = Course.find(params[:course_id])
    authorize! :jobs, @course
  end

  def informed_consents
    @course = Course.find(params[:course_id])
    authorize! :informed_consents, @course
  end

  def teams
    @course = Course.find(params[:course_id])
    authorize! :teams, @course
  end

  def events
    @course = Course.find(params[:course_id])
    authorize! :events, @course
    respond_to do |format|
      format.html
      format.csv {
        send_data @course.org_webhook_events.to_csv, filename: "#{@course.name}-events.csv"
      }
    end
  end

  def run_course_job
    job_name = params[:job_name]
    job = course_job_list.find { |job| job.job_short_name == job_name }
    # This is a hack. It should be replaced as soon as possible, hopefully after authorization in the app is redone.
    if job.permission_level == "admin" && !user.has_role?("admin")
      redirect_to course_jobs_path, alert: "You do not have permission to run this job. Ask an admin to run it for you."
    end
    job.perform_async(params[:course_id].to_i)
    if params[:redirect_url]
      redirect_to params[:redirect_url], notice: "Job successfully queued"
    else
      redirect_to course_jobs_path, notice: "Job successfully queued."
    end
  end

  # List of course jobs to make available to run
  def course_job_list
    @course = Course.find(params[:course_id])
    jobs = [TestJob, StudentsOrgMembershipCheckJob, UpdateGithubReposJob, RefreshGithubTeamsJob, RefreshProjectRepoCommitsJob, RefreshProjectRepoIssuesJob,RefreshProjectRepoPullRequestsJob,PurgeCourseReposJob, FixOrphanCommitsJob]
    if @course.slack_workspace.present?
      jobs << AssociateSlackUsersJob
    end
    jobs
  end
  helper_method :course_job_list

  # List of course jobs to make available to run
  def course_job_info_list
    jobs = course_job_list
    jobs_info = jobs.map{ |j| 
      j.instance_values.merge({ 
        "last_run" => j.itself.last_run,
        "job_description" => j.itself.job_description
        }
      )  
    }
    jobs_info
  end
  helper_method :course_job_info_list

  def repos
    @course = Course.find(params[:course_id])
    @repos = GithubRepo.where(course_id: params[:course_id]).where("name ~* ?", params[:search]).order(:name)
    authorize! :repos, @course
  end

  def search_repos
    @course = Course.find(params[:course_id])
    redirect_to course_repos_path(@course, search: params[:search])
  end

  def create_repos
    @course = Course.find(params[:course_id])
  end

  def generate_repos
    @course = Course.find(params[:course_id])
    assignment_name = params[:assignment_name]
    permission_level = params[:permission]
    visibility = params[:visibility]
    unless legal_repo_name(assignment_name)
      redirect_to course_create_repos_path, alert: "Assignment name must be a legal repo name (letters, digits, hyphen, underscore, no spaces)"
      return
    end
    options = {:assignment_name => assignment_name,  :permission_level => permission_level, :visibility => visibility}
    CreateAssignmentReposJob.perform_async(@course.id, options)
    redirect_to course_jobs_path, notice: "Repository creation successfully queued."
  end

  def legal_repo_name(str)
    str =~ /^[\w-]+$/
  end

  def project_repos
    @course = Course.find(params[:course_id])
  end

  def commits
    @course = Course.find(params[:course_id])
    respond_to do |format|
      format.csv { send_data @course.export_commits_to_csv, filename: "#{@course.course_organization}-commits-#{Date.today}.csv" }
    end
  end

  def issues
    @course = Course.find(params[:course_id])
    respond_to do |format|
      format.csv { send_data @course.export_issues_to_csv, filename: "#{@course.course_organization}-issues-#{Date.today}.csv" }
    end
  end

  def pull_requests
    @course = Course.find(params[:course_id])
    respond_to do |format|
      format.csv {send_data @course.export_pull_requests_to_csv, filename:"#{@course.course_organization}-pull_requests-#{Date.today}.csv"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name,:course_organization,:hidden, :search, :github_webhooks_enabled, :term, :school_id, :start_date, :end_date)
    end

    def add_instructor(id)
      current_user.add_role :instructor, Course.find(id)
    end

    def session_user
      client = Octokit_Wrapper::Octokit_Wrapper.session_user(session[:token])
    end

    def cross_check_user_emails_with_class(course)
      email_to_student = Hash.new
      course.roster_students.each do |student|
        email_to_student[student.email.downcase] = student
        if student.email.end_with? '@umail.ucsb.edu'
          new_email = student.email.gsub('@umail.ucsb.edu','@ucsb.edu')
          email_to_student[new_email] = student
        elsif student.email.end_with? '@ucsb.edu'
          old_email = student.email.gsub('@ucsb.edu','@umail.ucsb.edu')
          email_to_student[old_email.downcase] = student
        end
      end

      session_user.emails.each do |email|
        roster_student = email_to_student[email[:email].downcase]
        if roster_student
          return roster_student
        end
      end
      return nil
    end

end

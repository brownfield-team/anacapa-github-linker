require 'Octokit_Wrapper'

class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
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

  def view_ta
    @course = Course.find(params[:course_id])
    authorize! :view_ta, @course
  end

  def update_ta
    course = Course.find(params[:course_id])
    authorize! :update_ta, course

    user = User.find(params[:user_id])
    user.change_ta_status(course)
    redirect_to course_view_ta_path(course), notice: %Q[Successfully modified #{user.name}'s TA status]

  end

  def join
    course = Course.find(params[:course_id])
    # roster_student = course.roster_students.find_by(email: current_user.email)
    roster_student = cross_check_user_emails_with_class(course)
    if roster_student.nil?
      message = 'Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verified your email address. '
      return redirect_to courses_path, alert: message
    end
    
    begin
       course.invite_user_to_course_org(current_user)
       roster_student.update_attribute(:enrolled, true)
       current_user.roster_students.push(roster_student)
       redirect_to courses_path, notice: %Q[You were successfully invited to #{course.name}! View and accept your invitation <a href="https://github.com/orgs/#{course.course_organization}/invitation">here</a>.]
    rescue Exception => e
      message = "Unable to invite #{current_user.username} to #{course.course_organization}; check whether #{ENV['MACHINE_USER_NAME']} has admin permission on that org.   Error: #{e.message}"
      redirect_to courses_path, alert: message
    end
  end


  def is_org_member(username)
    machine_user.organization_member?(@course.course_organization, username)
  end
  helper_method :is_org_member

  def jobs
    @course = Course.find(params[:course_id])
    authorize! :jobs, @course
  end

  def trigger_test_job
    TestJob.perform_in(5, "/courses/" + params[:course_id] + "/jobs", params[:course_id])
    redirect_to course_jobs_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name,:course_organization,:hidden)
    end

    def add_instructor(id)
      current_user.add_role :instructor, Course.find(id)
    end
    
    def machine_user
      client = Octokit_Wrapper::Octokit_Wrapper.machine_user
    end

    def session_user
      client = Octokit_Wrapper::Octokit_Wrapper.session_user(session[:token])
    end

    def cross_check_user_emails_with_class(course)
      email_to_student = Hash.new
      course.roster_students.each do |student|
        email_to_student[student.email] = student
        if student.email.end_with? '@umail.ucsb.edu'
          new_email = student.email.gsub('@umail.ucsb.edu','@ucsb.edu')
          email_to_student[new_email] = student
        elsif student.email.end_with? '@ucsb.edu'
          old_email = student.email.gsub('@ucsb.edu','@umail.ucsb.edu')
          email_to_student[old_email] = student
        end
      end

      session_user.emails.each do |email|
        roster_student = email_to_student[email[:email]]
        if roster_student
          return roster_student
        end
      end
      return nil
    end

end

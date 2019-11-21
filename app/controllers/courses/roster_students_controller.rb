# This controller is nested in the routing hierarchy as a child controller of 
# courses_controller
# see this tutorial for details on how we do this https://gist.github.com/jhjguxin/3074080
require 'Octokit_Wrapper'

module Courses 
  class RosterStudentsController < ApplicationController
    before_action :load_parent
    before_action :set_roster_student, only: [:show, :edit, :update, :destroy]
    
    load_and_authorize_resource :course
    load_and_authorize_resource :roster_student, through: :course

    # GET /roster_students
    # GET /roster_students.json
    def index
      @roster_students = @parent.roster_students.all

      respond_to do |format|
        format.html
        format.csv { send_data @parent.export_students_to_csv, filename: "students-#{Date.today}.csv" }
      end
    end

    def import
      if params.has_key? :file
        @parent.import_students(params[:file], params[:csv_header_map].split(','), params[:csv_header_toggle] == "true")
        redirect_to course_path(@parent), notice: 'Students imported.'
      else
        redirect_to course_path(@parent), alert: 'Please specify a file.'
      end
    end

    # GET /roster_students/1
    # GET /roster_students/1.json
    def show
      @roster_student = @parent.roster_students.find(params[:id])
    end

    # GET /roster_students/new
    def new
      @roster_student = @parent.roster_students.new 
    end

    # GET /roster_students/1/edit
    def edit
    end

    # POST /roster_students
    # POST /roster_students.json
    def create
      @roster_student = @parent.roster_students.new(roster_student_params)

      respond_to do |format|
        if @roster_student.save
          format.html { redirect_to course_path(@parent), notice: 'Roster student was successfully created.' }
          format.json { render :show, status: :created, location: @roster_student }
        else
          format.html { render :new }
          format.json { render json: @roster_student.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /roster_students/1
    # PATCH/PUT /roster_students/1.json
    def update
      respond_to do |format|
        if @roster_student.update(roster_student_params)
          format.html { redirect_to course_path(@parent), notice: 'Roster student was successfully updated.' }
          format.json { render :show, status: :ok, location: @roster_student }
        else
          format.html { render :edit }
          format.json { render json: @roster_student.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /roster_students/1
    # DELETE /roster_students/1.json
    def destroy
      @roster_student.destroy
      respond_to do |format|
        format.html { redirect_to course_path(@parent), notice: 'Roster student was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def find_org_repos
      @roster_student.user.github_repos
    end
    helper_method :find_org_repos

    def find_other_contributors(repo_name)
      student_list = @roster_student.user.github_repos.users.select { |user| user.id != @roster_student.user.id}
      other_contributor_string(student_list)
    end
    helper_method :find_other_contributors

    def other_contributor_string(student_list)
      other_contributor_string = ""
      contributors.each do |student|
        other_contributor_string += student.first_name + " " + student.last_name + ", "
      end
      if other_contributor_string != ""
        other_contributor_string = other_contributor_string[0..-3]
      end
      # Not supported before Ruby 2.5:
      # other_contributor_string.delete_suffix(", ")
      other_contributor_string
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_roster_student
        @roster_student = RosterStudent.find(params[:id])
      end

      def machine_user
        client = Octokit_Wrapper::Octokit_Wrapper.machine_user
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def roster_student_params
        params.require(:roster_student).permit(:perm, :first_name, :last_name, :email, :enrolled)
      end

      def load_parent
        @parent = Course.find(params[:course_id])
      end
  end

end
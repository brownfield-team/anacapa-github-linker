module Courses
  class AssignmentsController < ApplicationController
    layout 'courses'
    before_action :load_parent
    before_action :set_assignment, only: [:show, :edit, :update, :destroy]

    load_and_authorize_resource :course
    load_and_authorize_resource :assignment, through: :course

    # GET /assignments
    # GET /assignments.json
    def index
      @assignments = @parent.assignments.all
    end

    # GET /assignments/1
    # GET /assignments/1.json
    def show
      @course = Course.find(params[:course_id])
      @assignment = Assignment.find(params[:id])

    end

    # GET /assignments/new
    def new
      @assignment = Assignment.new
    end

    # GET /assignments/1/edit
    def edit
    end

    # POST /assignments
    # POST /assignments.json
    def create
      @assignment = Assignment.new(assignment_params)

      respond_to do |format|
        if @assignment.save
          format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
          format.json { render :show, status: :created, location: @assignment }
        else
          format.html { render :new }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /assignments/1
    # PATCH/PUT /assignments/1.json
    def update
      respond_to do |format|
        if @assignment.update(assignment_params)
          format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
          format.json { render :show, status: :ok, location: @assignment }
        else
          format.html { render :edit }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /assignments/1
    # DELETE /assignments/1.json
    def destroy
      @assignment.destroy
      respond_to do |format|
        format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def load_parent
        @parent = Course.find(params[:course_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_assignment
        @assignment = Assignment.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def assignment_params
        params.require(:assignment).permit(:name, :course_id)
      end
  end
end
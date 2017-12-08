class AssignmentsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
  end

  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.js
      end
    end
  end

  def destroy
    Assignment.find(params[:id]).destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:project_id, :user_id)
  end
end
